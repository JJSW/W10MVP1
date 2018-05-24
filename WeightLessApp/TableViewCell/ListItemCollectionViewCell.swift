//
//  ListItemCollectionViewCell.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 02/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class ListItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet var BackGround_Width: NSLayoutConstraint!
    @IBOutlet var BackGround_Height: NSLayoutConstraint!
    @IBOutlet var BackgroundVw: UIView!
    @IBOutlet var imgVW_Height: NSLayoutConstraint!
    @IBOutlet var imgVW_Width: NSLayoutConstraint!
    @IBOutlet var imgVW: ImageLoader!
    @IBOutlet var Btn_LockWidth: NSLayoutConstraint!
    @IBOutlet var Btn_LockHeight: NSLayoutConstraint!
    @IBOutlet var Btn_Lock: CustomButton!
    @IBOutlet var lbl_noInternet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
    } 
}
