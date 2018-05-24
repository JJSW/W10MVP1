//
//  SignUpViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TTTAttributedLabel

class SignUpViewController: UIViewController, UITextFieldDelegate, TTTAttributedLabelDelegate {
    
    @IBOutlet var txt_Username: ACFloatingTextfield!
    @IBOutlet var txt_email: ACFloatingTextfield!
    @IBOutlet var txt_Password: ACFloatingTextfield!
    @IBOutlet var Btn_AcceptUpdate: CustomButton!
    @IBOutlet var Btn_SignUp: CustomButton!
    @IBOutlet var MainView: UIView!
    @IBOutlet var lbl_TP : TTTAttributedLabel!
    var refArtists: DatabaseReference!
    var DeletedItemList: DatabaseReference!
    var CategoryList: DatabaseReference!
    var SubCategory: DatabaseReference!
    var CategoryValue: DatabaseReference!
    var Userlist: DatabaseReference!
    var refArtists1: DatabaseReference!
    var artistList : [String] = []
    var UserList = [UserModel]()
    var timer = Timer()
    var timer1 = Timer()
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        Userlist = Database.database().reference().child("UserList");
        Btn_AcceptUpdate.setImage(UIImage(named : "ic_uncheck"), for: .normal)
        txt_Password.delegate = self
        txt_email.delegate = self
        txt_Username.delegate = self
        Addattributr()
        //MARK : touch OutSide the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.MainView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        setnavgationbar(title: "Signup",backButton: true,self,#selector(leftBarButtonTapped), BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
    }
    
    //MARK : Make Clickable Terms & PrivacyPolicy Label
    func Addattributr() {
        var mutableActiveLinkAttributes = [AnyHashable: Any]()
        mutableActiveLinkAttributes[(kCTUnderlineStyleAttributeName) as AnyHashable] = Int(truncating: true)
        mutableActiveLinkAttributes[(kCTForegroundColorAttributeName) as AnyHashable] = NeavyBlueColor
        var mutableLinkAttributes = [AnyHashable: Any]()
        mutableLinkAttributes[(kCTForegroundColorAttributeName) as AnyHashable] = NeavyBlueColor
        lbl_TP.activeLinkAttributes = mutableActiveLinkAttributes
        lbl_TP.linkAttributes = mutableLinkAttributes
        lbl_TP.delegate = self as TTTAttributedLabelDelegate
        lbl_TP.lineSpacing = 5.0
        lbl_TP.isUserInteractionEnabled = true
        lbl_TP.highlightedTextColor = NeavyBlueColor
        lbl_TP.text = "By creating your account, you have agreed to our Terms and Privacy Policy"
        lbl_TP.highlightedTextColor = NeavyBlueColor
        let range1: NSRange = (lbl_TP.text! as NSString).range(of: "Terms")
        lbl_TP.addLink(to: URL(string: "terms"), with: range1)
        let range2: NSRange = (lbl_TP.text! as NSString).range(of: "Privacy Policy")
        lbl_TP.addLink(to: URL(string: "Privacy"), with: range2)
    }
    
    //MARK : Delete Items
    @objc func DeleteItems() {
        self.timer1.invalidate() // just in case this button is tapped multiple times
        // start the timer
        self.timer1 = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.DeleteItems), userInfo: nil, repeats: true)
        DispatchQueue.global().async {
            self.DeletedItemList = Database.database().reference().child("Is_Deleted");
            self.DeletedItemList.observe(DataEventType.value, with
                : { (snapshot) in
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
    
    //MARK : Action On Terms & PrivacyPolicy
    func attributedLabel(_ label: TTTAttributedLabel!, didLongPressLinkWith url: URL!, at point: CGPoint) {
        if ( url == URL(string: "terms")) {
            guard let url = URL(string: "http://weightless10.com/terms-and-conditions/") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        if(url == URL(string: "Privacy")) {
            guard let url = URL(string: "http://weightless10.com/privacy-policy/") else {
                return //be safe
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK : TextField Delegate Methods
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
        if(textField == txt_email) {
            if (!validateEmail(txt_email.text!)) {
                if(txt_email.text == "") {
                    txt_email.errorText = "Email can't be blank!"
                    txt_email.showError()
                } else {
                    txt_email.errorText = "Invalid email!"
                    txt_email.showError()
                }
            } else {
                txt_email.errorText = ""
                txt_email.hideError()
            }
        }
        if(textField == txt_Username) {
            if(txt_Username.text == "") {
                txt_Username.errorText = "Username can't be blank!"
                txt_Username.showError()
            } else {
                txt_Username.errorText = ""
                txt_Username.hideError()
            }
        }
    }
    
    //MARK : Action Accept Update Receive
    @IBAction func Action_UpdateReceive(_ sender: Any) {
        if Btn_AcceptUpdate.isSelected{
            Btn_AcceptUpdate.isSelected = false
        } else {
            Btn_AcceptUpdate.isSelected = true
        }
    }
    
    //MARK : Action SignUp
    @IBAction func Action_Signup(_ sender: Any) {
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
        if (!validateEmail(txt_email.text!)) {
            if(txt_email.text == "") {
                txt_email.errorText = "Email can't be blank!"
                txt_email.showError()
            } else {
                txt_email.errorText = "Invalid email!"
                txt_email.showError()
            }
        } else {
            txt_email.errorText = ""
            txt_email.hideError()
        }
        if(txt_Username.text == "") {
            txt_Username.errorText = "Username can't be blank!"
            txt_Username.showError()
        } else {
            txt_Username.errorText = ""
            txt_Username.hideError()
        }
        if txt_Password.errorText == "" {
            if txt_email.errorText == "" {
                if txt_Username.errorText == "" {
                    if(Btn_AcceptUpdate.isSelected) {
                        signUp()
                    }
                }
            }
        }
    }
    
    //MARK : SignUp
    func signUp() {
        if txt_email.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            ActivityView.showActivityIndicator()
            Auth.auth().createUser(withEmail: txt_email.text!, password: txt_Password.text!) { (user, error) in
                if error == nil {
                    self.DeleteItems()
                    self.GetCategory()
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.txt_Username.text!
                    changeRequest?.commitChanges { (error) in
                        if error == nil {
                            let userID = Auth.auth().currentUser?.uid
                            self.UpdateUserDetail(id : userID! as NSString, email: self.txt_email.text! as NSString, purchasedate: "NO", isPurchased: "Breakfast", isBlocked: "1", DailyTarget: 325, DailytargetIndex: 11, DailyPercentTarget: 1.3)
                            DispatchQueue.main.async {
                                UserDefaults.standard.set("Breakfast", forKey: "isPurchased")
                                UserDefaults.standard.set(325, forKey: "DailyTarget")
                                UserDefaults.standard.set(11, forKey: "DailyTargetIndex")
                                UserDefaults.standard.set(1.3, forKey: "DailypercentTarget")
                                UserDefaults.standard.set(self.txt_Username.text!, forKey: "UserName")
                                UserDefaults.standard.set("NO", forKey: "date")
                                UserDefaults.standard.set(self.txt_email.text!, forKey: "UserEmail")
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "DailyCalorieTargetViewController") as! DailyCalorieTargetViewController
                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                        } else {
                            ActivityView.hideActivityIndicator()
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    ActivityView.hideActivityIndicator()
                    if(error?.localizedDescription == "The email address is already in use by another account.") {
                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
                        VC.modalPresentationStyle = .overCurrentContext
                        self.present(VC, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    //MARK : Get Category
    @objc func GetCategory() {
        self.timer.invalidate() // just in case this button is tapped multiple times
        // start the timer
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
                            let categoryname = snap.childSnapshot(forPath: "categoryName")
                            let CategoryName = categoryname.value as! String
                            if self.artistList.contains(CategoryName) {
                            } else {
                                self.artistList.append(CategoryName)
                            }
                            for snap1 in snap0 {
                                if let postDict = snap1.value as? Dictionary<String, AnyObject> {
                                    let key = snap1.key
                                    if( key != "categoryName") {
                                        if let postDict1 = postDict["url_image"] as? Dictionary<String, AnyObject> {
                                            let artist : Model!
                                            artist = Model(category_name: CategoryName, subCategory_name: postDict["Product_title"] as? String, subCategory_id: key, category_id: mainkey, Calories: postDict["Calories"] as? String, Carbs: postDict["Carbs"] as? String , Cholesterol: postDict["Cholesterol"] as? String, Fat: postDict["Fat"] as? String, Fibers: postDict["Fibers"] as? String, Iron: postDict["Iron"] as? String, MonoUnsaturated: postDict["MonoUnsaturated"] as? String, PolyUnsaturated: postDict["PolyUnsaturated"] as? String, Potassium: postDict["Potassium"] as? String, Protein: postDict["Protein"] as? String, Saturated: postDict["Saturated"] as? String, Sodium: postDict["Sodium"] as? String, Sugars: postDict["Sugars"] as? String, Trans: postDict["Trans"] as? String, Vitamin_A: postDict["Vitamin_A"] as? String, Vitamin_C: postDict["Vitamin_C"] as? String, Url_image: postDict1["image_100"] as? String, calcium: postDict["Calcium"] as? String, ishidden: postDict["is_Hidden"] as? String, Ispremium: postDict["Is_Premium"] as? String, Img_0: postDict1["image_100"] as? String, Img_1: postDict1["image_125"] as? String, Img_2: postDict1["image_150"] as? String, Img_3: postDict1["image_175"] as? String, Img_4: postDict1["image_200"] as? String, Img_5: postDict1["image_225"] as? String, Img_6: postDict1["image_250"] as? String, Img_7: postDict1["image_275"] as? String, Img_8: postDict1["image_300"] as? String, Img_9: postDict1["image_325"] as? String, Img_10: postDict1["image_050"] as? String, Img_11: postDict1["image_075"] as? String, Desc_050: postDict1["desc_050"] as? String, Desc_075: postDict1["desc_075"] as? String, Desc_100: postDict1["desc_100"] as? String, Desc_125: postDict1["desc_125"] as? String, Desc_150: postDict1["desc_150"] as? String, Desc_175: postDict1["desc_175"] as? String, Desc_200: postDict1["desc_200"] as? String, Desc_225: postDict1["desc_225"] as? String, Desc_250: postDict1["desc_250"] as? String, Desc_275: postDict1["desc_275"] as? String, Desc_300: postDict1["desc_300"] as? String, Desc_325: postDict1["desc_325"] as? String, Alcohol_Sugars : postDict["Alcohol_Sugars"] as? String, Alcohol_Fats : postDict["Alcohol_Fats"] as? String )
                                            MessageManager.sharedInstance.insertRecord(model: artist)
                                        }
                                    }
                                } else {}
                            }
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadList"), object: nil)
                            ActivityView.hideActivityIndicator()
                        }
                    }
                }
            })
        }
    }
    
    //MARK : Action Default Back button
    @objc func leftBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK : Dismiss Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK : Update UserDetail
    func UpdateUserDetail(id: NSString, email: NSString, purchasedate: NSString, isPurchased: NSString,isBlocked: NSString , DailyTarget: Int, DailytargetIndex: Int, DailyPercentTarget: Float){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = Userlist.childByAutoId().key
        UserDefaults.standard.set(key, forKey: "id")
        //creating artist with the given values
        let artist = ["id":key,
                      "uid":id,
                      "email": email,
                      "purchasedate": "NO",
                      "isPurchased": isPurchased,
                      "isBlocked": isBlocked,
                      "DailyTarget": DailyTarget,
                      "DailyTargetIndex": DailytargetIndex,
                      "DailypercentTarget": DailyPercentTarget
            ] as [String : Any]
        //adding the artist inside the generated unique key
        Userlist.child(key).setValue(artist)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class UserModel {
    var id: String?
    var email: String?
    var isPurchased: String?
    var DailyTarget: Int?
    var DailyTargetIndex: Int?
    var DailypercentTarget: Float?
    var uid: String?
    init(uid: String?, email: String?, isPurchased: String?, DailyTarget:Int?, DailyTargetIndex:Int?, DailypercentTarget:Float?, id: String?){
        self.id = id
        self.uid = uid
        self.email = email
        self.isPurchased = isPurchased
        self.DailyTarget = DailyTarget
        self.DailyTargetIndex = DailyTargetIndex
        self.DailypercentTarget = DailypercentTarget
    }
}

