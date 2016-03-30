//
//  Product+CoreDataProperties.swift
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

extension Product {

    @NSManaged var artist: String?
    @NSManaged var category: String?
    @NSManaged var idCategory: String?
    @NSManaged var image64: String?
    @NSManaged var name: String?
    @NSManaged var price: String?
    @NSManaged var rights: String?
    @NSManaged var summary: String?
    
    
    
    
}
