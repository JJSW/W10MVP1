//
//  ItemDetailTableViewCell.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 07/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class ItemDetailTableViewCell: UITableViewCell {

    @IBOutlet var lbl_Value: UILabel!
    @IBOutlet var lbl_Key: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
