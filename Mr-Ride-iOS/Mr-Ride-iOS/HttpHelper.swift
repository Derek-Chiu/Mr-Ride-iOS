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

    class func getToilet() {
        Alamofire.request(.GET,
                          "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f", parameters: nil).responseJSON { reponse in
//                            print(reponse.request)
                            print(reponse.response?.statusCode) //status is here (200...etc)
//                            print(reponse.data) //
                            print(reponse.result.isSuccess) //SUCCESS
                            
                            if let JSON = reponse.result.value {
                                print("JSON: \(JSON)")
                            }
        }
        
    }
}