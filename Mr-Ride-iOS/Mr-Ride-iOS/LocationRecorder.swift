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
    
    func getDataWithID(runID: String) -> Run? {
        let request = NSFetchRequest(entityName: "Run")
        do {
            let results = try moc.executeFetchRequest(request) as! [Run]
            for result in results {
                if result.id == runID {
                    return result
                }
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func fetchData() -> [Run]? {
        let request = NSFetchRequest(entityName: "Run")
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let results = try moc.executeFetchRequest(request) as! [Run]
            return results
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
}

extension LocationRecorder {
    
    static var locationRecorder: LocationRecorder?
    
    static func getInstance() -> LocationRecorder {
        
        if locationRecorder == nil {
            locationRecorder = LocationRecorder()
        }
        
        return locationRecorder!
    }
}