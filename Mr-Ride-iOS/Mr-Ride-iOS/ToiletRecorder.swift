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
    
    func deleteData() {
        let coord = moc.persistentStoreCoordinator
        let fetchRequest = NSFetchRequest(entityName: "Toilet")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try coord?.executeRequest(deleteRequest, withContext: moc)
        } catch let error as NSError{
            print(error)
        }
    }

    func writeData(category category: String, name: String, address: String, lat: Double, lng: Double) {
        
        let savedToilet = NSEntityDescription.insertNewObjectForEntityForName("Toilet", inManagedObjectContext: moc) as! Toilet
        savedToilet.category = category
        savedToilet.name = name
        savedToilet.address = address
        savedToilet.latitude = lat
        savedToilet.longitude = lng
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }

    }

    func fetchData() -> [Toilet]? {
        let request = NSFetchRequest(entityName: "Toilet")
        do {
//            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            let results = try moc.executeFetchRequest(request) as! [Toilet]
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