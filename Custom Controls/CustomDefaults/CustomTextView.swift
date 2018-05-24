//
//  CustomTextView.swift
//  GoTeam
//
//  Created by IBL Infotech on 6/5/17.
//  Copyright © 2017 IBL Infotech. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

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
