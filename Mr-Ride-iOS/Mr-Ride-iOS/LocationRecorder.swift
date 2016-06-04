//
//  LocationRecorder.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/1/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

class LocationRecorder {
    
    class func getData(runID: String) -> Run? {
        let request = NSFetchRequest(entityName: "Run")
        do {
            let results = try moc.executeFetchRequest(request) as! [Run]
            for result in results {
                if result.id == runID {
//                    print(result.location)
                    return result
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}