//
//  AppDelegate.swift
//  WeightLessApp
//
//  Created by Krupa Detroja on 31/01/18.
//  Copyright © 2018 IBL Infotech. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        checkInternetConnection()
        UserDefaults.standard.set("1", forKey: "CHECKINTERNET")
        Reach().monitorReachabilityChanges()
        Userlist = Database.database().reference().child("UserList");
        if (UserDefaults.standard.string(forKey: "UserEmail") != nil) {
            if (UserDefaults.standard.string(forKey: "UserEmail") != "") {
                self.DeleteItems()
                self.GetCategory()
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "CollectionReload"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (UserDefaults.standard.string(forKey: "UserEmail") != nil) {
            if (UserDefaults.standard.string(forKey: "UserEmail") != "") {
                self.DeleteItems()
                self.GetCategory()
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "CollectionReload"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
            }
        }
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if (UserDefaults.standard.string(forKey: "UserEmail") != nil) {
            if (UserDefaults.standard.string(forKey: "UserEmail") != "") {
                self.DeleteItems()
                self.GetCategory()
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "CollectionReload"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(Reload), name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer1"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartTimer"), object: nil)
            }
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setPreffredInternetConnection(status : Bool){
        isInternetRechable = status
    }
    
    func prefferedInternetConnection() -> Bool{
        return isInternetRechable
    }
    
    @objc func Reload() { }
    
    //MARK : Check Internet Connection
    func checkInternetConnection() {
        let  internetReachable = Reachability(hostname: "www.google.com")
        internetReachable?.reachableBlock = { rech in
            self.setPreffredInternetConnection(status: true)
        }
        internetReachable?.unreachableBlock = { rech in
            self.setPreffredInternetConnection(status: false)
        }
        internetReachable?.startNotifier()
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
            })
        }
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
}

