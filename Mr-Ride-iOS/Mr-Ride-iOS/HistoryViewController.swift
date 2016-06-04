//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/27/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import SwiftChart

class HistoryViewController: UIViewController, ChartDelegate {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var chart: Chart!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupNavigationItem()
        setupButton()
        setupRevealViewController()
        setupChart()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupBackground() {
        
        let height = UIScreen.mainScreen().bounds.height
            - (navigationController?.navigationBar.frame.height)!
            - UIApplication.sharedApplication().statusBarFrame.height
        
        let upperBackground = CALayer()
        upperBackground.frame = CGRectMake(0, 0, view.frame.width, height / 2)
        upperBackground.backgroundColor = UIColor.mrLightblueColor().CGColor
        view.layer.insertSublayer(upperBackground, atIndex: 0)
        
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "image-history-background")!.drawInRect(CGRectMake(0, height / 2, view.frame.width, height / 2))
        let bgImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: bgImg!)
        
        let color1 = UIColor.mrLightblueColor()
        let color2 = UIColor.mrPineGreen50Color()
        let gradient = CAGradientLayer()
        gradient.frame = CGRectMake(0, height / 2, view.frame.width, height / 2)
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)

        navigationController?.navigationBar.translucent = false
    }
    
    func setupNavigationItem() {
        btnSideMenu.tintColor = UIColor.whiteColor()
        let shadowImg = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImg
        navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupButton() {
        btnSideMenu.tintColor = UIColor.whiteColor()
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setupChart() {
        chart.delegate = self
        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
        series.color = UIColor.mrWaterBlueColor()
        series.area = true
        series.line = false
        chart.userInteractionEnabled = false
        chart.backgroundColor = UIColor.mrLightblueColor()
        chart.areaAlphaComponent = 0.5
//        chart.gridColor = UIColor.clearColor()
        chart.axesColor = UIColor.clearColor()
        chart.labelColor = UIColor.clearColor()
        chart.bottomInset = 0
        chart.addSeries(series)
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
