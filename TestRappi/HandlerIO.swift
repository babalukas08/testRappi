//
//  HandlerIO.swift
//  TestRappi
//
//  Created by VaD on 23/03/16.
//  Copyright © 2016 TestMauricioJimenez. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SVProgressHUD
import Alamofire

// User Defaults
let userDefaults = NSUserDefaults.standardUserDefaults()
// Get Core Data Manager Context
let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

// Enum State Connection
enum ConnectionState {
    
    case Close
    case DownloadProductos
}

class HandlerIO {
    
    // MARK: Variables of Model
    var CategoryArray = [Category]()
    var ProductsArray = [Product]()
    var games: NSMutableArray = NSMutableArray()
    var photo: NSMutableArray = NSMutableArray()
    var social: NSMutableArray = NSMutableArray()
    var music: NSMutableArray = NSMutableArray()
    var education: NSMutableArray = NSMutableArray()
    var entertainment: NSMutableArray = NSMutableArray()
    var travel: NSMutableArray = NSMutableArray()
    var navigation: NSMutableArray = NSMutableArray()
    var allCategory: NSMutableArray = NSMutableArray()
    var CategoryforDB: NSMutableArray = NSMutableArray()
    
    // MARK: - Variables
    var connectionState: ConnectionState = .Close
    
    class func showSimpleAlert(title: String, message: String, viewController:UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func getProductStorage(name: String) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest(entityName: name)
        
        do{
            let objects = try managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return objects
        } catch {
            print("Fetch failed in \(name), with error: \(error)")
        }
        
        return nil
    }
   /* class func saveEntityUserDefaults(Host: String){
        if Host != ""{
            userDefaults.setValue("\(Host)", forKey: KEY_HOST)
        }else{
            userDefaults.setValue("\(HOST)", forKey: KEY_HOST)
        }
        
    }*/
    
