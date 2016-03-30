//
//  ViewController.swift
//  TestRappi
//
//  Created by VaD on 22/03/16.
//  Copyright © 2016 TestMauricioJimenez. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SVProgressHUD


enum UIUserInterfaceIdiom : Int {
    case Unspecified
    
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Variables of Model
    var managedObjectContext: NSManagedObjectContext!
    
    var CategoryArray = [Category]()
    var rowSelect :Int = 0
    
    @IBOutlet var collectionP: UICollectionView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "CustomSegue" {
            
            let nav = segue.destinationViewController as! DetailCategory
            
            if let nombre = CategoryArray[rowSelect].valueForKey("nameCategory") as? String {
                // Set Cell
                nav.nameCategory = nombre
            }
            if let count = CategoryArray[rowSelect].valueForKey("productsData") as? NSData{
                let dataP:NSArray = (NSKeyedUnarchiver.unarchiveObjectWithData(count) as? NSArray)!
                nav.dataCategory = dataP
            }
            
            if segue is CustomSegue {
                (segue as! CustomSegue).animationType = .GrowScale
            }
            
            // addEventViewController.delegate = self
            //addEventViewController.indice = ProductIndex
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menú Principal"
        // Get Core Data Manager Context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reloadView:",
            name: "loadData",
            object: nil)
        
        GetDataWS()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func GetDataWS(){
        if let products = HandlerIO.getProductStorage("Category") as? [Category] {
            if products.isEmpty {
                print("Products is Empty")
                // 1. Download "Products"
                let objeto: HandlerIO = HandlerIO()
                objeto.getData()
                CategoryArray = products
                collectionP.reloadData()
                
            }else{
                print("# products in storage: \(products.count)")
                
                CategoryArray = products
                collectionP.reloadData()
            }
        }
    }
    
    @objc func reloadView(notification: NSNotification){
        //do stuff
        GetDataWS()
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionP.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return CategoryArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellP", forIndexPath: indexPath) as! CellCategory
        
        // Get Object
        let object = CategoryArray[row]
        
        if let nombre = object.valueForKey("nameCategory") as? String {
            // Set Cell
            cell.nameC.text = nombre
        }
        if let count = object.valueForKey("productsData") as? NSData{
            let dataP:NSArray = (NSKeyedUnarchiver.unarchiveObjectWithData(count) as? NSArray)!
            cell.countC.text = "\(dataP.count)"
        }
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
        
    
    }
    func collectionView(collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: NSIndexPath){
        rowSelect = indexPath.row
       /* if let count = CategoryArray[row].valueForKey("productsData") as? NSData{
            let dataP:NSArray = (NSKeyedUnarchiver.unarchiveObjectWithData(count) as? NSArray)!
            //print(dataP)
           
        }*/
         performSegueWithIdentifier("CustomSegue", sender: nil)
        
    }
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
        case .Phone:
            // It's an iPhone
           return CGSizeMake(collectionView.frame.width, 80)
        case .Pad:
            // It's an iPad
           return CGSizeMake(235, 250)
        case .Unspecified:
            return CGSizeMake(collectionView.frame.width, 80)
            // Uh, oh! What could it be?
        default:
            return CGSizeMake(collectionView.frame.width, 80)
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets{
            return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        animateCell(cell)
    }
    
    func animateCell(cell: UICollectionViewCell) {
        let fromValue = 0
        let toValue = cell.layer.bounds.height
        CATransaction.setDisableActions(true)
        cell.layer.bounds.size.height = toValue
        let positionAnimation = CABasicAnimation(keyPath: "bounds.size.height")
        positionAnimation.fromValue = fromValue
        positionAnimation.toValue = toValue
        positionAnimation.duration = 0.4
        cell.layer.addAnimation(positionAnimation, forKey: "bounds")
    }
    
    func animateCellAtIndexPath(indexPath: NSIndexPath) {
        guard let cell = collectionP.cellForItemAtIndexPath(indexPath) else { return }
        animateCell(cell)
    }
    
    
    
    // MARK: methods for segues
    @IBAction func unwindFromViewController(sender: UIStoryboardSegue) {
        
    }
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        print(identifier)
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .Push
        return segue
    }

}

