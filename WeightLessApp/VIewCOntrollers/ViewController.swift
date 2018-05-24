//
//  ViewController.swift
//  WeightLessApp
//
//  Created by Krupa Detroja on 31/01/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftMessages

class ViewController: UIViewController {
    
    @IBOutlet var Btn_Login: CustomButton!
    @IBOutlet var Btn_SignUp: CustomButton!
    var refArtists1: DatabaseReference!
    var DeletedItemList: DatabaseReference!
    var timer = Timer()
    var timer1 = Timer()
    
    //MARK : ViewDidLoad
    override func viewDidLoad() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        super.viewDidLoad()
        refArtists1 = Database.database().reference().child("Files_url");
        refArtists1.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.children.allObjects.count > 0 {
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    let artistObject1 = artists.key
                    if( artistObject1 == "url_file") {
                        let defaults = UserDefaults.standard
                        defaults.set(artists.value as! String, forKey: "URL")
                    }
                }
                ActivityView.hideActivityIndicator()
            }
        })
        NotificationCenter.default.removeObserver(NSNotification.Name(rawValue: ReachabilityStatusChangedNotification))
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let data = notification.userInfo as? [String:Any]{
            if(data["Status"] as! String == "Offline") {
                ActivityView.hideActivityIndicator()
                let warning = MessageView.viewFromNib(layout: .cardView)
                warning.configureTheme(.warning)
                warning.configureDropShadow()
                let iconText = ["😳"].sm_random()!
                warning.configureContent(title: "Warning", body: "No Internet Connection", iconText: iconText)
                warning.button?.isHidden = true
                var warningConfig = SwiftMessages.defaultConfig
                warningConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                SwiftMessages.show(config: warningConfig, view: warning)
            }
        }
    }
    
    
    //MARK : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if (UserDefaults.standard.string(forKey: "UserEmail") != nil) {
            if (UserDefaults.standard.string(forKey: "UserEmail") != "") {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        setnavgationbar(title: "",backButton: false,self,nil, BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
    }
    
    @objc func DeleteItems() {
        self.timer1.invalidate() // just in case this button is tapped multiple times
        // start the timer
        self.timer1 = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.DeleteItems), userInfo: nil, repeats: true)
        DispatchQueue.global().async {
            self.DeletedItemList = Database.database().reference().child("Is_Deleted");
            self.DeletedItemList.observe(DataEventType.value, with: { (snapshot) in
                //if the reference have some values
                if snapshot.childrenCount > 0 {
                    //clearing the list
                    for DeletedItemList in snapshot.children.allObjects as! [DataSnapshot] {
                        //getting values
                        let DeletedObjectList = DeletedItemList.value as? [String: AnyObject]
                        if let CategoryId = DeletedObjectList?["Category_id"] as? String {
                            let SubCategoryId = DeletedObjectList?["SubCategory_id"] as? String
                            MessageManager.sharedInstance.DeleteRecord(Categoryid: CategoryId, SubCategoryid: SubCategoryId!)
                        }
                    }
                }
            })
        }
    }
    
    //MARK : Action Login
    @IBAction func Action_Login(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK: Action Signup
    @IBAction func Action_SignUp(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
