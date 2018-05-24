//
//  AlertViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet var Vw_BackgroundView: UIView!
    @IBOutlet var Btn_TryAgain: UIButton!
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK : touch OutSide the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //AMRK : Action Try Again
    @IBAction func Action_TryAgain(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
