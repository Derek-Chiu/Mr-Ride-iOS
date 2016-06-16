//
//  LoginViewController.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/8/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textFieldHeight: UITextField!
    @IBOutlet weak var textFieldWeight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldHeight.delegate = self
        textFieldWeight.delegate = self
        
        textFieldHeight.keyboardType = UIKeyboardType.NumberPad
        textFieldWeight.keyboardType = UIKeyboardType.NumberPad
        
        setupBackground()
        setupBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
        
    func setupBackground() {
        
        let height = UIScreen.mainScreen().bounds.height
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
        
    }
    
    func setupBtn() {
        btnLogin.addTarget(self, action: #selector(btnTaped), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        let text = (textField.text as? NSString)!.stringByReplacingCharactersInRange(range, withString: string)
//        
//        guard let doubleVal = Double(text) else {
//            btnLogin.enabled = false
//        }
//        
//        
//        return true
//    }
    
    
    func btnTaped() {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            loginManager.logOut()
        } else {
            loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self) { (result, error) -> Void in
                guard error == nil else {
                    //error handling
                    loginManager.logOut()
                    print("login error " + String(error))
                    return
                }
                
                guard result != nil else {
                    //error handling
                    loginManager.logOut()
                    print("result nil " + String(result))
                    return
                }
                
                print(result.grantedPermissions)
                
                guard result.grantedPermissions.contains("email") else {
                    return
                }
                self.getFBUserData()
            }
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, link"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                guard error == nil else {
                    return
                }
                
                guard result != nil else {
                    print("result nil " + String(result))
                    return
                }
                
                if let fbResult = result as? NSDictionary {
//                    print(fbResult)
                    self.JSONParseToNSUserDefault(fbResult)
                }
            })
            print("login successed ")
            let starting = storyboard?.instantiateViewControllerWithIdentifier("StartingPageController") as! SWRevealViewController
            self.presentViewController(starting, animated: true, completion: nil)
        }
    }
    
    func JSONParseToNSUserDefault(fbResult: NSDictionary) {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        if let name = fbResult["name"] as? String {
            userDefault.setObject(name, forKey: "name")
        }
        
        if let email = fbResult["email"] as? String {
            userDefault.setObject(email, forKey: "email")
        }
        
        if let link = fbResult["link"] as? String {
            userDefault.setURL(NSURL(string: link), forKey: "link")
        }
        
        if let picStruct = fbResult["picture"] as? NSDictionary
            ,let picData = picStruct["data"] as? NSDictionary
            ,let picURL = picData["url"] as? String {
            userDefault.setURL(NSURL(string: picURL), forKey: "picture")
        }
        
        userDefault.synchronize()
        
//        print(userDefault.stringForKey("name"))
//        print(userDefault.stringForKey("email"))
//        print(userDefault.URLForKey("link"))
//        print(userDefault.URLForKey("picture"))
    }

}
