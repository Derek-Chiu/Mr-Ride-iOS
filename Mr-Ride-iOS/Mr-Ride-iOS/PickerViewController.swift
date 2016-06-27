//
//  PickerViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/17/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

protocol PickerDelegate: class {
    func pickerselected(selected: PickerOption)
}

enum PickerOption {
    case UbikeStation
    case Toliet
}

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    
    weak var pickerDelegate: PickerDelegate?
    var currentSelected = PickerOption.UbikeStation
    
    var options = ["UBike Station", "Toliet"]
    var dict: [String: PickerOption] = ["UBike Station": .UbikeStation, "Toliet": .Toliet]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.mrBlack25Color()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.whiteColor()
        setupButton()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("picker deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard dict[options[row]] != nil else {
            self.currentSelected = .UbikeStation
            return
        }
        currentSelected = dict[options[row]]!
    }
    
    func setupButton() {
        btnCancel.addTarget(self, action: #selector(dismissSelf), forControlEvents: UIControlEvents.TouchUpInside)
        btnDone.addTarget(self, action: #selector(dismissSelf), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func dismissSelf(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
        
        if sender.titleLabel?.text == "Done" {
            pickerDelegate?.pickerselected(currentSelected)
        }
    }

}
