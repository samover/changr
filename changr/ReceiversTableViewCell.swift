//
//  ReceiversTableViewCell.swift
//  changr
//
//  Created by Fergus Lemon on 04/01/2016.
//  Copyright © 2016 Samuel Overloop. All rights reserved.
//

import UIKit
import Firebase


class ReceiversTableViewCell: UITableViewCell {

    // MARK: Properties
    var firebase = FirebaseWrapper()


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    


}
