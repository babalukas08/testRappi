//
//  DetailCategory.swift
//  TestRappi
//
//  Created by VaD on 28/03/16.
//  Copyright © 2016 TestMauricioJimenez. All rights reserved.
//

import UIKit
import Alamofire

class DetailCategory: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var dataCategory : NSArray = NSArray()
    var nameCategory : String!
    var rowSelect :Int = 0
    
    @IBOutlet var collectionApp: UICollectionView!
    @IBOutlet var tittleCategory: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(nameCategory)
        print(dataCategory)
        tittleCategory.text = nameCategory
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueDetail" {
            
            let nav = segue.destinationViewController as! DetailProductController
            nav.dataProduct = dataCategory.objectAtIndex(rowSelect) as! NSDictionary
            
            if segue is CustomSegue {
                (segue as! CustomSegue).animationType = .GrowScale
            }
            
            // addEventViewController.delegate = self
            //addEventViewController.indice = ProductIndex
        }
        
        
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return dataCategory.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellApp", forIndexPath: indexPath) as! cellApp
            
            // Set Cell
            cell.nameApp.text = dataCategory.objectAtIndex(row).valueForKey("name") as? String
            
            cell.artistApp.text = dataCategory.objectAtIndex(row).valueForKey("artist") as? String
            
            let imageURL = dataCategory.objectAtIndex(row).valueForKey("image64") as! String
            
            
            
            cell.imageApp.layer.cornerRadius = 8.0
            cell.imageApp.clipsToBounds = true
            Alamofire.request(.GET, imageURL).response() {
                (_, _, data, _) in
                
                let image = UIImage(data: data! )
                //imageCat!.image = image
                cell.imageApp.image = image
            }
            cell.backgroundColor = UIColor.grayColor()
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellIpad", forIndexPath: indexPath) as! CellViewIpad
            
            // Set Cell
            cell.nameAPP.text = dataCategory.objectAtIndex(row).valueForKey("name") as? String
            
            cell.artistAPP.text = dataCategory.objectAtIndex(row).valueForKey("artist") as? String
            
            let imageURL = dataCategory.objectAtIndex(row).valueForKey("image64") as! String
            
            
            
            cell.imageAPP.layer.cornerRadius = 8.0
            cell.imageAPP.clipsToBounds = true
            Alamofire.request(.GET, imageURL).response() {
                (_, _, data, _) in
                
                let image = UIImage(data: data! )
                //imageCat!.image = image
                cell.imageAPP.image = image
            }
            cell.backgroundColor = UIColor.grayColor()
            
            return cell
        }
        
        
        
    }
    func collectionView(collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: NSIndexPath){
        rowSelect = indexPath.row
        performSegueWithIdentifier("segueDetail", sender: nil)
        
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
    
    // MARK: methods for segues
    @IBAction func DetailunwindFromViewController(sender: UIStoryboardSegue) {
        
    }
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        print(identifier)
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .Push
        return segue
    }
    

}
