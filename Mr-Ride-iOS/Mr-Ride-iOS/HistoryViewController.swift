//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/27/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import Charts

protocol CellSelectedDelegate: class {
    func cellDidSelected(runID: String)
}

class HistoryViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var tableviewContainer: UIView!
    @IBOutlet weak var chartView: LineChartView!
    
    let historyTableViewController = HistoryTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupNavigationItem()
        setupButton()
        setupRevealViewController()
        setupChart()
        setupHistoryTable()
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
        chartView.delegate = self
//        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8])
//        series.color = UIColor.mrWaterBlueColor()
//        series.area = true
//        series.line = false
//        chart.userInteractionEnabled = false
//        chart.backgroundColor = UIColor.mrLightblueColor()
//        chart.areaAlphaComponent = 0.5
////        chart.gridColor = UIColor.clearColor()
//        chart.axesColor = UIColor.clearColor()
//        chart.labelColor = UIColor.clearColor()
//        chart.bottomInset = 0
//        chart.addSeries(series)
    }
    
    func setupHistoryTable() {
        historyTableViewController.selectedDelegate = self
        historyTableViewController.view.frame = tableviewContainer.bounds
        historyTableViewController.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(historyTableViewController)
        tableviewContainer.addSubview(historyTableViewController.view)
        historyTableViewController.didMoveToParentViewController(self)
    }
    
}

extension HistoryViewController: CellSelectedDelegate {

    func cellDidSelected(runID: String) {
        let statisticViewController = self.storyboard?.instantiateViewControllerWithIdentifier("statisticViewController") as! StatisticViewController
        statisticViewController.runID = runID
        self.navigationController?.pushViewController(statisticViewController, animated: true)
    }
    
}
