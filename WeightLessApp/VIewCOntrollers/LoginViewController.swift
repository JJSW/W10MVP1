//
//  LoginViewController.swift
//  WeightLessApp
//
//  Created by Krupa Detroja on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var txt_Email: ACFloatingTextfield!
    @IBOutlet var txt_Password: ACFloatingTextfield!
    @IBOutlet var Btn_Login: CustomButton!
    @IBOutlet var Btn_ForgotPassword: UIButton!
    var CategoryList: DatabaseReference!
    var SubCategory: DatabaseReference!
    var UserList: DatabaseReference!
    var CategoryValue: DatabaseReference!
    var artistList : [String] = []
    var DeletedItemList: DatabaseReference!
    var timer = Timer()
    var timer1 = Timer()
    var UserDataList : UserModel!
    var itemsCountDay: [Float] = [0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3]
    var itemsPerDay: [Int] = [50,75,100,125,150,175,200,225,250,275,300,325]
    
    override func viewDidLoad() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        setnavgationbar(title: "Login",backButton: true,self,#selector(leftBarButtonTapped), BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(TimerInvalid), name: NSNotification.Name(rawValue: "TimerInvalid"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GetCategory), name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DeleteItems), name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
        txt_Password.delegate = self
        txt_Email.delegate = self
        //MARK : touch OutSide the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.MainView.addGestureRecognizer(tap)
    }
    
    //MARK : Textfield Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(textField == txt_Password) {
            if ((txt_Password.text?.characters.count)! < 6) {
                if(txt_Password.text == "") {
                    txt_Password.errorText = "Password can't be blank!"
                    txt_Password.showError()
                } else {
                    txt_Password.errorText = "Password must have min. 6 characters!"
                    txt_Password.showError()
                }
            }  else {
                txt_Password.errorText = ""
                txt_Password.hideError()
            }
        }
        if(textField == txt_Email) {
            if (!validateEmail(txt_Email.text!)) {
                if(txt_Email.text == "") {
                    txt_Email.errorText = "Email can't be blank!"
                    txt_Email.showError()
                } else {
                    txt_Email.errorText = "Invalid email!"
                    txt_Email.showError()
                }
            } else {
                txt_Email.errorText = ""
                txt_Email.hideError()
            }
        }
    }
    
    //MARK : Delete Items
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
                    //iterating through all the values
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
    
    //Action Forgot Password
    @IBAction func Action_ForgotPassword(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        VC.type = 1
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK : Action Login
    @IBAction func Action_Login(_ sender: Any) {
        self.view.endEditing(true)
        if ((txt_Password.text?.characters.count)! < 6) {
            if(txt_Password.text == "") {
                txt_Password.errorText = "Password can't be blank!"
                txt_Password.showError()
            } else {
                txt_Password.errorText = "Password must have min. 6 characters!"
                txt_Password.showError()
            }
        }  else {
            txt_Password.errorText = ""
            txt_Password.hideError()
        }
        if (!validateEmail(txt_Email.text!)) {
            if(txt_Email.text == "") {
                txt_Email.errorText = "Email can't be blank!"
                txt_Email.showError()
            } else {
                txt_Email.errorText = "Invalid email!"
                txt_Email.showError()
            }
        } else {
            txt_Email.errorText = ""
            txt_Email.hideError()
        }
        if txt_Password.errorText == "" {
            if txt_Email.errorText == "" {
                loginAction()
            }
        }
    }
    
    //MARK : Action Login From Firebase
    func loginAction() {
        UserDefaults.standard.set("", forKey: "ReloadList")
        if self.txt_Email.text == "" || self.txt_Password.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            ActivityView.showActivityIndicator()
            Auth.auth().signIn(withEmail: self.txt_Email.text!, password: self.txt_Password.text!) { (user, error) in
                if error == nil {
                    self.DeleteItems()
                    self.GetCategory()
                    self.UserList = Database.database().reference().child("UserList");
                    //observing the data changes
                    self.UserList.observe(DataEventType.value, with: { (snapshot) in
                        //if the reference have some values
                        if snapshot.childrenCount > 0 {
                            //clearing the list
                            //iterating through all the values
                            for UserDataList in snapshot.children.allObjects as! [DataSnapshot] {
                                //getting values
                                let UserDataListObject = UserDataList.value as? [String: AnyObject]
                                let id = UserDataListObject?["id"] as! String
                                let uid = UserDataListObject?["uid"] as! String
                                let email = UserDataListObject?["email"]
                                let purchasedate = UserDataListObject?["date"]
                                let isPurchased = UserDataListObject?["isPurchased"]
                                let DailyTarget = UserDataListObject?["DailyTarget"]
                                let DailyTargetIndex = UserDataListObject?["DailyTargetIndex"]
                                let DailypercentTarget = UserDataListObject?["DailypercentTarget"]
                                if(user?.uid == uid) {
                                    //creating artist object with model and fetched values
                                    let UserInfo = UserModel(uid: uid, email: email as? String, isPurchased: isPurchased as? String, DailyTarget: DailyTarget as? Int, DailyTargetIndex: DailyTargetIndex as? Int, DailypercentTarget: DailypercentTarget as? Float, id: id)
                                    //appending it to list
                                    self.UserDataList = UserInfo
                                    UserDefaults.standard.set(id, forKey: "id")
                                    UserDefaults.standard.set(self.UserDataList.DailyTarget, forKey: "DailyTarget")
                                    UserDefaults.standard.set(purchasedate, forKey: "date")
                                    UserDefaults.standard.set(self.UserDataList.isPurchased, forKey: "isPurchased")
                                UserDefaults.standard.set(self.UserDataList.DailyTargetIndex, forKey: "DailyTargetIndex")
                                UserDefaults.standard.set(self.UserDataList.DailypercentTarget, forKey: "DailypercentTarget")
                                }
                            }
                        }
                    })
                    UserDefaults.standard.set(user?.displayName, forKey: "UserName")
                    UserDefaults.standard.set(user?.email, forKey: "UserEmail")
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                } else {
                    ActivityView.hideActivityIndicator()
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //MARK : Timer Invalid
    @objc func TimerInvalid() {
        timer.invalidate()
        timer1.invalidate()
    }
    
    //MARK : Timer Invalid
    @objc func StartTimer() {
        GetCategory()
    }
    
    //MARK : Get Data From Firebase Database ANd Store Into Local Database
    @objc func GetCategory() {
        self.timer.invalidate() // just in case this button is tapped multiple times
        // start the timer
        // create the alert
        self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.GetCategory), userInfo: nil, repeats: true)
        DispatchQueue.global().async {
            ActivityView.showActivityIndicator()
            self.CategoryList = Database.database().reference().child("Data");
            //observing the data changes
            self.CategoryList.observe(DataEventType.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshot {
                        let mainkey = snap.key
                        if let snap0 = snap.children.allObjects as? [DataSnapshot] {
                            if(snap.children.allObjects.count > 0) {
                                let categoryname = snap.childSnapshot(forPath: "categoryName")
                                let CategoryName = categoryname.value as! String
                                if self.artistList.contains(CategoryName) {
                                } else {
                                    self.artistList.append(CategoryName)
                                }
                                let defaults = UserDefaults.standard
                                defaults.set(self.artistList, forKey: "SavedStringArray")
                                for snap1 in snap0 {
                                    if let postDict = snap1.value as? Dictionary<String, AnyObject> {
                                        let key = snap1.key
                                        if( key != "categoryName") {
                                            if let postDict1 = postDict["url_image"] as? Dictionary<String, AnyObject> {
                                                let artist : Model!
                                                artist = Model(category_name: CategoryName, subCategory_name: postDict["Product_title"] as? String, subCategory_id: key, category_id: mainkey, Calories: postDict["Weight"] as? String, Carbs: postDict["Carbs"] as? String , Cholesterol: postDict["Cholesterol"] as? String, Fat: postDict["Fat"] as? String, Fibers: postDict["Fibers"] as? String, Iron: postDict["Iron"] as? String, MonoUnsaturated: postDict["MonoUnsaturated"] as? String, PolyUnsaturated: postDict["PolyUnsaturated"] as? String, Potassium: postDict["Potassium"] as? String, Protein: postDict["Protein"] as? String, Saturated: postDict["Saturated"] as? String, Sodium: postDict["Sodium"] as? String, Sugars: postDict["Sugars"] as? String, Trans: postDict["Trans"] as? String, Vitamin_A: postDict["Vitamin_A"] as? String, Vitamin_C: postDict["Vitamin_C"] as? String, Url_image: postDict1["image_100"] as? String, calcium: postDict["Calcium"] as? String, ishidden: postDict["is_Hidden"] as? String, Ispremium: postDict["Is_Premium"] as? String, Img_0: postDict1["image_100"] as? String, Img_1: postDict1["image_125"] as? String, Img_2: postDict1["image_150"] as? String, Img_3: postDict1["image_175"] as? String, Img_4: postDict1["image_200"] as? String, Img_5: postDict1["image_225"] as? String, Img_6: postDict1["image_250"] as? String, Img_7: postDict1["image_275"] as? String, Img_8: postDict1["image_300"] as? String, Img_9: postDict1["image_325"] as? String, Img_10: postDict1["image_050"] as? String, Img_11: postDict1["image_075"] as? String, Desc_050: postDict1["desc_050"] as? String, Desc_075: postDict1["desc_075"] as? String, Desc_100: postDict1["desc_100"] as? String, Desc_125: postDict1["desc_125"] as? String, Desc_150: postDict1["desc_150"] as? String, Desc_175: postDict1["desc_175"] as? String, Desc_200: postDict1["desc_200"] as? String, Desc_225: postDict1["desc_225"] as? String, Desc_250: postDict1["desc_250"] as? String, Desc_275: postDict1["desc_275"] as? String, Desc_300: postDict1["desc_300"] as? String, Desc_325: postDict1["desc_325"] as? String, Alcohol_Sugars : postDict["Alcohol_Sugars"] as? String, Alcohol_Fats : postDict["Alcohol_Fats"] as? String )
                                                MessageManager.sharedInstance.insertRecord(model: artist)
                                            }
                                            
                                        }
                                    }
                                }
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadList"), object: nil)
                                ActivityView.hideActivityIndicator()
                            }
                        }
                    }
                }
            })
        }
    }
    
    //MARK : Default Back Navigation
    @objc func leftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK : Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



