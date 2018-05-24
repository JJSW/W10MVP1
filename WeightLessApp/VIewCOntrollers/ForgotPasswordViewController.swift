//
//  ForgotPasswordViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var txt_RegisteredEmail: ACFloatingTextfield!
    @IBOutlet var Btn_Submit: CustomButton!
    @IBOutlet var Btn_EmailNotRecognized: UIButton!
    var type = 1// 1: Forgot Password, 2: Change Password
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        self.txt_RegisteredEmail.delegate = self
        if(type == 1) {
            // 1: Forgot Password
            UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
            setnavgationbar(title: "Forgot Password",backButton: true,self,#selector(leftBarButtonTapped), BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
            Btn_EmailNotRecognized.isHidden = true
        } else {
            //2: Change Password
            UIApplication.shared.statusBarView?.backgroundColor = NeavyBlueColor
            setnavgationbar(title: "Change Password", backButton: true, self, #selector(leftBarButtonTapped),BackButtonTintColor: UIColor.white, TitleLabelColor: UIColor.white, MainBackgroundColor: NeavyBlueColor )
            Btn_EmailNotRecognized.isHidden = true
        }
        super.viewDidLoad()
        //MARK : touch OutSide the textfield
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.MainView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    //MARK : Textfield Delegate Methods
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(textField == txt_RegisteredEmail) {
            if (!validateEmail(txt_RegisteredEmail.text!)) {
                if(txt_RegisteredEmail.text == "") {
                    txt_RegisteredEmail.errorText = "Email can't be blank!"
                    txt_RegisteredEmail.showError()
                } else {
                    txt_RegisteredEmail.errorText = "Invalid email!"
                    txt_RegisteredEmail.showError()
                }
            } else {
                txt_RegisteredEmail.errorText = ""
                txt_RegisteredEmail.hideError()
            }
        }
    }
    
    //MARK : Action Reset Password From Firebase
    func ResetPasswordAction() {
        if self.txt_RegisteredEmail.text == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            ActivityView.showActivityIndicator()
            Auth.auth().sendPasswordReset(withEmail: self.txt_RegisteredEmail.text!, completion: { (error) in
                var title = ""
                if error != nil {
                    ActivityView.hideActivityIndicator()
                    let alertController = UIAlertController(title: title, message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    title = "Error!"
                } else {
                    ActivityView.hideActivityIndicator()
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "EmailSentSuccesfullyViewController") as! EmailSentSuccesfullyViewController
                    self.navigationController?.pushViewController(VC, animated: true)
                }
            })
        }
    }
    
    //MARK : Action Email Not Recognized
    @IBAction func Action_EmailNotRecognized(_ sender: Any) {
    }
    
    //MARK : Action Submit
    @IBAction func Action_Submit(_ sender: Any) {
        self.view.endEditing(true)
        if (!validateEmail(txt_RegisteredEmail.text!)) {
            if(txt_RegisteredEmail.text == "") {
                txt_RegisteredEmail.errorText = "Email can't be blank!"
                txt_RegisteredEmail.showError()
            } else {
                txt_RegisteredEmail.errorText = "Invalid email!"
                txt_RegisteredEmail.showError()
            }
        } else {
            txt_RegisteredEmail.errorText = ""
            txt_RegisteredEmail.hideError()
        }
        if txt_RegisteredEmail.errorText == "" {
            ResetPasswordAction()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
