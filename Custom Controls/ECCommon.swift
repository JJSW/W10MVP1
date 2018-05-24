//
//  ECCommon.swift
//  EasyChartsSwift
//
//  Created by 宋永建 on 2017/9/19.
//  Copyright © 2017年 Global. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
var isInternetRechable = false
//MARK: - Colors
func RGBColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: (red/255.0), green: (green/255.0), blue: (blue/255.0), alpha: alpha)
}

let NeavyBlueColorWithAlpha : UIColor = RGBColor(26, green: 91, blue: 155,alpha: 0.8)
let NeavyBlueColor : UIColor = RGBColor(26, green: 91, blue: 155,alpha: 1.0)
func ECLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    
    #if DEBUG
        
        _ = (file as NSString).lastPathComponent
        
    #endif
}

let  ECScreenW =  UIScreen.main.bounds.size.width
let  ECScreenH =  UIScreen.main.bounds.size.height

extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random() % 256) / 255.0
            let green = CGFloat(arc4random() % 256) / 255.0
            let blue = CGFloat(arc4random() % 256) / 255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

//MARK : Set Navigation Bar
func setnavgationbar(title:NSString,backButton:Bool, _ controller:UIViewController,_ selector : Selector?, BackButtonTintColor : UIColor, TitleLabelColor : UIColor, MainBackgroundColor : UIColor) {
    controller.title = title as String
    controller.navigationItem.setHidesBackButton(true, animated:false);
    controller.navigationController!.navigationBar.shadowImage = UIImage(named :"ic_back")
    controller.navigationController!.navigationBar.setBackgroundImage(UIImage(named: "header"),for: .default)
    controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: TitleLabelColor]
    controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    controller.navigationController?.navigationBar.shadowImage = UIImage()
    controller.navigationController?.navigationBar.isTranslucent = true
    controller.navigationController?.view.backgroundColor = MainBackgroundColor
    controller.navigationController?.navigationBar.backgroundColor = MainBackgroundColor
    
    if backButton {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_back"), style: .plain, target: controller, action: selector)
        leftBarButton.tintColor = BackButtonTintColor
        controller.navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

// MARK: - Email Validation
func validateEmail(_ candidate: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z.._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
}

struct Model {
    var Category_name: String?
    var SubCategory_name: String?
    var SubCategory_id: String?
    var Category_id: String?
    var Calories: String?
    var Carbs: String?
    var Cholesterol: String?
    var Fat: String?
    var Fibers: String?
    var Iron: String?
    var MonoUnsaturated: String?
    var PolyUnsaturated: String?
    var Potassium: String?
    var Protein: String?
    var Saturated: String?
    var Sodium: String?
    var Sugars: String?
    var Trans: String?
    var Vitamin_A: String?
    var Vitamin_C: String?
    var Calcium: String?
    var url_image: String?
    var isHidden: String?
    var IsPremium: String?
    var Alcohol_sugars: String?
    var Alcohol_fats: String?
    var img_0: String?
    var img_1: String?
    var img_2: String?
    var img_3: String?
    var img_4: String?
    var img_5: String?
    var img_6: String?
    var img_7: String?
    var img_8: String?
    var img_9: String?
    var img_10: String?
    var img_11: String?
    var desc_050: String?
    var desc_075: String?
    var desc_100: String?
    var desc_125: String?
    var desc_150: String?
    var desc_175: String?
    var desc_200: String?
    var desc_225: String?
    var desc_250: String?
    var desc_275: String?
    var desc_300: String?
    var desc_325: String?
    init() {
    }
    init(category_name : String?, subCategory_name : String?, subCategory_id: String?, category_id: String?, Calories: String?, Carbs: String? , Cholesterol: String?, Fat: String?, Fibers: String?, Iron: String?, MonoUnsaturated: String?, PolyUnsaturated: String?, Potassium: String?, Protein: String?, Saturated: String?, Sodium: String?, Sugars: String?, Trans: String?, Vitamin_A: String?, Vitamin_C: String?, Url_image : String?, calcium : String?, ishidden : String?, Ispremium : String?, Img_0 : String?, Img_1 : String?, Img_2 : String?, Img_3 : String?, Img_4 : String?, Img_5 : String?, Img_6 : String?, Img_7 : String?, Img_8 : String?, Img_9 : String?, Img_10 : String?, Img_11 : String?, Desc_050 : String?, Desc_075 : String?, Desc_100 : String?, Desc_125 : String?, Desc_150 : String?, Desc_175 : String?, Desc_200 : String?, Desc_225 : String?, Desc_250 : String?, Desc_275 : String?, Desc_300 : String?, Desc_325 : String?, Alcohol_Sugars : String?, Alcohol_Fats : String?){
        self.Category_name = category_name
        self.SubCategory_name = subCategory_name
        self.SubCategory_id = subCategory_id
        self.Category_id = category_id
        self.Carbs = Carbs
        self.Calories = Calories
        self.Cholesterol = Cholesterol
        self.Fat = Fat
        self.Fibers = Fibers
        self.Iron = Iron
        self.MonoUnsaturated = MonoUnsaturated
        self.PolyUnsaturated = PolyUnsaturated
        self.Potassium = Potassium
        self.Protein = Protein
        self.Saturated = Saturated
        self.Sodium = Sodium
        self.Sugars = Sugars
        self.Trans = Trans
        self.Vitamin_A = Vitamin_A
        self.Vitamin_C = Vitamin_C
        self.url_image = Url_image
        self.Calcium = calcium
        self.isHidden = ishidden
        self.IsPremium = Ispremium
        self.Alcohol_sugars = Alcohol_Sugars
        self.Alcohol_fats = Alcohol_Fats
        self.img_0 = Img_0
        self.img_1 = Img_1
        self.img_2 = Img_2
        self.img_3 = Img_3
        self.img_4 = Img_4
        self.img_5 = Img_5
        self.img_6 = Img_6
        self.img_7 = Img_7
        self.img_8 = Img_8
        self.img_9 = Img_9
        self.img_10 = Img_10
        self.img_11 = Img_11
        self.desc_050 = Desc_050
        self.desc_075 = Desc_075
        self.desc_100 = Desc_100
        self.desc_125 = Desc_125
        self.desc_150 = Desc_150
        self.desc_175 = Desc_175
        self.desc_200 = Desc_200
        self.desc_225 = Desc_225
        self.desc_250 = Desc_250
        self.desc_275 = Desc_275
        self.desc_300 = Desc_300
        self.desc_325 = Desc_325
    }
}


//let imageCache = NSCache<AnyObject, AnyObject>()
//class ImageLoader: UIImageView {
//
//    var imageURL: URL?
//
//    let activityIndicator = UIActivityIndicatorView()
//
//    func loadImageWithUrl(_ url: URL?) {
//
//        // setup activityIndicator...
//        activityIndicator.color = UIColor.darkGray
//        activityIndicator.backgroundColor = .clear
//        addSubview(activityIndicator)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        if url != nil {
//            imageURL = url
//            let str = url!.absoluteString
//            activityIndicator.startAnimating()
//            // retrieves image if already available in cache
//            if let imageFromCache = imageCache.object(forKey: str as AnyObject) as? UIImage {
//                self.image = imageFromCache
//                activityIndicator.stopAnimating()
//                return
//            }
//
//            DispatchQueue.main.async {
//                // image does not available in cache.. so retrieving it from url...
//                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                    if error != nil {
//                        DispatchQueue.main.async {
//                            self.activityIndicator.stopAnimating()
//                        }
//                        return
//                    }
//
//                    DispatchQueue.main.async {
//                        if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
//                            if self.imageURL == url {
//                                self.image = imageToCache
//                            }
//                            imageCache.setObject(imageToCache, forKey: str as AnyObject)
//                        }
//                        self.activityIndicator.stopAnimating()
//                    }
//                }).resume()
//            }
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }
//}

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
class ImageLoader: UIImageView {
    
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    func loadImageWithUrl(_ url: String?) {
        
        // setup activityIndicator...
        activityIndicator.color = UIColor.darkGray
        activityIndicator.backgroundColor = .clear
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        if url != nil && url != ""  {
            imageURL = URL(string: url!)
            activityIndicator.startAnimating()
            // retrieves image if already available in cache
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.image = imageFromCache
                activityIndicator.stopAnimating()
                return
            }
            
            request(imageURL!).response(completionHandler: { (response) in
                guard let imageData = response.data else {
                    return
                }
                DispatchQueue.main.async {
                    let unwrappedData = imageData
                    if let imageToCache = UIImage(data: unwrappedData) {
                        if self.imageURL?.absoluteString == url {
                            self.image = imageToCache
                        }
                        imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    }
                    self.activityIndicator.stopAnimating()
                }
            })
            
            
            /*DispatchQueue.global().async {
             URLSession.shared.dataTask(with: self.imageURL!, completionHandler: { (data, response, error) in
             if error != nil {
             print(error as Any)
             DispatchQueue.main.async {
             if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
             self.image = imageToCache
             imageCache.setObject(imageToCache, forKey: url as AnyObject)
             }
             self.activityIndicator.stopAnimating()
             }
             return
             }
             
             DispatchQueue.main.async {
             if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
             //                            if self.imageURL == url {
             self.image = imageToCache
             //                            }
             imageCache.setObject(imageToCache, forKey: url as AnyObject)
             }
             self.activityIndicator.stopAnimating()
             }
             }).resume()
             }*/
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}

func DropShadowOnView(view : UIView) {
    view.layer.cornerRadius = 0.0
    view.layer.borderWidth = 0
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.masksToBounds = true;
    
}
