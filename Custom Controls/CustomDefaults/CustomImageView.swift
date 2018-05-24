//
//  CustomImageView.swift
//  GoTeam
//
//  Created by IBL Infotech on 09/06/17.
//  Copyright © 2017 IBL Infotech. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

   @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

}
