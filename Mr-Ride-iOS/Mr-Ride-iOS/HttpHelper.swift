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
    var stationList = [Station]()
    
    func getToilet(completion: CompletionHandler) {
        
        Alamofire.request(.GET,
            "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=008ed7cf-2340-4bc4-89b0-e258a5573be2", parameters: nil).responseJSON { reponse in
                //                            print(reponse.request)
                print(reponse.response?.statusCode) //status is here (200...etc)
                //                            print(reponse.data)
                print(reponse.result.isSuccess) //SUCCESS
                
                
                guard let JSON = reponse.result.value as? [String: AnyObject] else {
                    // error handling
                    print("JSON failed")
                    return
                }
                print("JSON done")
                guard let result = JSON["result"] as? [String: AnyObject] else {
                    // error handling
                    print("result failed")
                    return
                }
                print("result done")
                guard let results = result["results"]  as? [[String: String]] else {
                    // error handling
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
                        //error handling
                        print("緯度")
                        continue
                    }
                    guard let latitude = Double(lat) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    guard let lng = data["經度"]  else {
                        // error handleing
                        print("經度")
                        continue
                    }
                    guard let longitude = Double(lng) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    let toilet = Toilet(name: name, category: "ddddd", address: address, latitude: latitude, longitude: longitude)
                    self.toiletList.append(toilet)
                }

                
                dispatch_async(dispatch_get_main_queue()){
                
                    completion()
                }
        }
        
    }
    
    func getToiletRiverSide(completion: CompletionHandler)  {
        
        Alamofire.request(.GET,
            "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f", parameters: nil).responseJSON { reponse in
                //                            print(reponse.request)
                print(reponse.response?.statusCode) //status is here (200...etc)
                //                            print(reponse.data)
//                print(reponse.result.isSuccess) //SUCCESS
                
                
                guard let JSON = reponse.result.value as? [String: AnyObject] else {
                    // error handling
                    print("JSON failed")
                    return
                }
                print("JSON done")
                guard let result = JSON["result"] as? [String: AnyObject] else {
                    // error handling
                    print("result failed")
                    return
                }
                print("result done")
                guard let results = result["results"]  as? [[String: String]] else {
                    // error handling
                    print("results failed")
                    return
                }
                print("results done")
                
                for data in results {
                    
                    guard let name = data["Location"] else {
                        // error handleing
                        print("Location")
                        continue
                    }
        
                    guard let lat = data["Latitude"] else {
                        //error handling
                        print("Latitude")
                        continue
                    }
                    guard let latitude = Double(lat) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    guard let lng = data["Longitude"]  else {
                        // error handleing
                        print("Longitude")
                        continue
                    }
                    guard let longitude = Double(lng) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    let toilet = Toilet(name: name, category: "River Side", address: "", latitude: latitude, longitude: longitude)
                    self.toiletList.append(toilet)
                }
                
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    completion()
                }
        }
        

    }
    
    func getStations(completion: CompletionHandler)  {
        
        Alamofire.request(.GET,
            "http://data.taipei/youbike", parameters: nil).validate().responseJSON { reponse in
                //                            print(reponse.request)
                
                // TODO: error handling
                print(reponse.response?.statusCode) //status is here (200...etc)
                //                            print(reponse.data)
                print(reponse.result.isSuccess) //SUCCESS
//                print(reponse.result.value)
                
                
                guard let JSON = reponse.result.value as? [String: AnyObject] else {
                    // error handling
                    print("JSON failed")
                    return
                }
                
                guard let results = JSON["retVal"] as? [String: [String: String]] else {
                    // error handling
                    print("result failed")
                    return
                }
                
                for data in results
                {
                    
                    // station name
                    guard let name = data.1["sna"] else {
                        // error handleing
                        print("站名")
                        continue
                    }
                    
                    guard let nameEN = data.1["snaen"] else {
                        // error handleing
                        print("站名EN")
                        continue
                    }
                    
                    // loaction around
                    guard let location = data.1["ar"] else {
                        // error handleing
                        print("位置")
                        continue
                    }
                    
                    guard let locationEN = data.1["aren"] else {
                        // error handleing
                        print("位置EN")
                        continue
                    }
                    
                    // area around
                    guard let area = data.1["sarea"] else {
                        // error handleing
                        print("區")
                        continue
                    }
                    
                    guard let areaEN = data.1["sareaen"] else {
                        // error handleing
                        print("區EN")
                        continue
                    }
                    
                    // latitude
                    guard let lat = data.1["lat"] else {
                        //error handling
                        print("lat")
                        continue
                    }
                    
                    guard let latitude = Double(lat) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    
                    // longitude
                    guard let lng = data.1["lng"]  else {
                        // error handling
                        print("lng")
                        continue
                    }
                    
                    guard let longitude = Double(lng) else {
                        //error handling
                        print("casting")
                        continue
                    }
                    
                    // bike left
                    guard let bikeL = data.1["sbi"] else {
                        // error handling
                        print("bike left")
                        continue
                    }
                    
                    guard let bikeLeft = Int(bikeL) else {
                        // error handling
                        print("casting")
                        continue
                    }
                    
                    // parking space
                    guard let bikeS = data.1["bemp"] else {
                        //error handling
                        print("bike space")
                        continue
                    }
                    
                    guard let bikeSpace = Int(bikeS) else {
                        // error handling
                        print("casting")
                        continue
                    }
                    
                    // station available
                    guard let stationAvailability = data.1["act"] else {
                        //error handling
                        print("stationAvailability")
                        continue
                    }
                    
                    var isAvailable = true
                    
                    switch stationAvailability
                    {
                    case "0": isAvailable = false
                    case "1": isAvailable = true
                    default: isAvailable = true
                    }
                    
                    let station = Station(  name: name, nameEN: nameEN,
                                            location: location, locarionEN: locationEN,
                                            area: area, areaEN: areaEN,
                                            latitude: latitude,
                                            longitude: longitude,
                                            bikeleft: bikeLeft,
                                            bikeSpace: bikeSpace,
                                            available: isAvailable)
                    self.stationList.append(station)
                }
                
                
                dispatch_async(dispatch_get_main_queue()){
                    
                    completion()
                }
        }
    }
    
    
    func getToiletList() -> [Toilet] {
        return toiletList
    }
    
    func getStationList() -> [Station] {
        return stationList
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