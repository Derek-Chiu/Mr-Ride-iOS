//
//  HttpHelper.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/16/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation
import Alamofire



class HttpHelper {
    
    
    typealias CompletionHandler = () -> Void
    
    var toiletList = [Toilet]()
    
    func getToilet(completion: CompletionHandler) {
        
        Alamofire.request(.GET,
            "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2", parameters: nil).responseJSON { reponse in
                //                            print(reponse.request)
                print(reponse.response?.statusCode) //status is here (200...etc)
                //                            print(reponse.data)
                print(reponse.result.isSuccess) //SUCCESS
                
                
                guard let JSON = reponse.result.value as? [String: AnyObject] else {
                    // error handeling
                    print("JSON failed")
                    return
                }
                print("JSON done")
                guard let result = JSON["result"] as? [String: AnyObject] else {
                    // error handeling
                    print("result failed")
                    return
                }
                print("result done")
                guard let results = result["results"]  as? [[String: String]] else {
                    // error handeling
                    print("results failed")
                    return
                }
                print("results done")
                
                for data in results {
                    
                    guard let name = data["單位名稱"] else {
                        // error handleing
                        print("單位名稱")
                        continue
                    }
                    guard let address = data["地址"] else {
                        // error handleing
                        print("地址")
                        continue
                    }
                    guard let lat = data["緯度"] else {
                        //error handeling
                        print("緯度")
                        continue
                    }
                    guard let latitude = Double(lat) else {
                        //error handeling
                        print("casting")
                        continue
                    }
                    guard let lng = data["經度"]  else {
                        // error handleing
                        print("經度")
                        continue
                    }
                    guard let longitude = Double(lng) else {
                        //error handeling
                        print("casting")
                        continue
                    }
                    let toilet = Toilet(name: name, address: address, latitude: latitude, longitude: longitude)
                    self.toiletList.append(toilet)
                }
                
                print(self.toiletList.count)
                
                dispatch_async(dispatch_get_main_queue()){
                
                    completion()
                }
        }
        
    }
    
    func getToiletList() -> [Toilet] {
        return toiletList
    }
    
    // get stations here
}

extension HttpHelper {
    
    private static var sharedInstance: HttpHelper?
    
    static func getInstance() -> HttpHelper {
        if sharedInstance == nil {
            sharedInstance = HttpHelper()
        }
        
        return sharedInstance!
    }
    
    
}