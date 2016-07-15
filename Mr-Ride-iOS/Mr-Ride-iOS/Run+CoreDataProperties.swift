//
//  Run+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 7/7/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Run {

    @NSManaged var distance: NSNumber?
    @NSManaged var during: NSNumber?
    @NSManaged var id: String?
    @NSManaged var timestamp: NSDate?
    @NSManaged var calorie: NSNumber?
    @NSManaged var location: NSOrderedSet?

}
