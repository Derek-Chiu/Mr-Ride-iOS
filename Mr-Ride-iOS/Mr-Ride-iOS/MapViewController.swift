//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/1/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var distance = 0.0
    weak var mapView: MKMapView!
    var locations = [CLLocation]()
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        setupMapView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mapView = nil
    }
    
    func setupMapView() {
        
        view.addSubview(mapView)
        
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mapView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: mapView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: mapView.superview, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: mapView.superview, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
    
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
//        mapView.bindFrameToSuperviewBounds()
    }
    
    deinit {
        print("deinit mapviewcontroller")
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 3
            return renderer
        } else {
            return MKOverlayRenderer()
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
//            print("updating")
            let howRecent = location.timestamp.timeIntervalSinceNow
            if abs(howRecent) < 10 && location.horizontalAccuracy < 20 {
                // update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                    var coords = [CLLocationCoordinate2D]()
                    coords.append(self.locations.last!.coordinate)
                    coords.append(location.coordinate)
                    let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
                    mapView.setRegion(region, animated: true)
                    mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
                }
                // save location
                self.locations.append(location)
            }
        }
    }

}

// MARK: -
extension MapViewController {
    
    func loadMap(run: Run) {
        if run.location!.count > 0 {
            //set the map bounds
            mapView.showsUserLocation = false
            mapView.region = mapRegion(run)
            
            var coords = [CLLocationCoordinate2D]()
            
            let locations = run.location!.array as! [Location]
            for location in locations {
                coords.append(CLLocationCoordinate2D(latitude:  location.latitude!.doubleValue, longitude: location.longitude!.doubleValue))
            }
            mapView.addOverlay(MKPolyline(coordinates: &coords, count: coords.count))
        } else {
//            UIAlertView(title: "Error", message: "Sorry, this run has no locations saved", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }

    func mapRegion(run: Run) -> MKCoordinateRegion {
        
        let initialLoc = run.location!.firstObject as! Location
        
        var minLat = initialLoc.latitude!.doubleValue
        var minLng = initialLoc.longitude!.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        
        let locations = run.location!.array as! [Location]
        
        for location in locations {
            minLat = min(minLat, location.latitude!.doubleValue)
            minLng = min(minLng, location.longitude!.doubleValue)
            maxLat = max(maxLat, location.latitude!.doubleValue)
            maxLng = max(maxLng, location.longitude!.doubleValue)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLng + maxLng) / 2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.1, longitudeDelta: (maxLng - minLng) * 1.1)
        )
    }

}

// MARK: - UI extension

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
}
