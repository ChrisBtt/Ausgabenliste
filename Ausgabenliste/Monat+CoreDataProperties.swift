//
//  Monat+CoreDataProperties.swift
//  Ausgabenliste
//
//  Created by Christoph Blattgerste on 26.09.16.
//  Copyright © 2016 Christoph Blattgerste. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Monat {

    @NSManaged var ausgaben: NSNumber?
    @NSManaged var month: String?
    @NSManaged var details: NSSet?

}
