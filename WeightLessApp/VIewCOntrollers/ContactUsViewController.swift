//
//  ContactUsViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 05/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavgationbar(title: "Contact Us", backButton: true, self, #selector(leftBarButtonTapped),BackButtonTintColor: UIColor.white, TitleLabelColor: UIColor.white, MainBackgroundColor: NeavyBlueColor )
    }
    
    //MARK : Action Default Back button
    @objc func leftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
