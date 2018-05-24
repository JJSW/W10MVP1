//
//  SettingViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var Lbl_DailyCalorie: UILabel!
    @IBOutlet var Vw_Background: UIView!
    @IBOutlet var Btn_Settings: UIButton!
    @IBOutlet var tbl_Setting: UITableView!
    
    var refArtists: DatabaseReference!
    var artistList : [String] = []
    var fruit = [Model]()
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(GetCategory), name: NSNotification.Name(rawValue: "ReloadList"), object: nil)
        Lbl_DailyCalorie.text = "Portions: \(UserDefaults.standard.integer(forKey: "DailyTarget")) Cals"
        self.tbl_Setting.delegate = self
        self.tbl_Setting.dataSource = self
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        self.tbl_Setting.register(nib, forCellReuseIdentifier: "SettingTableViewCell")
        //MARK : touch OutSide the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        Vw_Background.addGestureRecognizer(tap)
        self.artistList = MessageManager.sharedInstance.LoadAllCategoryName()
        self.tbl_Setting.reloadData()
        // Do any additional setup after loading the view.
    }
    
    //MARK : viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tbl_Setting.reloadData()
    }
    
    //MARK : Tableview Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none
        cell.lbl.text = self.artistList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(self.artistList[indexPath.row], forKey: "ReloadList")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CollectionReload"), object: self.artistList[indexPath.row])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideBarClose"), object: nil)
    }
    
    //MARK : Load All Category
    @objc func GetCategory() {
        self.artistList = MessageManager.sharedInstance.LoadAllCategoryName()
        self.tbl_Setting.reloadData()
    }
    
    //AMRK : Action Settings
    @IBAction func ActionSettings(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingButtonTapped"), object: nil)
    }
    
    //MARK : Touch OutSide Of TextField
    @objc func dismissKeyboard() {
        view.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideBarClose"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
