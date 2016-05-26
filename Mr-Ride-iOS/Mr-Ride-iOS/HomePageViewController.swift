//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import SwiftChart

class HomePageViewController: UIViewController, ChartDelegate {


    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var btnLetsRide: UIButton!
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var labelAverageSpeed: UILabel!
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNavigationItem()
//        setupRevealViewController()
//        setupTotalDistance()
//        setupButton()
    }

  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        setupNavigationItem()
        setupRevealViewController()
        setupTotalDistance()
        setupButton()
        
        chart.delegate = self
        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series.color = UIColor.mrWaterBlueColor()
        series.area = true
        series.line = false
        chart.userInteractionEnabled = false
        chart.backgroundColor = UIColor.mrLightblueColor()
        chart.areaAlphaComponent = 0.5
        chart.gridColor = UIColor.clearColor()
        chart.axesColor = UIColor.clearColor()
        chart.labelColor = UIColor.clearColor()
        chart.bottomInset = 0
        chart.addSeries(series)
    }
    
    func setupNavigationItem() {
        let iconBike = UIImage(named: "icon-bike")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.navigationItem.titleView = UIImageView(image: iconBike)
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        btnSideMenu.tintColor = UIColor.whiteColor()
        
        // let navigationvar shadow gone
        let shadowImg = UIImage()
        self.navigationController?.navigationBar.shadowImage = shadowImg
        self.navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupTotalDistance() {
        labelTotalDistance.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        labelTotalDistance.layer.shadowRadius = 1.0
        labelTotalDistance.layer.shadowOpacity = 0.5
        labelTotalDistance.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    }
    
    func setupButton() {
        btnLetsRide.layer.cornerRadius = 30
        btnLetsRide.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        btnLetsRide.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnLetsRide.layer.shadowRadius = 1.0
        btnLetsRide.layer.shadowOpacity = 0.5
        btnLetsRide.tintColor = UIColor.mrWaterBlueColor()
        btnLetsRide.addTarget(self, action: #selector(toRidingPage), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func toRidingPage() {
        print("button pressed")
        let trackingViewController = storyboard?.instantiateViewControllerWithIdentifier("TrackingViewController") as! TrackingViewController
//        trackingViewController.modalPresentationStyle = .OverCurrentContext
        let NaiVC = UINavigationController(rootViewController: trackingViewController)
        NaiVC.modalPresentationStyle = .OverCurrentContext
        
        btnLetsRide.hidden = true
        labelTotalCount.hidden = true
        labelAverageSpeed.hidden = true
        labelTotalDistance.hidden = true
        
        presentViewController(NaiVC, animated: true, completion: nil)
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    // Chart delegate
    
    func didTouchChart(chart: Chart, indexes: Array<Int?>, x: Float, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerate() {
            if let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex) {
                print("Touched series: \(seriesIndex): data index: \(dataIndex!); series value: \(value); x-axis value: \(x) (from left: \(left))")
            }
        }
    }
    
    func didFinishTouchingChart(chart: Chart) {
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }

}

