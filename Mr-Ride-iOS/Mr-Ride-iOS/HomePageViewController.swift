//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import Charts

class HomePageViewController: UIViewController, TrackingDelegate, ChartViewDelegate {
    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var btnLetsRide: UIButton!
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var labelAverageSpeed: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    
    var totalDistance = 0.0
    var totalRun = 0
    var avgSpeed = 0.0
    var chartData = [Double]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupBackground()
        setupNavigationItem()
        setupRevealViewController()
        setupData()
        setupLabels()
        setupButton()
        setupChart()
    }
    
    
    func setupData() {
        if LocationRecorder.getInstance().fetchData() != nil {
            let allRecord = LocationRecorder.getInstance().fetchData()!
            totalRun = allRecord.count
            
            for data in allRecord {
                totalDistance = totalDistance + Double(data.distance!)
            }
            totalDistance = totalDistance / 1000
            avgSpeed = totalDistance / Double(totalRun)
        }
        
    }
    
    func setupBackground() {
        let layer = CALayer()
        layer.frame = view.bounds
        layer.backgroundColor = UIColor.mrLightblueColor().CGColor
//        layer.opacity = 1.0
//        layer.hidden = false
        view.layer.insertSublayer(layer, atIndex: 0)
    }
    
    func setupNavigationItem() {
        let iconBike = UIImage(named: "icon-bike")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        navigationItem.titleView = UIImageView(image: iconBike)
        navigationItem.titleView?.tintColor = UIColor.whiteColor()
        btnSideMenu.tintColor = UIColor.whiteColor()
        
        // let navigationvar shadow gone
        let shadowImg = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImg
        navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupLabels() {
        labelTotalDistance.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        labelTotalDistance.layer.shadowRadius = 1.0
        labelTotalDistance.layer.shadowOpacity = 0.5
        labelTotalDistance.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        labelTotalDistance.text = String(format: "%.1f km", totalDistance)
        
        labelTotalCount.text = String(totalRun)
        labelAverageSpeed.text = String(format: "%.1f km/h", avgSpeed)
    }
    
    func setupButton() {
        btnLetsRide.layer.cornerRadius = 30
        btnLetsRide.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        btnLetsRide.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnLetsRide.layer.shadowRadius = 1.0
        btnLetsRide.layer.shadowOpacity = 0.5
        btnLetsRide.tintColor = UIColor.mrWaterBlueColor()
        btnLetsRide.addTarget(self, action: #selector(toTrackingPage), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func toTrackingPage() {
        let trackingViewController = storyboard?.instantiateViewControllerWithIdentifier("TrackingViewController") as! TrackingViewController
        let NaiVC = UINavigationController(rootViewController: trackingViewController)
        NaiVC.modalPresentationStyle = .OverCurrentContext
        trackingViewController.dismissDelegate = self
        for subview in view.subviews where subview is UILabel { subview.hidden = true }
        presentViewController(NaiVC, animated: true, completion: nil)
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setupChart()  {
        chartView.backgroundColor = UIColor.mrLightblueColor()
        chartView.userInteractionEnabled = false
        
        chartView.delegate = self
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        
        chartView.legend.enabled = false
        
        chartView.minOffset = 0
        
        chartView.descriptionText = ""
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        setChart(months, values: unitsSold)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        chartDataSet.mode = .CubicBezier
        chartDataSet.cubicIntensity = 0.3
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(UIColor.clearColor())
        chartDataSet.drawValuesEnabled = false
        
        
        let color1 = UIColor.mrLightblueColor()
        let color2 = UIColor.mrPineGreen50Color()
        let gradient = CAGradientLayer()
        gradient.frame = chartView.bounds
        gradient.colors = [color1.CGColor, color2.CGColor]
        
        chartDataSet.drawFilledEnabled = true
        chartDataSet.fillAlpha = 0.5
        chartDataSet.fill = ChartFill.fillWithColor(UIColor.mrWaterBlueColor())

        let chartData = LineChartData(xVals: dataPoints, dataSet: chartDataSet)
        chartView.data = chartData
        
    }

    // TrackingDelegate
    func dismissVC() {
        // after presented viewcontroller dismissed
        for subview in view.subviews where subview is UILabel { subview.hidden = false }
        setupData()
        setupLabels()
        setupChart()
    }

}

