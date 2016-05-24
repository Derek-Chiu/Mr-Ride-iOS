//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {


    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    @IBOutlet weak var btnLetsRide: UIButton!
    @IBOutlet weak var labelTotalDistance: UILabel!
    @IBOutlet weak var labelTotalCount: UILabel!
    @IBOutlet weak var labelAverageSpeed: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        setupRevealViewController()
        setupButton()
        
        labelTotalDistance.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        labelTotalDistance.layer.shadowRadius = 1.0
        labelTotalDistance.layer.shadowOpacity = 0.5
        labelTotalDistance.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavigationItem() {
        let iconBike = UIImage(named:  "icon-bike")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.navigationItem.titleView = UIImageView(image: iconBike)
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        btnSideMenu.tintColor = UIColor.whiteColor()
        
        // let navigationvar shadow gone
        let shadowImg = UIImage()
        self.navigationController?.navigationBar.shadowImage = shadowImg
        self.navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupButton() {
        btnLetsRide.layer.cornerRadius = 30
        btnLetsRide.layer.shadowColor = UIColor.mrDarkSlateBlueColor().CGColor
        btnLetsRide.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnLetsRide.layer.shadowRadius = 1.0
        btnLetsRide.layer.shadowOpacity = 0.5
        btnLetsRide.addTarget(self, action: #selector(toRidingPage), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func toRidingPage() {
        print("button pressed")
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

}

