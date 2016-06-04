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
    var mapView: MKMapView!
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
//        print("viewDidLoad")
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear")
        mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = self
        setupMapView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print("viewDidAppear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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

}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
//            print("drawing")
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
