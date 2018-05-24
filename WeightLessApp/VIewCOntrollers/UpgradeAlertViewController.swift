//
//  UpgradeAlertViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 07/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class UpgradeAlertViewController: UIViewController {
    
    @IBOutlet var BackgroundView: UIView!
    @IBOutlet var Btn_ClickHere: UIButton!
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        BackgroundView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //MARK : Action Click Here
    @IBAction func Action_ClickHere(_ sender: Any) {
        InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1() 
    }
    
    //MARK : Touch OutSide Of TextField
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
