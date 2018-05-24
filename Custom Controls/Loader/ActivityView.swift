//
//  Merchant.swift
//  CashReady
//
//  Created by Nirmal Choudhari on 17/03/16.
//  Copyright © 2016 iOS Developer. All rights reserved.
//

import UIKit

/// Custom Activity view. This view is displayed when any operation is performed and we need to ask user to wait.
class ActivityView {

    static let tagToRemove = 700
   
    static var showingActivityIndicator: Bool = false
    
    /**
    Class function which adds activity view to window.
    */
    class func showActivityIndicator() {
        if !showingActivityIndicator{
            let ovelayView:UIView = UIView(frame: UIScreen.main.bounds)
            ovelayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            let window:UIWindow! = (UIApplication.shared.delegate!).window!
            window.addSubview(ovelayView)
            let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            let activityView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
            activityView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            activityView.layer.cornerRadius = 5
            activityIndicator.startAnimating()
            activityView.addSubview(activityIndicator)
            activityIndicator.center = activityView.center
            window.addSubview(activityView)
            activityView.center = window.center
            ovelayView.tag = tagToRemove
            activityView.tag = tagToRemove
            showingActivityIndicator = true
        }
    }
    
    /**
    Class Function which remove activity view from window.
    */
    class func hideActivityIndicator() {
        let window:UIWindow! = (UIApplication.shared.delegate!).window!
        for  viewToRemove in window.subviews {
            let view : UIView = viewToRemove as UIView
                if view.tag == tagToRemove {
                    view.removeFromSuperview()
                    showingActivityIndicator = false
                }        }
    }
}
