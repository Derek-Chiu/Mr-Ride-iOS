//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/27/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupNavigationItem()
        setupButton()
        setupRevealViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupBackground() {
        
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: "image-history-background")?.drawInRect(view.bounds)
        let bgImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: bgImg)
        
        let height = UIScreen.mainScreen().bounds.height
            - (navigationController?.navigationBar.frame.height)!
            - UIApplication.sharedApplication().statusBarFrame.height
        
        let upperBackground = CALayer()
        upperBackground.frame = CGRectMake(0, 0, view.frame.width, height / 2)
        upperBackground.backgroundColor = UIColor.mrLightblueColor().CGColor
        view.layer.insertSublayer(upperBackground, atIndex: 0)
        
        let color1 = UIColor.mrLightblueColor()
        let color2 = UIColor.mrPineGreen50Color()
        let gradient = CAGradientLayer()
        gradient.frame = CGRectMake(0, height / 2, view.frame.width, height / 2)
        gradient.colors = [color1.CGColor, color2.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
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
    
}