    func getCategory(object:NSDictionary){
        let nombre = object.valueForKey("category") as? String
        if nombre == "Games"{
            games.addObject(object)
        }else if nombre == "Photo & Video"{
            photo.addObject(object)
        }
        else if nombre == "Social Networking"{
            social.addObject(object)
        }else if nombre == "Education"{
            education.addObject(object)
        }else if nombre == "Entertainment"{
            entertainment.addObject(object)
        }else if nombre == "Music"{
            music.addObject(object)
        }else if nombre == "Travel"{
            travel.addObject(object)
        }else if nombre == "Navigation"{
            navigation.addObject(object)
        }
    }
    func saveCategory(){
        if let categoryData = HandlerIO.getProductStorage("Category") as? [Category] {
            if categoryData.isEmpty {
                print("Products is Empty")
                // 1. Download "Products"
            }else{
                print("# products in storage: \(categoryData.count)")
                CategoryArray = categoryData
                //print("esto es productos \(ProductsArray)")
                
                SVProgressHUD.dismiss()
            }
        }
    }
    func categoryDataP(){
        print("Formando grupos de datos para DB")
        for var i = 0; i<allCategory.count; ++i{
            let dicCategory: NSMutableDictionary = NSMutableDictionary()
            print(allCategory.objectAtIndex(i))
            let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(allCategory.objectAtIndex(i))
            
            if i == 0{
                dicCategory.setValue("6014", forKey: "idCategory")
                dicCategory.setValue("Games", forKey: "nameCategory")
            }else if i == 1{
                dicCategory.setValue("6008", forKey: "idCategory")
                dicCategory.setValue("Photo & Video", forKey: "nameCategory")
            }else if i == 2{
                dicCategory.setValue("6005", forKey: "idCategory")
                dicCategory.setValue("Social Networking", forKey: "nameCategory")
            }else if i == 3{
                dicCategory.setValue("6011", forKey: "idCategory")
                dicCategory.setValue("Music", forKey: "nameCategory")
            }else if i == 4{
                dicCategory.setValue("6017", forKey: "idCategory")
                dicCategory.setValue("Education", forKey: "nameCategory")
            }else if i == 5{
                dicCategory.setValue("6003", forKey: "idCategory")
                dicCategory.setValue("Travel", forKey: "nameCategory")
            }else if i == 6{
                dicCategory.setValue("6010", forKey: "idCategory")
                dicCategory.setValue("Navigation", forKey: "nameCategory")
            }else if i == 7{
                dicCategory.setValue("6016", forKey: "idCategory")
                dicCategory.setValue("Entertainment", forKey: "nameCategory")
            }
            dicCategory.setValue(dataExample, forKey: "productsData")
            CategoryforDB.addObject(dicCategory)
        }
       // print(CategoryforDB)
        
        for productos in CategoryforDB {
            
            // Create new Entidad Federativa
            let description = NSEntityDescription.entityForName("Category", inManagedObjectContext: managedObjectContext)!
            let allCat = Category(entity: description, insertIntoManagedObjectContext: managedObjectContext)
            
            // Set Attributes
            allCat.nameCategory = productos.valueForKey("nameCategory") as? String
            allCat.productsData = productos.valueForKey("productsData") as? NSData
            allCat.idCategory = productos.valueForKey("idCategory") as? String
            
            // Add to array
            self.CategoryArray.append(allCat)
        }
        // Save
        do {
            NSNotificationCenter.defaultCenter().postNotificationName("loadData", object: self)
            try managedObjectContext.save()
            //mandar DAtos
        } catch {
            fatalError("Failure to save context in Entidades Federativas, with error: \(error)")
        }
    }
    func getData(){
        if let products = HandlerIO.getProductStorage("Product") as? [Product] {
            if products.isEmpty {
                print("Products is Empty")
                // 1. Download "Products"
                GetProducts()
            }else{
                print("# products in storage: \(products.count)")
                
                ProductsArray = products
                //print("esto es productos \(ProductsArray)")
                
                for var i = 0; i<ProductsArray.count; ++i{
                    let object = ProductsArray[i]
                    
                    let keys = Array(object.entity.attributesByName.keys)
                    let dict = object.dictionaryWithValuesForKeys(keys)
                   
                    //print(dict)
                    
                    getCategory(dict)
                }
                allCategory.addObject(games)
                allCategory.addObject(photo)
                allCategory.addObject(social)
                allCategory.addObject(music)
                allCategory.addObject(education)
                allCategory.addObject(travel)
                allCategory.addObject(navigation)
                allCategory.addObject(entertainment)
                categoryDataP()
                
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func showProgressWithStatus(string: String){
        if SVProgressHUD.isVisible() {
            SVProgressHUD.setStatus(string)
        }else{
            SVProgressHUD.showWithStatus(string)
        }
    }
    
    private func GetProducts(){
        print("Downloading Catalog Products")
        showProgressWithStatus("Descargando Productos...")
        connectionState = .DownloadProductos
        
        Alamofire.request(.GET, "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
            .responseJSON { response in
                
                if let error = response.result.error {
                    print("Download Products ERROR: \(error.userInfo)")
                    self.checkTaskRequestsAndDismissPorgress(error)
                }else{
                    print("Success: \(response.result.isSuccess)")
                    print("Response String: \(response.result)")
                    if let json = response.result.value as? NSDictionary{
                        let dataArray = json.valueForKey("feed")?.valueForKey("entry") as! NSArray
                        //print(dataArray.valueForKey("category").valueForKey("attributes")?.valueForKey("label"))
                        
                        // Save "Entidades Federativas" in DB
                        for productos in dataArray {
                            
                            // Create new Entidad Federativa
                            let description = NSEntityDescription.entityForName("Product", inManagedObjectContext:managedObjectContext)!
                            let allProductos = Product(entity: description, insertIntoManagedObjectContext:managedObjectContext)
                            
                            // Set Attributes
                            allProductos.artist = productos.valueForKey("im:artist")?.valueForKey("label") as? String
                            allProductos.category = productos.valueForKey("category")?.valueForKey("attributes")?.valueForKey("label") as? String
                            allProductos.idCategory = productos.valueForKey("category")?.valueForKey("attributes")?.valueForKey("im:id") as? String
                            allProductos.image64 = productos.valueForKey("im:image")?.objectAtIndex(2).valueForKey("label") as? String
                            allProductos.name = productos.valueForKey("im:name")?.valueForKey("label") as? String
                            allProductos.price = productos.valueForKey("im:price")?.valueForKey("attributes")?.valueForKey("amount") as? String
                            allProductos.rights = productos.valueForKey("rights")?.valueForKey("label") as? String
                            allProductos.summary = productos.valueForKey("summary")?.valueForKey("label") as? String
                            
                            // Add to array
                            self.ProductsArray.append(allProductos)
                        }
                        
                        // Save
                        do {
                            try managedObjectContext.save()
                            SVProgressHUD.dismiss()
                            self.getData()
                        } catch {
                            fatalError("Failure to save context in Entidades Federativas, with error: \(error)")
                        }
                    }
                }
        }
    }
    
    //MARK: Progress
    private func checkTaskRequestsAndDismissPorgress(error: NSError?){
        
        Alamofire.Manager.sharedInstance.session.getAllTasksWithCompletionHandler { (tasks) -> Void in
            print("Tasks Running: \(tasks.count)")
            
            if tasks.isEmpty {
                
                switch self.connectionState{
                    
                case .DownloadProductos:
                    print("END Download all Products")
                    
                    if error == nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.getData()
                        })
                        
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            SVProgressHUD.dismiss()
                        })
                    }
                default:
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        SVProgressHUD.dismiss()
                    })
                }
            }
        }
    }
}