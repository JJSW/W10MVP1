//
//  DailyCalorieTargetViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 01/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import Firebase

class DailyCalorieTargetViewController: UIViewController, iCarouselDataSource, iCarouselDelegate  {
    
    var type = 0 // 0 : From Main, 1: From Setting
    var items: [Int] = [500,750,1000,1250,1500,1750,2000,2250,2500,2750,3000,3250]
    var itemsPerDay: [Int] = [50,75,100,125,150,175,200,225,250,275,300,325]
    var itemsCountDay: [Float] = [0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.1,1.2,1.3] 
    @IBOutlet var lbl_DailyCalorie: UILabel!
    @IBOutlet var Btn_GetStarted: CustomButton!
    @IBOutlet var carousell: iCarousel!
    @IBOutlet var btn_NeedHelp: UIButton!
    var itemsPerDayCount = 0
    var itemsCountDayCount = Float(0.0)
    var DailyTargetIndexCount = 0
    var refArtists: DatabaseReference!
    var artistList : [String] = []
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        carousell.delegate = self
        carousell.dataSource = self
        carousell.currentItemIndex = UserDefaults.standard.integer(forKey: "DailyTargetIndex")
        carousell.type = .rotary
        UIApplication.shared.statusBarView?.backgroundColor = NeavyBlueColor
        if type == 0 {
            // 0 : From Main
            setnavgationbar(title: "Daily Calorie Targets", backButton: false, self, nil, BackButtonTintColor: NeavyBlueColorWithAlpha, TitleLabelColor: UIColor.white, MainBackgroundColor: NeavyBlueColor)
            Btn_GetStarted.setTitle("Get Started", for: .normal)
        } else {
            //1: From Setting
            setnavgationbar(title: "Daily Calorie Targets", backButton: true, self, #selector(leftBarButtonTapped),BackButtonTintColor: UIColor.white, TitleLabelColor: UIColor.white, MainBackgroundColor: NeavyBlueColor )
            Btn_GetStarted.setTitle("Update", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK : Make Label Scrollable By used Of iCarousel
    //MARk : iCarousel Delegate Methods
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: carousell.frame.size.height + 100, height: carousell.frame.size.height))
            itemView.image = UIImage(named: "")
            itemView.contentMode = .center
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .white
            label.textAlignment = .center
            label.font = label.font.withSize(15)
            label.text = "\(items[index])"
            if (index == carousell.currentItemIndex) {
                label.font = label.font.withSize(40)
                if type == 0 {
                    UserDefaults.standard.set(itemsPerDay[index], forKey: "DailyTarget")
                    UserDefaults.standard.set(index, forKey: "DailyTargetIndex")
                    UserDefaults.standard.set(itemsCountDay[index], forKey: "DailypercentTarget")
                    itemsPerDayCount = itemsPerDay[index]
                    DailyTargetIndexCount = index
                    itemsCountDayCount = Float(itemsCountDay[index])
                    self.updateArtist()
                }
                itemsPerDayCount = itemsPerDay[index]
                DailyTargetIndexCount = index
                itemsCountDayCount = Float(itemsCountDay[index])
                lbl_DailyCalorie.text = "\(itemsPerDay[index]) Weight"
            }
            label.textColor = .black 
            label.tag = 1
            itemView.addSubview(label)
        }
        return itemView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.0
        }
        return value
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        carousel.reloadData()
    }
    
    //MARK : Action Get Started
    @IBAction func Action_GetStarted(_ sender: Any) {
        if type == 0 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
            self.navigationController?.pushViewController(VC, animated: true)
        } else {
            UserDefaults.standard.set(itemsPerDayCount, forKey: "DailyTarget")
            UserDefaults.standard.set(DailyTargetIndexCount, forKey: "DailyTargetIndex")
            UserDefaults.standard.set(itemsCountDayCount, forKey: "DailypercentTarget")
            self.updateArtist()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK : Action Need Help
    @IBAction func Action_NeedHelp(_ sender: Any) {
        guard let url = URL(string: "https://blog.weightless10.com/daily-calorie-target/") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func updateArtist() {
        //creating artist with the new given values
        let userID = Auth.auth().currentUser?.uid
        let artist = ["id":UserDefaults.standard.string(forKey: "id") as Any,
                      "uid":userID!,
                      "email": UserDefaults.standard.string(forKey: "UserEmail") as Any,
                      "purchasedate": UserDefaults.standard.string(forKey: "date") as Any,
                      "isPurchased": UserDefaults.standard.string(forKey: "isPurchased") as Any,
                      "isBlocked": "1",
                      "DailyTarget": itemsPerDayCount,
                      "DailyTargetIndex": DailyTargetIndexCount,
                      "DailypercentTarget": itemsCountDayCount
            ] as [String : Any]
        //updating the artist using the key of the artist
        if(UserDefaults.standard.string(forKey: "id") != nil) {  Database.database().reference().child("UserList").child(UserDefaults.standard.string(forKey: "id")!).setValue(artist)
        }
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
