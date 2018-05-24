//
//  ItemViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 06/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tbl: UITableView!
    @IBOutlet var lbl_itemName: UILabel!
    @IBOutlet var img_item: ImageLoader!
    @IBOutlet var lbl_Calorie: UILabel!
    @IBOutlet var lbl_Carbs_Percentage: UILabel!
    @IBOutlet var lbl_Carbs_gram: UILabel!
    @IBOutlet var lbl_Fat_Percentage: UILabel!
    @IBOutlet var lbl_Fat_gram: UILabel!
    @IBOutlet var lbl_Protein_Percentage: UILabel!
    @IBOutlet var lbl_Protein_gram: UILabel!
    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet var HEADERView: UIView!
    var Categories: Model!
    var SubCategoryid : String = ""
    var itemname : String = ""
    var keyArray : [String] = []
    var ValueArray : [String] = []
    var DisplayArray : [String] = []
    @IBOutlet var ChartView: CustomView!
    var timer = Timer()
    //MARK : For Chart
    var f : CGFloat = 0.0
    var g : CGFloat = 0.0
    var h : CGFloat = 0.0
    var i : CGFloat = 0.0
    var j : CGFloat = 0.0
    var fInt: CGFloat = 0.0
    var gInt: CGFloat = 0.0
    var hInt: CGFloat = 0.0
    var PieChartView2 : ECPieChartView!
    var percentList : [CGFloat] = []
    var colorList : [UIColor] = [UIColor(red: (215.0)/255.0 , green: (42.0)/255.0, blue: (73.0)/255.0, alpha: 1.0), UIColor(red: (239.0)/255.0, green: (187.0)/255.0, blue: (51.0)/255.0, alpha: 1.0), UIColor(red: (70.0)/255.0, green: (0.0)/255.0, blue: (104.0)/255.0, alpha: 1.0)]
    var arcTextList : [NSString] = ["","",""]
    @IBOutlet var lbl_nointernet: UIImageView!
    
    //MARK : viewDidLoad
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(GetCategory), name: NSNotification.Name(rawValue: "ReloadList"), object: nil)
        Categories = MessageManager.sharedInstance.LoadItem(SubCategory_id: SubCategoryid)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        setnavgationbar(title: "",backButton: true,self,#selector(leftBarButtonTapped), BackButtonTintColor:NeavyBlueColorWithAlpha, TitleLabelColor:  NeavyBlueColor, MainBackgroundColor: UIColor.white)
        super.viewDidLoad()
        if(isInternetRechable) {
            lbl_nointernet.isHidden = true
            img_item.isHidden = false
            var url = ""
            if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 0) {
                url = Categories.img_10! as String
                lbl_Description.text = Categories.desc_050! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 1) {
                url = Categories.img_11! as String
                lbl_Description.text = Categories.desc_075! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 2) {
                url = Categories.img_0! as String
                lbl_Description.text = Categories.desc_100! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 3) {
                url = Categories.img_1! as String
                lbl_Description.text = Categories.desc_125! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 4) {
                url = Categories.img_2! as String
                lbl_Description.text = Categories.desc_150! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 5) {
                url = Categories.img_3! as String
                lbl_Description.text = Categories.desc_175! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 6) {
                url = Categories.img_4! as String
                lbl_Description.text = Categories.desc_200! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 7) {
                url = Categories.img_5! as String
                lbl_Description.text = Categories.desc_225! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 8) {
                url = Categories.img_6! as String
                lbl_Description.text = Categories.desc_250! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 9) {
                url = Categories.img_7! as String
                lbl_Description.text = Categories.desc_275! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 10) {
                url = Categories.img_8! as String
                lbl_Description.text = Categories.desc_300! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 11) {
                url = Categories.img_9! as String
                lbl_Description.text = Categories.desc_325! as String
            } else {
                url = Categories.url_image! as String
                lbl_Description.text = ""
            }
            if(lbl_Description.text == "") {
                HEADERView.frame.size.height = self.view.bounds.size.width + 180
            } else {
                HEADERView.frame.size.height = self.view.bounds.size.width + 180 + 100
            }
            self.img_item.loadImageWithUrl(url)
            DropShadowOnView(view: img_item)
        } else {
            img_item.isHidden = false
            img_item.image = UIImage(named : "")
            img_item.backgroundColor = UIColor.lightGray
            lbl_nointernet.isHidden = false
        }
        timer.invalidate() // just in case this button is tapped multiple times
        // start the timer
        i = (CGFloat(UserDefaults.standard.float(forKey: "DailypercentTarget")))
        j = CGFloat((Categories.Calories! as NSString).floatValue)
        self.lbl_Calorie.text = "\(String(format: "%.1f", (i*j))) g is \((UserDefaults.standard.integer(forKey: "DailyTarget"))) Calories"
        self.lbl_itemName.text = Categories.SubCategory_name!
        j = CGFloat((Categories.Carbs! as NSString).floatValue)
        self.lbl_Carbs_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Carbs_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        fInt = i*j
        j = CGFloat((Categories.Fat! as NSString).floatValue)
        self.lbl_Fat_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Fat_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        gInt = i*j
        j = CGFloat((Categories.Protein! as NSString).floatValue)
        self.lbl_Protein_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Protein_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        hInt = i*j
        if (CGFloat(fInt + gInt + hInt) == 0.0) {
            f = 33.3
            g = 33.3
            h = 33.3
        } else {
            f = (CGFloat(fInt/(fInt + gInt + hInt)))
            self.lbl_Carbs_Percentage.text = "\(String(format: "%.1f", (f*100)))%"
            g = (CGFloat((gInt)/(fInt + gInt + hInt)))
            self.lbl_Fat_Percentage.text = "\(String(format: "%.1f", (g*100)))%"
            h = (CGFloat((hInt)/(fInt + gInt + hInt)))
        }
        self.lbl_Protein_Percentage.text = "\(String(format: "%.1f", (h*100)))%"
        keyArray = ["Calories","Protein (g)","Carbs (g)","Fiber (g)","Sugars (g)","Alcohol Sugars (g)","Fat (g)","Saturated (g)","Monosaturated (g)","Polyunsaturated (g)","Trans (g)","Cholestrol (mg)","Alcohol Fats (g)","Vitamin A (IU)","Vitamin C (mg)","Calcium (mg)","Iron (mg)","Potassium (mg)","Sodium (mg)"]
        
        if(Categories.Calcium == nil) {
            Categories.Calcium = "0"
        }
        
        ValueArray = [
            "\(String(format: "%.1f",(i*CGFloat((Categories.Calories! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Protein! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Carbs! as NSString).floatValue)))) ","\(String(format: "%.1f", (i*CGFloat((Categories.Fibers! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Sugars! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Alcohol_sugars! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Fat! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Saturated! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.MonoUnsaturated! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.PolyUnsaturated! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Trans! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Cholesterol! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Alcohol_fats! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Vitamin_A! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Vitamin_C! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Calcium! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Iron! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Potassium! as NSString).floatValue)))) ",
            "\(String(format: "%.1f", (i*CGFloat((Categories.Sodium! as NSString).floatValue)))) "
        ]
        
        self.tbl.delegate = self
        self.tbl.dataSource = self
        let nib = UINib(nibName: "ItemDetailTableViewCell", bundle: nil)
        self.tbl.register(nib, forCellReuseIdentifier: "ItemDetailTableViewCell")
        percentList = [f, g, h]
        setupPieChartView()
        // Do any additional setup after loading the view.
    }
    
    //MARK : Get Category
    @objc func GetCategory() {
        Categories = MessageManager.sharedInstance.LoadItem(SubCategory_id: SubCategoryid)
        if(Categories.Category_name == nil) {
        } else {
        if(isInternetRechable) {
            lbl_nointernet.isHidden = true
            img_item.isHidden = false
            var url = ""
            if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 0) {
                url = Categories.img_10! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 1) {
                url = Categories.img_11! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 2) {
                url = Categories.img_0! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 3) {
                url = Categories.img_1! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 4) {
                url = Categories.img_2! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 5) {
                url = Categories.img_3! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 6) {
                url = Categories.img_4! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 7) {
                url = Categories.img_5! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 8) {
                url = Categories.img_6! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 9) {
                url = Categories.img_7! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 10) {
                url = Categories.img_8! as String
            } else if(UserDefaults.standard.integer(forKey: "DailyTargetIndex") == 11) {
                if(Categories.img_9! as String != nil) {
                url = Categories.img_9! as String
                } else {
                    url = Categories.url_image! as String
                }
            } else {
                url = Categories.url_image! as String
            }
            self.img_item.loadImageWithUrl(url)
            DropShadowOnView(view: img_item)
        } else {
            img_item.isHidden = false
            img_item.image = UIImage(named : "")
            img_item.backgroundColor = UIColor.lightGray
            lbl_nointernet.isHidden = false
        }
        // start the timer
        i = (CGFloat(UserDefaults.standard.float(forKey: "DailypercentTarget")))
        j = CGFloat((Categories.Calories! as NSString).floatValue)
        self.lbl_Calorie.text = "\(String(format: "%.1f", (i*j))) g is \((UserDefaults.standard.integer(forKey: "DailyTarget"))) Calories"
        self.lbl_itemName.text = Categories.SubCategory_name!
        j = CGFloat((Categories.Carbs! as NSString).floatValue)
        self.lbl_Carbs_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Carbs_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        fInt = i*j
        j = CGFloat((Categories.Fat! as NSString).floatValue)
        self.lbl_Fat_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Fat_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        gInt = i*j
        j = CGFloat((Categories.Protein! as NSString).floatValue)
        self.lbl_Protein_gram.text = "\(String(format: "%.1f", (i*j))) g"
        self.lbl_Protein_Percentage.text = "\(String(format: "%.1f", ((i*j)/100.0)))%"
        hInt = i*j
        if (CGFloat(fInt + gInt + hInt) == 0.0) {
            f = 33.3
            g = 33.3
            h = 33.3
        } else {
            f = (CGFloat(fInt/(fInt + gInt + hInt)))
            self.lbl_Carbs_Percentage.text = "\(String(format: "%.1f", (f*100)))%"
            g = (CGFloat((gInt)/(fInt + gInt + hInt)))
            self.lbl_Fat_Percentage.text = "\(String(format: "%.1f", (g*100)))%"
            h = (CGFloat((hInt)/(fInt + gInt + hInt)))
        }
        self.lbl_Protein_Percentage.text = "\(String(format: "%.1f", (h*100)))%"
            keyArray = ["Calories","Protein (g)","Carbs (g)","Fiber (g)","Sugars (g)","Alcohol Sugars (g)","Fat (g)","Saturated (g)","Monosaturated (g)","Polyunsaturated (g)","Trans (g)","Cholestrol (mg)","Alcohol Fats (g)","Vitamin A (IU)","Vitamin C (mg)","Calcium (mg)","Iron (mg)","Potassium (mg)","Sodium (mg)"]
            
            if(Categories.Calcium == nil) {
                Categories.Calcium = "0"
            }
            
            ValueArray = [
                "\(String(format: "%.1f",(i*CGFloat((Categories.Calories! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Protein! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Carbs! as NSString).floatValue)))) ","\(String(format: "%.1f", (i*CGFloat((Categories.Fibers! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Sugars! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Alcohol_sugars! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Fat! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Saturated! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.MonoUnsaturated! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.PolyUnsaturated! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Trans! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Cholesterol! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Alcohol_fats! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Vitamin_A! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Vitamin_C! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Calcium! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Iron! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Potassium! as NSString).floatValue)))) ",
                "\(String(format: "%.1f", (i*CGFloat((Categories.Sodium! as NSString).floatValue)))) "
            ]
            
        self.tbl.delegate = self
        self.tbl.dataSource = self
        let nib = UINib(nibName: "ItemDetailTableViewCell", bundle: nil)
        self.tbl.register(nib, forCellReuseIdentifier: "ItemDetailTableViewCell")
        percentList = [f, g, h]
        setupPieChartView()
            self.tbl.reloadData()
    }
        
    }
    
    //MARK : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
    }
    
    //MARK : SetUp Chart
    func setupPieChartView() {
        self.ChartView.backgroundColor = UIColor.white
        PieChartView2  = ECPieChartView.init(frame: CGRect(x: 0, y: 0, width: self.ChartView.frame.width, height: self.ChartView.frame.height))
        self.ChartView.addSubview(PieChartView2)
        PieChartView2.drawPieChart(percentList: self.percentList,
                                   colorList: self.colorList,
                                   arcTextList: self.arcTextList)
    }
    
    //MARK : TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDetailTableViewCell", for: indexPath) as! ItemDetailTableViewCell
        cell.selectionStyle = .none
        cell.lbl_Key.text = keyArray[indexPath.row]
        cell.lbl_Value.text = ValueArray[indexPath.row]
        cell.lbl_Value.textColor  = UIColor.black
        cell.lbl_Key.textColor  = UIColor.black
        if(indexPath.row == 3) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 4) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 5) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 7) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 8) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 9) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 10) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 11) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        if(indexPath.row == 12) {
            cell.lbl_Value.textColor  = UIColor.lightGray
            cell.lbl_Key.textColor  = UIColor.lightGray
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
