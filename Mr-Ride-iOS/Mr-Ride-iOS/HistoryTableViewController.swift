//
//  HistoryTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/6/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    let cellIdentifier = "HistoryCell"
    var allRecord = [Run]()
    var sectionByMonth = [NSDateComponents: [Run]]()
    var keyOfMonth = [NSDateComponents]()
    var currentSection = -1
    
    weak var selectedDelegate: CellSelectedDelegate?
    weak var chartDataSource: ChartDataSource?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        tableView.registerNib(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.frame = view.bounds
        
        fetchData()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return keyOfMonth.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = sectionByMonth[keyOfMonth[section]]?.count {
            return count
        }
        print("error in section number")
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! HistoryTableViewCell
        
        let run = sectionByMonth[keyOfMonth[indexPath.section]]![indexPath.row]
        
        if currentSection != indexPath.section {
            print("section number == \(indexPath.section)")
            chartDataSource!.setupChartData(sectionByMonth[keyOfMonth[indexPath.section]]!)
            currentSection = indexPath.section
        }
        
        
        cell.backgroundColor = UIColor.mrDarkSlateBlue85Color()
        cell.runID = run.id!
        cell.labelDistance.text = String(format: "%.2f km", Double(run.distance!) / 1000)
        cell.labelDate.text = String(format: "%2d", NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: run.timestamp!).day)
        
        if let counter = run.during as? Double{
        
            let second = Int(counter) % 60
            let minutes = Int(counter / 60) % 60
            let hours = Int(counter / 60 / 60) % 99
            //        print(minuteSecond)
            cell.labelTime.text = String(format: "%02d:%02d:%02d", hours, minutes, second)
        }
        return cell
    }
    
    func fetchData() {
        
        print("fetchData")
        
        if LocationRecorder.getInstance().fetchData() != nil {
            allRecord = LocationRecorder.getInstance().fetchData()!
        } else {
            print("no record")
        }
        
        for run in allRecord {
            let currentComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: run.timestamp!)
            
            if sectionByMonth[currentComponents] != nil {
                sectionByMonth[currentComponents]?.append(run)
            } else {
                sectionByMonth[currentComponents] = [run]
                keyOfMonth.append(currentComponents)
            }
        }
    }
    
    // MARK: - Header part
    
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = UIView()
//        header.layer.cornerRadius = 2.0
//        header.backgroundColor = UIColor.whiteColor()
//        header.tintColor = UIColor.mrDarkSlateBlueColor()
//    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // "MMM yyyy"
        return "\(keyOfMonth[section].month), \(keyOfMonth[section].year) "
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // open statistic page
        selectedDelegate?.cellDidSelected(allRecord[indexPath.row].id!)
    }

}
