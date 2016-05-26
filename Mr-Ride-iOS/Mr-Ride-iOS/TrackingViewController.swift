//
//  RidingViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/24/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import MapKit

class TrackingViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelCurrentDistance: UILabel!
    @IBOutlet weak var labelAverageSpeed: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var btnStartAndPause: UIButton!
    
    var isRidding = false
    var btnCancel: UIBarButtonItem?
    var btnFinish: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupDistance()
        setupAvgSpeed()
        setupCalories()
        setupTimer()
        setupButton()
        setupMap()
    }
    
    func setupBackground() {
        let color1 = UIColor.mrBlack60Color()
        let color2 = UIColor.whiteColor()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.translucent = false
    }
    
    func setupDistance() {
        labelCurrentDistance.text = "distance!"
    }
    
    func setupAvgSpeed() {
        labelAverageSpeed.text = "Avg Speed!"
    }
    
    func setupCalories() {
        labelCalories.text = "Calories so far"
    }
    
    func setupTimer() {
        labelTimer.text = "00:00:00"
    }
    
    func setupButton() {
        btnStartAndPause.addTarget(self, action: #selector(startAndStopRidding), forControlEvents: UIControlEvents.TouchUpInside)
        btnStartAndPause.layer.cornerRadius = btnStartAndPause.frame.size.width / 2
        btnStartAndPause.clipsToBounds = true
        
        btnCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain , target: self , action: #selector(dismissSelf))
        btnFinish = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain , target: self , action: #selector(finishRidding))
        self.navigationItem.leftBarButtonItem = btnCancel
        self.navigationItem.rightBarButtonItem = btnFinish
    }
    
    func setupMap() {
        self.mapView.delegate = self
        mapView.layer.cornerRadius = 10
    }
    
    func startAndStopRidding() {
        if isRidding {
            // stop them
            isRidding = false
        } else {
            // start calculating distance
            // start calculating avg speed
            // start calculating calories
            // start timmer
            // start tracking on map
            isRidding = true
        }
        print("ridding " + "\(isRidding)")
    }
    
   func dismissSelf(sender: AnyObject) {
        print("here")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func finishRidding(sender: AnyObject) {
        print("here")
//        dismissViewControllerAnimated(true, completion: nil)
        let statisticViewController = storyboard?.instantiateViewControllerWithIdentifier("statisticViewController") as! StatisticViewController
        navigationController?.pushViewController(statisticViewController, animated: true)
    }
}
