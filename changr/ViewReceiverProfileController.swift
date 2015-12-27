//
//  ViewReceiverProfileController.swift
//  changr
//
//  Created by Hamza Sheikh on 27/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class ViewReceiverProfileController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    var ref: Firebase!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://changr.firebaseio.com/users")
        
        let hamzaRef = ref.childByAppendingPath("f9357340-0795-4d8e-912e-75a64ae318ad")
        
            hamzaRef.observeEventType(.Value, withBlock: { snapshot in
                
            let decodedData = NSData(base64EncodedString: snapshot.value["profileImage"] as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            
            let decodedImage = UIImage(data: decodedData!)
            
            self.profileImageView.image = decodedImage
                
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
