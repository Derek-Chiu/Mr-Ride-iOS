//
//  Location+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/3/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Location {

    @NSManaged var id: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var timestamp: NSDate?
    @NSManaged var run: Run?

}
