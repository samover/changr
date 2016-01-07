//
//  MenuItems.swift
//  changr
//
//  Created by mahmud hussain on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class MenuItems {
    // MARK: Properties
    var title: String
    var icon: UIImage?
    
    // MARK: Initialisation
    init?(title: String, icon: UIImage?){
        self.title = title
        self.icon = icon
        
        if(title.isEmpty) {
            return nil
        }
    }
}
