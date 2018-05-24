//
//  EmailSentSuccesfullyViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class EmailSentSuccesfullyViewController: UIViewController {
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        setnavgationbar(title: "",backButton: true,self,#selector(leftBarButtonTapped), BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
        super.viewDidLoad()
    }
    
    //MARK : Action Default Back button
    @objc func leftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK : Action Check Mail (OK)
    @IBAction func Action_CheckMail(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
