//
//  DashboardViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase
class DashboardViewController: UIViewController ,UISearchBarDelegate,UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var Btn_Logout: UIButton!
    @IBOutlet var Vw_List: UIView!
    @IBOutlet var Vw_Setting: UIView!
    @IBOutlet var tbl_Setting: UITableView!
    @IBOutlet var Collection_ListItems: UICollectionView!
    var ViewController1 : SettingViewController?
    var Categories: [Model]!
    var filteredCategories : [Model]!
    var searchActive : Bool = false
    @IBOutlet var Vw_NoResult: UIView!
    var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 80, height: 1))
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWillAppear(false)
        Vw_NoResult.isHidden = true
        searchBar.showsCancelButton = false
        Categories = MessageManager.sharedInstance.LoadAllRecord()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionChange), name: NSNotification.Name(rawValue: "CollectionReload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionChange), name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionChange1), name: NSNotification.Name(rawValue: "ReloadList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(leftBarButtonTapped), name: NSNotification.Name(rawValue: "SideBarClose"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingButtonTapped), name: NSNotification.Name(rawValue: "SettingButtonTapped"), object: nil)
        self.Vw_List.isHidden = false
        self.Vw_Setting.isHidden = true
        self.Collection_ListItems.delegate = self
        self.Collection_ListItems.dataSource = self
        searchActive = false
        self.Collection_ListItems.reloadData()
        let nib1 = UINib(nibName: "ListItemCollectionViewCell", bundle: nil)
        Collection_ListItems.register(nib1, forCellWithReuseIdentifier: "Cell")
        self.tbl_Setting.delegate = self
        self.tbl_Setting.dataSource = self
        let nib = UINib(nibName: "MainSettingTableViewCell", bundle: nil)
        self.tbl_Setting.register(nib, forCellReuseIdentifier: "MainSettingTableViewCell")
        Collection_ListItems.isHidden = false
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.textField.clearButtonMode = .never
        searchBar.textField.tintColor = .white
        searchBar.textField.placeholder = ""
        searchBar.setImage(UIImage(named : "ic_search"), for: .search, state: .normal)
    }
    
    //MARK : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchActive = false
        self.Collection_ListItems.reloadData()
        setSearchBarnavgationbar(LeftButton: true, RightButton: true, self, #selector(leftBarButtonTapped), #selector(RightBarButtonTapped))
        UIApplication.shared.statusBarView?.backgroundColor = NeavyBlueColor
        self.tbl_Setting.reloadData()
    }
    
    //MARK : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        self.tbl_Setting.reloadData()
        searchActive = false
        self.Collection_ListItems.reloadData()
    }
    
    //MARK : Change Category
    @objc func ReloadData(notification: NSNotification) {
        DispatchQueue.main.async {
            self.Collection_ListItems.reloadData()
        }
    }
    
    //MARK : Change Category
    @objc func CollectionChange(notification: NSNotification) {
        DispatchQueue.main.async {
            if(UserDefaults.standard.string(forKey: "ReloadList") == nil) {
                UserDefaults.standard.set("", forKey: "ReloadList")
            }
            if(UserDefaults.standard.string(forKey: "ReloadList")! == "") {
                self.Categories = MessageManager.sharedInstance.LoadAllRecord()
            } else {
                self.Categories = MessageManager.sharedInstance.LoadCategory(Categoryname: UserDefaults.standard.string(forKey: "ReloadList")!)
            }
            self.Collection_ListItems.reloadData()
        }
        searchActive = false
    }
    
    //MARK : Change Category
    @objc func CollectionChange1(notification: NSNotification) {
        DispatchQueue.main.async {
            if(UserDefaults.standard.string(forKey: "ReloadList") == nil) {
                UserDefaults.standard.set("", forKey: "ReloadList")
            }
            if(UserDefaults.standard.string(forKey: "ReloadList")! == "") {
                self.Categories = MessageManager.sharedInstance.LoadAllRecord()
            } else {
                self.Categories = MessageManager.sharedInstance.LoadCategory(Categoryname: UserDefaults.standard.string(forKey: "ReloadList")!)
            }
            self.Collection_ListItems.reloadData()
        }
        searchActive = false
    }
    
    //MARK : Set Navigation Bar
    //AMRK : Set Searchbar On Navigation Bar
    func setSearchBarnavgationbar(LeftButton:Bool,RightButton:Bool, _ controller:UIViewController,_ Leftselector : Selector?,_ Rightselector : Selector?) {
        let image : UIImage = UIImage(named: "Logo")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DashboardViewController.connected(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        self.navigationItem.titleView = imageView
        controller.navigationItem.setHidesBackButton(true, animated:false);
        controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.navigationBar.isTranslucent = true
        controller.navigationController?.navigationBar.backgroundColor = NeavyBlueColor
        if LeftButton {
            let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_sidemenu"), style: .plain, target: controller, action: Leftselector)
            leftBarButton.tintColor = UIColor.white
            controller.navigationItem.leftBarButtonItem = leftBarButton
        }
        if RightButton {
            let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_search"), style: .plain, target: controller, action: Rightselector)
            rightBarButton.tintColor = UIColor.white
            controller.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    @objc func connected(_ sender:AnyObject){
        Vw_Setting.isHidden = true
        Vw_List.isHidden = false
        UserDefaults.standard.set("", forKey: "ReloadList")
        Categories = MessageManager.sharedInstance.LoadAllRecord()
        if(Categories.count > 0) {
            self.Collection_ListItems.scrollsToTop = true
        }
        Collection_ListItems.reloadData()
    }
    
    //SearchBar Delegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchActive = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
        if searchText == "" {
            searchActive = false
        } else {
            let searchString = searchText
            var Item :  Model!
            if(Categories != nil) {
                filteredCategories = self.Categories.filter({ (item) -> Bool in
                    Item = item
                    let countryText: NSString = Item.SubCategory_name! as NSString
                    return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
                })
            }
        }
        self.Collection_ListItems.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchBar.resignFirstResponder()
        self.Collection_ListItems.reloadData()
        return
    }
    func didPresentSearchController(_ searchController: UISearchController) {
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.Collection_ListItems.reloadData()
        viewDidLoad()
    }
    
    //MARK : Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            if (filteredCategories != nil) {
                if(filteredCategories.count == 0 ) {
                    Vw_NoResult.isHidden = false
                    return 0
                } else {
                    Vw_NoResult.isHidden = true
                    return filteredCategories.count
                }
            } else {
                return 0
            }
        } else {
            if(Categories != nil) {
                if(Categories.count == 0 ) {
                    Vw_NoResult.isHidden = false
                    return 0
                } else {
                    Vw_NoResult.isHidden = true
                    return Categories.count
                }//return number of rows in section
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ListItemCollectionViewCell
        cell.imgVW_Height.constant = self.view.frame.size.width/2-2
        cell.imgVW_Width.constant = (self.view.frame.size.width/2)
        cell.BackGround_Width.constant = (self.view.frame.size.width/2)
        cell.BackGround_Height.constant = self.view.frame.size.width/2-2
        cell.Btn_LockWidth.constant = (self.view.frame.size.width/2)
        cell.Btn_LockHeight.constant = self.view.frame.size.width/2-2
        cell.backgroundColor = UIColor.clear
        cell.Btn_Lock.isHidden = true
        cell.BackgroundVw.layer.cornerRadius = 0.0
        cell.BackgroundVw.layer.borderWidth = 0.1
        cell.lbl_noInternet.isHidden = true
        cell.BackgroundVw.layer.borderColor = UIColor.lightGray.cgColor
        cell.BackgroundVw.layer.masksToBounds = true;
        cell.imgVW.isHidden = false
        if(isInternetRechable) {
            if searchActive {
                var url = ""
                if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 0) {
                    url = filteredCategories[indexPath.row].img_10! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 1) {
                    url = filteredCategories[indexPath.row].img_11! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 2) {
                    url = filteredCategories[indexPath.row].img_0! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 3) {
                    url = filteredCategories[indexPath.row].img_1! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 4) {
                    url = filteredCategories[indexPath.row].img_2! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 5) {
                    url = filteredCategories[indexPath.row].img_3! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 6) {
                    url = filteredCategories[indexPath.row].img_4! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 7) {
                    url = filteredCategories[indexPath.row].img_5! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 8) {
                    url = filteredCategories[indexPath.row].img_6! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 9) {
                    url = filteredCategories[indexPath.row].img_7! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 10) {
                    url = filteredCategories[indexPath.row].img_8! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 11) {
                    url = filteredCategories[indexPath.row].img_9! as String
                } else {
                    url = filteredCategories[indexPath.row].url_image! as String
                }
                if(UserDefaults.standard.string(forKey: "isPurchased") != "Breakfast") {
                    if(filteredCategories[indexPath.row].IsPremium == "1") {
                        cell.Btn_Lock.isHidden = false
                    } else {
                        cell.Btn_Lock.isHidden = true
                    }
                } else {
                    cell.Btn_Lock.isHidden = true
                }
                cell.imgVW.loadImageWithUrl(url)
            } else {
                var url = ""
                if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 0) {
                    url = Categories[indexPath.row].img_10! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 1) {
                    url = Categories[indexPath.row].img_11! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 2) {
                    url = Categories[indexPath.row].img_0! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 3) {
                    url = Categories[indexPath.row].img_1! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 4) {
                    url = Categories[indexPath.row].img_2! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 5) {
                    url = Categories[indexPath.row].img_3! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 6) {
                    url = Categories[indexPath.row].img_4! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 7) {
                    url = Categories[indexPath.row].img_5! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 8) {
                    url = Categories[indexPath.row].img_6! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 9) {
                    url = Categories[indexPath.row].img_7! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 10) {
                    url = Categories[indexPath.row].img_8! as String
                } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 11) {
                    url = Categories[indexPath.row].img_9! as String
                } else {
                    url = Categories[indexPath.row].url_image! as String
                }
                if(UserDefaults.standard.string(forKey: "isPurchased") != "Breakfast") {
                    if(Categories[indexPath.row].IsPremium == "1") {
                        cell.Btn_Lock.isHidden = false
                    } else {
                        cell.Btn_Lock.isHidden = true
                    }
                } else {
                    cell.Btn_Lock.isHidden = true
                }
                cell.imgVW.loadImageWithUrl(url)
            }
        } else {
            cell.imgVW.isHidden = false
            cell.imgVW.image = UIImage(named : "")
            cell.imgVW.backgroundColor = UIColor.lightGray
            cell.lbl_noInternet.isHidden = true
        }
        cell.Btn_Lock.addTarget(self, action: #selector(ActionUpgrade(sender:)), for: .touchUpInside)
        cell.imgVW.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        if searchActive {
            VC.Categories = filteredCategories[indexPath.row]
            VC.SubCategoryid = filteredCategories[indexPath.row].SubCategory_id!
        } else {
            VC.Categories = Categories[indexPath.row]
            VC.SubCategoryid = Categories[indexPath.row].SubCategory_id!
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/2-1, height: self.view.frame.size.width/2)
    }
    
    //MARK: tableview Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Title : NSMutableArray = ["Change Username","Change Email","Reset Password","Membership","Daily Calorie target","Contact Us", "App Details"]
        let Value : NSMutableArray = [UserDefaults.standard.string(forKey: "UserName") as Any, UserDefaults.standard.string(forKey: "UserEmail") as Any , "" ,UserDefaults.standard.string(forKey: "isPurchased") as Any, "\(UserDefaults.standard.integer(forKey: "DailyTarget")) Cal","", ""]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainSettingTableViewCell", for: indexPath) as! MainSettingTableViewCell
        cell.lbl_title.text = Title[indexPath.row] as? String
        cell.txt_Value.text = Value[indexPath.row] as? String
        cell.icon_Next.isHidden = true
        cell.txt_Value.isEnabled = true
        cell.txt_Value.delegate = self
        if(indexPath.row == 0) {
            cell.txt_Value.tag = indexPath.row
        }
        if(indexPath.row == 1) {
            cell.txt_Value.tag = indexPath.row
        }
        if(indexPath.row == 2) {
            cell.icon_Next.isHidden = false
            cell.txt_Value.isEnabled = false
        }
        if(indexPath.row == 3) {
            cell.icon_Next.isHidden = false
            cell.txt_Value.isEnabled = false
        }
        if(indexPath.row == 4) {
            cell.icon_Next.isHidden = false
            cell.txt_Value.isEnabled = false
        }
        if(indexPath.row == 5) {
            cell.icon_Next.isHidden = false
            cell.txt_Value.isEnabled = false
        }
        if(indexPath.row == 6) {
            cell.icon_Next.isHidden = false
            cell.txt_Value.isEnabled = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 2) {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
            VC.type = 2
            self.navigationController?.pushViewController(VC, animated: true)
        }
        if(indexPath.row == 3) {
            // create the alert
            let alert = UIAlertController(title: "UPGRADE", message: "Upgrade to unlock all photos!", preferredStyle: UIAlertControllerStyle.alert)
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Purchase", style: UIAlertActionStyle.default, handler: {
                (action) in
                InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
            }))
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Restore", style: UIAlertActionStyle.default, handler: {
                (action) in
                InAppPurchase.sharedInstance.restoreTransactions()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            //self.present(alert, animated: true, completion: nil)
        }
        if(indexPath.row == 4) {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DailyCalorieTargetViewController") as! DailyCalorieTargetViewController
            VC.type = 1
            self.navigationController?.pushViewController(VC, animated: true)
        }
        if(indexPath.row == 5) {
            guard let url = URL(string: "http://weightless10.com/contact/") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        if(indexPath.row == 6) {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    //MARK : Settings >> Update Email
    func UpdateMail( Email : String) {
        ActivityView.showActivityIndicator()
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: Email, completion: { (error) in
                if error != nil {
                    ActivityView.hideActivityIndicator()
                    self.tbl_Setting.reloadData()
                    let alertController = UIAlertController(title: "Failed", message: "Update Email Failed", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    ActivityView.hideActivityIndicator()
                    UserDefaults.standard.set(Email, forKey: "UserEmail")
                    self.updateArtist()
                    let alertController = UIAlertController(title: "Success", message: "email Updated Successfully", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        (result : UIAlertAction) -> Void in
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK : Settings >> Update Username
    func UpdateName( Username : String) {
        ActivityView.showActivityIndicator()
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = Username
        changeRequest?.commitChanges { (error) in
            if error == nil {
                ActivityView.hideActivityIndicator()
                UserDefaults.standard.set(Username, forKey: "UserName")
                self.updateArtist()
            } else {
                ActivityView.hideActivityIndicator()
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func updateArtist(){
        //creating artist with the new given values
        let userID = Auth.auth().currentUser?.uid
        let artist = ["id":UserDefaults.standard.string(forKey: "id") as Any,
                      "uid":userID!,
                      "email": UserDefaults.standard.string(forKey: "UserEmail") as Any,
                      "purchasedate": UserDefaults.standard.string(forKey: "date") as Any,
                      "isPurchased": UserDefaults.standard.string(forKey: "isPurchased") as Any,
                      "isBlocked": "1",
                      "DailyTarget": UserDefaults.standard.string(forKey: "DailyTarget") as Any,
                      "DailyTargetIndex": UserDefaults.standard.string(forKey: "DailyTargetIndex") as Any,
                      "DailypercentTarget": UserDefaults.standard.string(forKey: "DailypercentTarget") as Any
            ] as [String : Any]
        //updating the artist using the key of the artist
        Database.database().reference().child("UserList").child(UserDefaults.standard.string(forKey: "id")!).setValue(artist)
    }
    
    //MARK : Textfield Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField) {
        // For UserName
        if(textField.tag == 0) {
            if(UserDefaults.standard.string(forKey: "UserName") != textField.text!) {
                let alertController = UIAlertController(title: "Update", message: "Are you sure you want to update your user name?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.UpdateName(Username: textField.text!)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    self.tbl_Setting.reloadData()
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        //For User Eamil
        if(textField.tag == 1) {
            if(UserDefaults.standard.string(forKey: "UserEmail") != textField.text!) {
                let alertController = UIAlertController(title: "Update", message: "Are you sure you want to update your user email?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.UpdateMail(Email: textField.text!)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in
                    self.tbl_Setting.reloadData()
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func Action_TapHereToRequestItem(_ sender: Any) {
        guard let url = URL(string: "http://weightless10.com/contact/") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    //MARK : Action Logout
    @IBAction func Action_Logout(_ sender: Any) {
        logOutAction()
    }
    
    //MARK : Action Logout From Firebase
    func logOutAction() {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
//                print(error)
            }
        }
        UserDefaults.standard.set("", forKey: "UserName")
        UserDefaults.standard.set("", forKey: "UserEmail")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TimerInvalid"), object: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: Action Upgrade
    @objc func ActionUpgrade(sender : UIButton) {
        // create the alert
        let alert = UIAlertController(title: "UPGRADE", message: "Upgrade to unlock all photos!", preferredStyle: UIAlertControllerStyle.alert)
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Purchase", style: UIAlertActionStyle.default, handler: {
            (action) in
            InAppPurchase.sharedInstance.buyUnlockTestInAppPurchase1()
        }))
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Restore", style: UIAlertActionStyle.default, handler: {
            (action) in
            InAppPurchase.sharedInstance.restoreTransactions()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
     //   self.present(alert, animated: true, completion: nil)
    }
    
    //MARK : Open And Close Sidebar
    @objc func leftBarButtonTapped() {
        if ViewController1 == nil {
            if let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
                self.addChildViewController(accountViewController)
                accountViewController.view.frame = CGRect(x: -self.view.bounds.size.width,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                self.view.addSubview(accountViewController.view)
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    accountViewController.view.frame = CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                }, completion: { (finished) -> Void in
                    //rightBarItem.enabled = true
                })
                accountViewController.didMove(toParentViewController: self)
                self.ViewController1 = accountViewController
            }
        } else {
            self.Vw_List.isHidden = false
            self.Vw_Setting.isHidden = true
            if  let accountViewController = self.ViewController1 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    accountViewController.view.frame = CGRect(x: -self.view.bounds.size.width,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                }, completion: { (finished) -> Void in
                    accountViewController.view.removeFromSuperview()
                    accountViewController.removeFromParentViewController()
                    self.ViewController1 = nil;
                })
            }
        }
    }
    @objc func leftBarButtonTapped1() {
        viewDidLoad()
    }
    
    //MARK : Search Button Tapped
    @objc func RightBarButtonTapped() {
        //Setup Search Controller
        searchBar.delegate = self
        searchBar.tintColor = UIColor.white
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.white
        searchBar.searchBarStyle = UISearchBarStyle.default
        searchBar.setSearchFieldBackgroundImage(UIImage(named : ""), for: .normal)
        searchBar.placeholder = ""
        searchBar.textField.text = ""
        searchBar.tintColor = UIColor.white
        searchBar.clipsToBounds = true
        searchBar.searchBarStyle = .minimal
        searchBar.clearsContextBeforeDrawing = false
        searchBar.showsCancelButton = false;
        searchActive = false
        searchBar.becomeFirstResponder()
        searchBar.searchFieldBackgroundImage(for: .normal)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.tintColor = UIColor.white
        textFieldInsideSearchBar?.backgroundColor = NeavyBlueColor
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        let leftNavBarButton1 = UIBarButtonItem(image: UIImage(named: "ic_cancel"), style: .plain, target: self, action:#selector(leftBarButtonTapped1) )
        leftNavBarButton1.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = leftNavBarButton1
    }
    
    //MARK : Action Settings
    @objc func SettingButtonTapped() {
        searchActive = false
        self.Collection_ListItems.reloadData()
        self.Vw_List.isHidden = true
        self.Vw_Setting.isHidden = false
        if ViewController1 == nil {
            if let accountViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController {
                self.addChildViewController(accountViewController)
                accountViewController.view.frame = CGRect(x: -self.view.bounds.size.width,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                self.view.addSubview(accountViewController.view)
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    accountViewController.view.frame = CGRect(x: 0,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                }, completion: { (finished) -> Void in
                    //rightBarItem.enabled = true
                })
                accountViewController.didMove(toParentViewController: self)
                self.ViewController1 = accountViewController
            }
        } else {
            if  let accountViewController = self.ViewController1 {
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    accountViewController.view.frame = CGRect(x: -self.view.bounds.size.width,y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height);
                }, completion: { (finished) -> Void in
                    accountViewController.view.removeFromSuperview()
                    accountViewController.removeFromParentViewController()
                    self.ViewController1 = nil;
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UISearchBar{
    var textField : UITextField{
        return self.value(forKey: "searchField") as! UITextField
    }
}
