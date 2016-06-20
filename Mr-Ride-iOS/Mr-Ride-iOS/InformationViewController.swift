//
//  InformationViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/16/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var btnSideMenu: UIBarButtonItem!
    
    @IBOutlet weak var btnPicker: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationItem()
        setupRevealViewController()
        setupButton()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationItem() {

        self.title = "MAP"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        btnSideMenu.tintColor = UIColor.whiteColor()
        
        // let navigationvar shadow gone
        let shadowImg = UIImage()
        navigationController?.navigationBar.shadowImage = shadowImg
        navigationController?.navigationBar.setBackgroundImage(shadowImg, forBarMetrics: UIBarMetrics.Default)
    }
    
    func setupRevealViewController() {
        btnSideMenu.target = self.revealViewController()
        btnSideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setupButton() {
        btnPicker.addTarget(self, action: #selector(showPicker), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func showPicker() {
        let pickerVC = storyboard!.instantiateViewControllerWithIdentifier("PickerViewController") as! PickerViewController
        pickerVC.modalPresentationStyle = .Custom
        pickerVC.transitioningDelegate? = self
        pickerVC.pickerDelegate = self
        self.presentViewController(pickerVC, animated: true, completion: nil)
    }

    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presentingViewController: presentingViewController!)
    }
}

extension InformationViewController: PickerDelegate {
    
    func pickerselected(selected: PickerOption) {
        switch selected {
        case .UbikeStation:
            //show UbikeStation
            print("UbikeStation")
        case .Toliet:
            // show toliet
            print("Toliet")
        }
    }
}

class HalfSizePresentationController : UIPresentationController {
    override func frameOfPresentedViewInContainerView() -> CGRect {
        return CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height/2)
    }
}
