//
//  DetailProductController.swift
//  TestRappi
//
//  Created by VaD on 30/03/16.
//  Copyright © 2016 TestMauricioJimenez. All rights reserved.
//

import UIKit
import Alamofire

class DetailProductController: UIViewController {
    
    var dataProduct: NSDictionary = NSDictionary()

    @IBOutlet var nameP: UILabel!
    @IBOutlet var artistP: UILabel!
    @IBOutlet var categoryP: UILabel!
    @IBOutlet var imageP: UIImageView!
    @IBOutlet var summaryP: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetData(){
        
        let imageURL = dataProduct.valueForKey("image64") as! String
        imageP.layer.cornerRadius = 8.0
        imageP.clipsToBounds = true
        Alamofire.request(.GET, imageURL).response() {
            (_, _, data, _) in
            let image = UIImage(data: data! )
            self.imageP.image = image
        }
        nameP.text = dataProduct.valueForKey("name") as? String
        artistP.text = dataProduct.valueForKey("artist") as? String
        categoryP.text = dataProduct.valueForKey("category") as? String
        summaryP.text = dataProduct.valueForKey("summary") as? String
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
