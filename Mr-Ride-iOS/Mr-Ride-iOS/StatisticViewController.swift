//
//  StatisticViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/26/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import CoreLocation

class StatisticViewController: UIViewController {
    
    
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var labelAvgSpeed: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelTotalTime: UILabel!
    @IBOutlet weak var mapViewContainer: UIView!
    
    var btnClose: UIBarButtonItem?
    var distance = 0.0
    var duringTime = 0.0
    var locations = []
    var mapViewController = MapViewController()
    var runID = "";
    weak var dismissDelegate: TrackingDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButton()
        setupMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupBackground() {
        let color1 = UIColor.mrBlack60Color()
        let color2 = UIColor.mrBlack40Color()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.translucent = false
    }
    
    func setupButton() {
        // if from tracking page then button is "close", otherwise button is "back" as default
        if dismissDelegate != nil {
        btnClose = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(dismissSelf))
            navigationItem.leftBarButtonItem = btnClose
        }
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func setupData() {
        // get from core data
        let locationRecorder = LocationRecorder.getInstance()
        
        guard let run = locationRecorder.getDataWithID(runID) else {
            print("no this run data in database")
            return
        }
        
        // setup labels data from last page (tracking page)
        // labelTotalDistance
        labelTotalDistance.text = String(format: "%.2f km", Double(run.distance!) / 1000)
        // labelAvgSpeed
        labelAvgSpeed.text = String(format: "%.2f km / h", Double(run.distance!) * 3.6 / Double(run.during!) )
        // labelCalories
        labelCalories.text = String(0)
        // labelTotalTime
        guard let counter = run.during as? Double else {
            return
        }
        
        let minuteSecond = Int(counter % 1 * 100)
        let second = Int(counter) % 60
        let minutes = Int(counter / 60) % 60
        let hours = Int(counter / 60 / 60) % 99
        labelTotalTime.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, second, minuteSecond)
        
        mapViewController.loadMap(run)
        
    }
    
    func setupMap() {
        mapViewContainer.layer.cornerRadius = 10
        mapViewController.view.frame = mapViewContainer.bounds
        mapViewController.view.layer.cornerRadius = 10
        mapViewController.view.clipsToBounds = true
        self.addChildViewController(mapViewController)
        mapViewContainer.addSubview(mapViewController.view)
        mapViewController.didMoveToParentViewController(self)
    }
    
    func dismissSelf(sender: AnyObject) {
        mapViewController.removeFromParentViewController()
        if dismissDelegate != nil {
            dismissViewControllerAnimated(true, completion: nil)
            dismissDelegate?.dismissVC()
        }
        
    }
    

}
