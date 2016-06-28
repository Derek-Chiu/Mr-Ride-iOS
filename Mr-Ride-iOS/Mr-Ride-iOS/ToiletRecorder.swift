//
//  ToiletRecorder.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/28/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation
import CoreData

class ToiletRecorder {

    class func fetchData() -> [Toilets]? {
        let request = NSFetchRequest(entityName: "Toilets")
        do {
//            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let results = try moc.executeFetchRequest(request) as! [Toilets]
            return results
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    

}

extension ToiletRecorder {
    
    static var toiletRecorder: ToiletRecorder?
    
    static func getInstance() -> ToiletRecorder {
        
        if toiletRecorder == nil {
            toiletRecorder = ToiletRecorder()
        }
        
        return toiletRecorder!
    }
}