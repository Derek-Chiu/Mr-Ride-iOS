//
//  StatisticViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/26/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {
    
    var btnClose: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBackground() {
        let color1 = UIColor.mrBlack60Color()
        let color2 = UIColor.whiteColor()
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [color1.CGColor, color2.CGColor]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.barTintColor = UIColor.mrLightblueColor()
        navigationController?.navigationBar.translucent = false
    }
    
    func setupButton() {
        btnClose = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(dismissSelf))
        navigationItem.leftBarButtonItem = btnClose
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    func dismissSelf(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
