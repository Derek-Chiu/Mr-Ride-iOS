//
//  RidingViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/24/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

protocol TrackingDelegate: class {
    func dismissVC()
}

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var labelCurrentDistance: UILabel!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var labelCalories: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var btnStartAndPause: UIButton!
    @IBOutlet weak var mapViewContainer: UIView!

    weak var dismissDelegate: TrackingDelegate?
    
    // temp
    var managedObjectContext: NSManagedObjectContext?
    
    var isRidding = false
    var btnCancel: UIBarButtonItem?
    var btnFinish: UIBarButtonItem?
    var counter = 0.0
    var timer = NSTimer()
    let mapViewController = MapViewController()
    
    let middleIcon = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupDistance()
        setupSpeed()
        setupCalories()
        setupTimer()
        setupButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear \(self.dynamicType)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear \(self.dynamicType)")
        setupBackground()
    }
    
    deinit {
        print("deinit \(self.dynamicType)")
    }
    
    func setupBackground() {
        let color1 = UIColor.mrBlack60Color()
        let color2 = UIColor.mrBlack40Color()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.translucent = false
    }
    
    func setupDistance() {
        labelCurrentDistance.text = String(format: "%.2f km", mapViewController.distance / 1000)
    }
    
    func setupSpeed() {
        labelSpeed.text = String(format: "%.2f m/s", mapViewController.distance / counter)
    }
    
    func setupCalories() {
        labelCalories.text = "Calories so far"
    }
    
    func setupTimer() {
        let minuteSecond = Int(counter % 1 * 100)
        let second = Int(counter) % 60
        let minutes = Int(counter / 60) % 60
        let hours = Int(counter / 60 / 60) % 99
        //        print(minuteSecond)
        labelTimer.text = String(format: "%02d:%02d:%02d.%02d", hours, minutes, second, minuteSecond)
        counter = counter + 0.05
        //        print(counter)
    }
    
    func eachSecond() {
        setupDistance()
        setupSpeed()
        setupCalories()
        setupTimer()
    }
    
    func setupButton() {
        btnStartAndPause.addTarget(self, action: #selector(startAndStopRidding), forControlEvents: UIControlEvents.TouchUpInside)
        btnStartAndPause.layer.cornerRadius = btnStartAndPause.frame.size.width / 2
        btnStartAndPause.layer.borderColor = UIColor.whiteColor().CGColor
        btnStartAndPause.layer.borderWidth = 3.0
        btnStartAndPause.backgroundColor = UIColor.clearColor()
        btnStartAndPause.clipsToBounds = true
       
        middleIcon.frame.size = CGSize(width: 30, height: 30)

        middleIcon.userInteractionEnabled = false
        middleIcon.backgroundColor = UIColor.redColor()
        middleIcon.center = CGPoint(x: btnStartAndPause.bounds.width / 2, y: btnStartAndPause.bounds.height / 2)
        btnStartAndPause.addSubview(middleIcon)
        
        
        btnCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain , target: self , action: #selector(dismissSelf))
        btnFinish = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.Plain , target: self , action: #selector(finishRidding))
        
        navigationItem.leftBarButtonItem = btnCancel
        navigationItem.rightBarButtonItem = btnFinish
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
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
    
    func startAndStopRidding() {
        if isRidding {
            // stop them
            isRidding = false
            timer.invalidate()
            mapViewController.locationManager.stopUpdatingLocation()
            
            UIView.animateWithDuration(0.6){
                self.middleIcon.transform = CGAffineTransformMakeScale(1 , 1)
                self.middleIcon.layer.cornerRadius = (self.middleIcon.frame.width) / 2
            }
            
            UIView.animateWithDuration(0.6,delay: 0.0,options: .TransitionFlipFromLeft, animations:{
                self.middleIcon.transform = CGAffineTransformMakeScale(1, 1)
                },completion: { (isFinished) in
                    self.addIconCornerRadiusAnimation( 10, to: (self.middleIcon.frame.width) / 2, duration: 0.3)
            })

        } else {
            isRidding = true
            timer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(eachSecond), userInfo: nil, repeats: true)
            // NSDate apply here
            // GCD
            mapViewController.locationManager.startUpdatingLocation()
            
            UIView.animateWithDuration(0.6,delay: 0.0,options: .TransitionFlipFromLeft, animations:{
                self.middleIcon.transform = CGAffineTransformMakeScale(1, 1)
                },completion: { (isFinished) in
                    self.addIconCornerRadiusAnimation( (self.middleIcon.frame.width) / 2, to: 10, duration: 0.3)
            })
        }
        
    }
    
    func dismissSelf(sender: AnyObject) {
        timer.invalidate()
        mapViewController.removeFromParentViewController()
        mapViewController.locationManager.stopUpdatingLocation()
        dismissDelegate?.dismissVC()
        dismissViewControllerAnimated(true, completion: nil)
//        dismissDelegate = nil
    }
    
    func finishRidding(sender: AnyObject) {
        timer.invalidate()
        let runID = NSUUID().UUIDString
        savedRun(runID)
        
        let statisticViewController = storyboard?.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.runID = runID
        statisticViewController.dismissDelegate = dismissDelegate
        navigationController?.pushViewController(statisticViewController, animated: true)
        mapViewController.locationManager.stopUpdatingLocation()
    }
    
    
    func savedRun(runID: String) {
        
//        let date = NSDate()
        let days = -30.0
        let date = NSDate.init(timeIntervalSinceNow: 86400.00 * days)
        
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: moc) as! Run
        savedRun.id = runID
        savedRun.distance = mapViewController.distance
        savedRun.during = counter
//        savedRun.timestamp = NSDate()
        savedRun.timestamp = date
        // 2
        var savedLocations = [Location]()
        for location in mapViewController.locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: moc) as! Location
            savedLocation.id = runID
            savedLocation.timestamp = location.timestamp
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        
        savedRun.location = NSOrderedSet(array: savedLocations)
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    func addIconCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.middleIcon.layer.addAnimation(animation, forKey: "cornerRadius")
        self.middleIcon.layer.cornerRadius = to
    }
    
    
}
