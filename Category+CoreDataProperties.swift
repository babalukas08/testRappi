//
//  Category+CoreDataProperties.swift
//  
//
//  Created by VaD on 23/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var idCategory: String?
    @NSManaged var nameCategory: String?
    @NSManaged var productsData: NSData?

}
