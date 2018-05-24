//
//  MainSettingTableViewCell.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 02/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class MainSettingTableViewCell: UITableViewCell {

    @IBOutlet var icon_Next: UIImageView!
    @IBOutlet var lbl_title: UILabel!
    @IBOutlet var txt_Value: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    } 
}
