//
//  InformationViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/16/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnPicker: UIButton!
    
    var toiletList = [Toilet]()
    
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

        setupNavigationItem()
        setupRevealViewController()
        setupButton()
        setupMapView()
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
        switch selected {
        case .UbikeStation:
            //show UbikeStation on map
            print("UbikeStation")
        case .Toliet:
            // show toliet on map
            print("Toliet")
            HttpHelper.getInstance().getToilet() { [unowned self] in
                self.loadingFinished()
            }
        }
    }

    func loadingFinished() {
        toiletList = HttpHelper.getInstance().getToiletList()
//        print("here \(toiletList.count)")
        for toilet in toiletList {
            showMarkOnMap(toilet.latitude, longtitude: toilet.longitude)
        }
        
    }
}

extension InformationViewController: MKMapViewDelegate {
    
//    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    func showMarkOnMap(latitude: Double, longtitude: Double) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        mapView.addAnnotation(annotation)
        
//        let location = CLLocationCoordinate2D( latitude: latitude, longitude: longtitude )
//        let span = MKCoordinateSpanMake(0.02, 0.02)
//        let region = MKCoordinateRegion(center: location, span: span)
//        
//        mapView.setRegion(region, animated: true)
        
    }

}


extension InformationViewController: CLLocationManagerDelegate {

}

class HalfSizePresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height / 2)
    }
}
