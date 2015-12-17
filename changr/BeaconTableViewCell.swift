//
//  BeaconTableViewCell.swift
//  changr
//
//  Created by Hamza Sheikh on 17/12/2015.
//  Copyright © 2015 Samuel Overloop. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var beaconInfoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
