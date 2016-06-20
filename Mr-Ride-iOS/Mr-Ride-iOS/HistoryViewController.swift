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

protocol ChartDataSource: class {
    func setupChartData(data: [Run])
}

class HistoryViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var tableviewContainer: UIView!
    @IBOutlet weak var chartView: LineChartView!
    
    var chartDataDistance = [Double]()
    var chartDataDate = [String]()
    
//    var // do a computed property here
    let historyTableViewController = HistoryTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChartView()
        setupBackground()
        setupNavigationItem()
        setupButton()
        setupRevealViewController()
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
    
    func setupChartView() {
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
    
    func setupHistoryTable() {
        historyTableViewController.selectedDelegate = self
        historyTableViewController.chartDataSource = self
        historyTableViewController.view.frame = tableviewContainer.bounds
        historyTableViewController.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(historyTableViewController)
        tableviewContainer.addSubview(historyTableViewController.view)
        historyTableViewController.didMoveToParentViewController(self)
    }
    
}

extension HistoryViewController: CellSelectedDelegate {

    func cellDidSelected(runID: String) {
        let statisticViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticViewController") as! StatisticViewController
        statisticViewController.runID = runID
        self.navigationController?.pushViewController(statisticViewController, animated: true)
    }
}

extension HistoryViewController: ChartDataSource {
    
    func setupChartData(data: [Run]) {
        
        for run in data {
            if chartDataDistance.count > 30 {
                chartDataDistance.removeFirst()
                chartDataDate.removeFirst()
            }
            chartDataDistance.append(Double(run.distance!))
//            NSDateFormatter.stringFromDate(run.timestamp!)
            chartDataDate.append("2016.1.1")
        }
        setChart(chartDataDate, values: chartDataDistance)
        
        //dynamic queue maintainess
    }
}
