//
//  SideMenuTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

enum CurrentSelected: Int {
    case HomePage
    case HistoryPage
}

class SideMenuTableViewController: UITableViewController {
    
    var tableArray = [String]()
    var currentIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var currentSelected = CurrentSelected.HomePage

    override func viewDidLoad() {
        super.viewDidLoad()
        tableArray = ["Home","History"]
        setupNavigationBarAndTableView()
        tableView.bounces = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.selectRowAtIndexPath(currentIndexPath, animated: true, scrollPosition: .None)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CellTableViewCell
        cell.label.text = tableArray[indexPath.row]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    func setupNavigationBarAndTableView() {
        tableView.backgroundColor = UIColor.mrDarkSlateBlueColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let shadowImg = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImg
        navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        currentIndexPath = indexPath
        
        switch indexPath.row {
        case 0:
            let trackingViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
            
            let segue = SWRevealViewControllerSeguePushController.init(identifier: nil, source: self, destination: trackingViewController)
            segue.perform()
            
        case 1:
            let trackingViewController = storyboard?.instantiateViewControllerWithIdentifier("HistoryNavigationController") as! UINavigationController
            let segue = SWRevealViewControllerSeguePushController.init(identifier: nil, source: self, destination: trackingViewController)
            segue.perform()

        default:
            let trackingViewController = storyboard?.instantiateViewControllerWithIdentifier("HomeNavigationController") as! UINavigationController
            revealViewController().setFrontViewController(trackingViewController, animated: true)
        }
    }

}
