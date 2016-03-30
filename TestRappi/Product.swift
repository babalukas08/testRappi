//
//  Product.swift
//  
//
//  Created by VaD on 23/03/16.
//
//

import Foundation
import CoreData


class Product: NSManagedObject {
    
    
// Insert code here to add functionality to your managed object subclass
    
    /*convenience init(artist: String, category: String, idCategory: String, image64: String, name: String, price: String, rights: String, summary: String, entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.artist = artist
        self.category = category
        self.idCategory = idCategory
        self.image64 = image64
        self.name = name
        self.price = price
        self.rights = rights
        self.summary = summary
    }*/
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.artist, forKey: "artist")
    }
    
   /* required convenience init(coder aDecoder: NSCoder) {
        
      //  self.artist = aDecoder.decodeObjectForKey("artist") as? String
        super.init()
    }*/
    
}
