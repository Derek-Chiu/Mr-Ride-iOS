//
//  InformationViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/16/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnPicker: UIButton!
    
    @IBOutlet weak var informationShowCard: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var minsLabel: UILabel!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var toiletList = [Toilet]()
    var stationList = [Station]()
    var annotationsOnMap = [CustomPointAnnotation]()
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    var currentSelected = PickerOption.UbikeStation
    
    var icon: UIImage {
        get {
            switch currentSelected {
            case .UbikeStation:
                return UIImage(named: "icon-station")!
            case .Toliet:
                return UIImage(named: "icon-toilet")!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupRevealViewController()
        setupButton()
        setupMapView()
        setupLocationManager()
        pickerselected(currentSelected)
        informationShowCard.hidden = true
        indicatorView.color = UIColor.mrDenimBlueColor()
        indicatorView.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pickerselected(currentSelected)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationItem() {
        
        self.title = "MAP"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        btnSideMenu.tintColor = UIColor.whiteColor()
        
        // let navigationvar shadow gone
        let shadowImg = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImg
        navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setupButton() {
        btnPicker.addTarget(self, action: #selector(showPicker), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupMapView()  {
        self.mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func showPicker() {
        let pickerVC = storyboard!.instantiateViewControllerWithIdentifier("PickerViewController") as! PickerViewController
        pickerVC.modalPresentationStyle = .Custom
        pickerVC.transitioningDelegate? = self
        pickerVC.pickerDelegate = self
        self.presentViewController(pickerVC, animated: true, completion: nil)
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presentingViewController: presentingViewController!)
    }
    
    deinit {
        print("InformationPage deinit")
    }
}

extension InformationViewController: PickerDelegate {
    
    func pickerselected(selected: PickerOption) {
        
        informationShowCard.hidden = true
        indicatorView.startAnimating()
        switch selected {
        case .UbikeStation:
            currentSelected = selected
            HttpHelper.getInstance().getStations() { [weak weakSelf = self] in
                weakSelf?.loadingFinished()
            }
            btnPicker.titleLabel?.text = "Ubike Station"
        case .Toliet:
            if currentSelected == selected {
                indicatorView.stopAnimating()
                return
            }
            currentSelected = selected
            btnPicker.titleLabel?.text = "Toilet"
            // check data in coredata
            if ToiletRecorder.getInstance().fetchData()?.count != 0 {
                toiletList = ToiletRecorder.getInstance().fetchData()!
                indicatorView.stopAnimating()
                showMarkOnMap()
                return
            }
            
            // no data in coredata then fire http GET
//            print("no item")
            ToiletRecorder.getInstance().deleteData()
            HttpHelper.getInstance().getToilet() { [weak weakSelf = self] in
                weakSelf?.loadingFinished()
            }
            
        }
    }
    
    
    func loadingFinished() {
        switch currentSelected {
        case .Toliet:
            toiletList = ToiletRecorder.getInstance().fetchData()!
            showMarkOnMap()
            
        case .UbikeStation:
            stationList = HttpHelper.getInstance().getStationList()
            showMarkOnMap()
        }
        
        indicatorView.stopAnimating()
    }
    
    
}

extension InformationViewController: MKMapViewDelegate {
    
    //    func showMarkOnMap(latitude: Double, longtitude: Double) {
    
    func showMarkOnMap() {

        mapView.removeAnnotations(annotationsOnMap)
        annotationsOnMap.removeAll()
    
        switch currentSelected {
        case .UbikeStation:
            for station in stationList {
                let annotation = CustomPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
                annotation.category = station.area
                annotation.name = station.name
                annotation.location = station.location
                annotation.title = String(station.bikeleft)
                annotation.subtitle = String(station.bikeSpace)
                annotation.isAvaliable = station.isAvailable
                annotationsOnMap.append(annotation)
                mapView.addAnnotation(annotation)
            }
        case .Toliet:
            for toilet in toiletList {
                let annotation = CustomPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(toilet.latitude!), longitude: Double(toilet.longitude!))
                annotation.category = toilet.category == nil ? "" : toilet.category!
                annotation.name = toilet.name == nil ? "" : toilet.name!
                annotation.location = toilet.address == nil ? "" : toilet.address!
                annotationsOnMap.append(annotation)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        view.backgroundColor = UIColor.mrLightblueColor()
        informationShowCard.hidden = false
        if let annotation = view.annotation as? CustomPointAnnotation {
            categoryLabel.text = annotation.category
            nameLabel.text = annotation.name
            addressLabel.text = annotation.location
//            MKDirectionsRequest.
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        view.backgroundColor = UIColor.whiteColor()
        informationShowCard.hidden = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var identifier = ""
        switch currentSelected {
        case .UbikeStation:
            identifier = "UbikeAnnotationView"
        case .Toliet:
            identifier = "ToiletAnnotationView"
        }
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? CustomAnnotationView
        
        if pinView == nil {
            pinView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView?.setCustomImage(icon)
        }
        return pinView
    }
    
}


extension InformationViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}

class HalfSizePresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height / 2)
    }
}
