//
//  MessageManager.swift
//  GTeam
//
//  Created by IBL Infotech on 07/10/17.
//  Copyright © 2017 IBL Infotech. All rights reserved.
//

import UIKit
import SQLite3

private var sharedInstance: MessageManager? = nil
class MessageManager: NSObject {
    var db: OpaquePointer?
    var statement: OpaquePointer?
    static let sharedInstance = MessageManager()
    
    private override init() {
        super.init()
        OpenDataBase()
        createSubCategoryValueTable()
        createSubCategoryTable()
    }
    
    func OpenDataBase() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("WeightlessAppDB.sqlite")
        // open database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
//            print("error opening database")
        }
    }
    
    func createSubCategoryValueTable() {
        let createTableQuery =  "CREATE TABLE if not exists `SubCategoryValue` (    `Category_name`    TEXT,    `SubCategory_name`    TEXT,    `Calcium`    TEXT,    `Weight`   TEXT,    `Carbs`    TEXT,    `Cholesterol`    TEXT,    `Fat`    TEXT,    `Fibers`    TEXT,    `Iron`    TEXT,    `MonoUnsaturated`    TEXT,    `PolyUnsaturated`    TEXT,    `Potassium`    TEXT,    `Protein`    TEXT,    `Saturated`    TEXT,    `Sodium`    TEXT,    `Sugars`    TEXT,    `Trans`    TEXT,    `Vitamin_A`    TEXT,    `Vitamin_C`    TEXT,    `SubCategory_id`    TEXT UNIQUE,    `SubCategory_image_url`    TEXT,    `Category_id`    TEXT, 'is_Hidden' TEXT, 'IsPremium' TEXT, 'img_0' TEXT, 'img_1' TEXT, 'img_2' TEXT, 'img_3' TEXT, 'img_4' TEXT, 'img_5' TEXT, 'img_6' TEXT, 'img_7' TEXT, 'img_8' TEXT, 'img_9' TEXT, 'img_10' TEXT, 'img_11' TEXT, 'desc_050' TEXT, 'desc_075' TEXT, 'desc_100' TEXT, 'desc_125' TEXT, 'desc_150' TEXT, 'desc_175' TEXT, 'desc_200' TEXT, 'desc_225' TEXT, 'desc_250' TEXT, 'desc_275' TEXT, 'desc_300' TEXT, 'desc_325' TEXT,    `Alcohol_Sugars`    TEXT,    `Alcohol_Fats`    TEXT)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating table: \(errmsg)")
        }
    }
    
    func createSubCategoryTable() {
        let createTableQuery =  "CREATE TABLE if not exists `SubCategory` (    `Category_id`    TEXT,    `SubCategory_name`    TEXT,    `Category_name`    TEXT,    `SubCategory_id`    TEXT UNIQUE)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error creating table: \(errmsg)")
        }
    }
    
    func UpdateRecord(model : Model) {
        var statement: OpaquePointer?
        let query = "UPDATE SubCategoryValue  SET Category_name = \'\(model.Category_name!)' , SubCategory_name = \'\(model.SubCategory_name!)' , Calcium = \'\(model.Calcium!)' , Weight = \'\(model.Calories!)' , Carbs = \'\(model.Carbs!)' , Cholesterol = \'\(model.Cholesterol!)' , Fat = \'\(model.Fat!)' , Fibers = \'\(model.Fibers!)' , Iron = \'\(model.Iron!)' , MonoUnsaturated = \'\(model.MonoUnsaturated!)' , PolyUnsaturated = \'\(model.PolyUnsaturated!)' , Potassium = \'\(model.Potassium!)' , Protein = \'\(model.Protein!)' , Saturated = \'\(model.Saturated!)' , Sodium = \'\(model.Sodium!)' , Sugars = \'\(model.Sugars!)' , Trans = \'\(model.Trans!)' , Vitamin_A = \'\(model.Vitamin_A!)' , Vitamin_C = \'\(model.Vitamin_C!)' , SubCategory_id = \'\(model.SubCategory_id!)' , SubCategory_image_url = \'\(model.url_image!)' , Category_id = \'\(model.Category_id!)' , is_Hidden = \'\(model.isHidden!)', IsPremium = \'\(model.IsPremium!)' , img_0 = \'\(model.img_0!)' , img_1 = \'\(model.img_1!)' , img_2 = \'\(model.img_2!)' , img_3 = \'\(model.img_3!)' , img_4 = \'\(model.img_4!)' , img_5 = \'\(model.img_5!)' , img_6 = \'\(model.img_6!)' , img_7 = \'\(model.img_7!)' , img_8 = \'\(model.img_8!)' , img_9 = \'\(model.img_9!)', img_10 = \'\(model.img_10!)' , img_11 = \'\(model.img_11!)', desc_050 = \'\(model.desc_050!)', desc_075 = \'\(model.desc_075!)', desc_100 = \'\(model.desc_100!)', desc_125 = \'\(model.desc_125!)', desc_150 = \'\(model.desc_150!)', desc_175 = \'\(model.desc_175!)', desc_200 = \'\(model.desc_200!)', desc_225 = \'\(model.desc_225!)', desc_250 = \'\(model.desc_250!)', desc_275 = \'\(model.desc_275!)', desc_300 = \'\(model.desc_300!)', desc_325 = \'\(model.desc_325!)', Alcohol_Sugars = \'\(model.Alcohol_sugars!)', Alcohol_Fats = \'\(model.Alcohol_fats!)' WHERE SubCategory_id = \'\(model.SubCategory_id!)'"
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing insert: \(errmsg)")
        }
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure inserting foo: \(errmsg)")
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error finalizing prepared statement: \(errmsg)")
        }
    }
    
    func insertRecord(model : Model) {
        if(model.SubCategory_name != nil) {
            var statement: OpaquePointer?
            let query = "insert into SubCategoryValue ( `Category_name`,    `SubCategory_name`,    `Calcium`,    `Weight`,    `Carbs` ,    `Cholesterol`,    `Fat`    ,    `Fibers`    ,    `Iron`    ,    `MonoUnsaturated`    ,    `PolyUnsaturated`    ,    `Potassium`    ,    `Protein`    ,    `Saturated`    ,    `Sodium`    ,    `Sugars`    ,    `Trans`    ,    `Vitamin_A`    ,    `Vitamin_C`    ,    `SubCategory_id`     ,    `SubCategory_image_url`    ,    `Category_id`,    `is_Hidden`,    `IsPremium`,    `img_0`,    `img_1`,    `img_2`,    `img_3`,    `img_4`,    `img_5`,    `img_6`,    `img_7`,    `img_8`,    `img_9`,    `img_10`,    `img_11` ,    `desc_050` ,    `desc_075` ,    `desc_100` ,    `desc_125` ,    `desc_150` ,    `desc_175` ,    `desc_200` ,    `desc_225` ,    `desc_250` ,    `desc_275` ,    `desc_300` ,    `desc_325` ,    `Alcohol_Sugars`,    `Alcohol_Fats` ) VALUES ('\(model.Category_name!)', '\(model.SubCategory_name!)','\(model.Calcium!)', '\(model.Calories!)','\(model.Carbs!)', '\(model.Cholesterol!)','\(model.Fat!)', '\(model.Fibers!)','\(model.Iron!)', '\(model.MonoUnsaturated!)','\(model.PolyUnsaturated!)', '\(model.Potassium!)','\(model.Protein!)', '\(model.Saturated!)','\(model.Sodium!)', '\(model.Sugars!)','\(model.Trans!)', '\(model.Vitamin_A!)','\(model.Vitamin_C!)','\(model.SubCategory_id!)', '\(model.url_image!)', '\(model.Category_id!)', '\(model.isHidden!)', '\(model.IsPremium!)', '\(model.img_0!)', '\(model.img_1!)', '\(model.img_2!)', '\(model.img_3!)', '\(model.img_4!)', '\(model.img_5!)', '\(model.img_6!)', '\(model.img_7!)', '\(model.img_8!)', '\(model.img_9!)', '\(model.img_10!)', '\(model.img_11!)', '\(model.desc_050!)', '\(model.desc_075!)', '\(model.desc_100!)', '\(model.desc_125!)', '\(model.desc_150!)', '\(model.desc_175!)', '\(model.desc_200!)', '\(model.desc_225!)', '\(model.desc_250!)', '\(model.desc_275!)', '\(model.desc_300!)', '\(model.desc_325!)', '\(model.Alcohol_sugars!)', '\(model.Alcohol_fats!)')"
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {

                if sqlite3_step(statement) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!)
//                    print("Error updating Server Id table.%s", errmsg);
                    UpdateRecord(model: model)
                }
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
//                print("error preparing insert: \(errmsg)")
            }
            sqlite3_finalize(statement)
        }
    }
    
    func LoadAllRecord() -> [Model] {
        OpenDataBase()
        var records = [Model]()
        var statement: OpaquePointer?
        let query = "SELECT * FROM SubCategoryValue"
        if sqlite3_prepare_v2(db,query , -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let conversation = Model(category_name: String(cString: sqlite3_column_text(statement, 0)),
                                     subCategory_name: String(cString: sqlite3_column_text(statement, 1)),
                                     subCategory_id: String(cString: sqlite3_column_text(statement, 19)),
                                     category_id: String(cString: sqlite3_column_text(statement, 21)),
                                     Calories: String(cString: sqlite3_column_text(statement, 3)),
                                     Carbs: String(cString: sqlite3_column_text(statement, 4)),
                                     Cholesterol: String(cString: sqlite3_column_text(statement, 5)),
                                     Fat: String(cString: sqlite3_column_text(statement, 6)),
                                     Fibers: String(cString: sqlite3_column_text(statement, 7)),
                                     Iron: String(cString: sqlite3_column_text(statement, 8)),
                                     MonoUnsaturated: String(cString: sqlite3_column_text(statement, 9)),
                                     PolyUnsaturated: String(cString: sqlite3_column_text(statement, 10)),
                                     Potassium: String(cString: sqlite3_column_text(statement, 11)),
                                     Protein: String(cString: sqlite3_column_text(statement, 12)),
                                     Saturated: String(cString: sqlite3_column_text(statement, 13)),
                                     Sodium: String(cString: sqlite3_column_text(statement, 14)),
                                     Sugars: String(cString: sqlite3_column_text(statement, 15)),
                                     Trans: String(cString: sqlite3_column_text(statement, 16)),
                                     Vitamin_A: String(cString: sqlite3_column_text(statement, 17)),
                                     Vitamin_C: String(cString: sqlite3_column_text(statement, 18)),
                                     Url_image: String(cString: sqlite3_column_text(statement, 20)),
                                     calcium: String(cString: sqlite3_column_text(statement, 2)), ishidden: String(cString: sqlite3_column_text(statement, 22)), Ispremium: String(cString: sqlite3_column_text(statement, 23)), Img_0: String(cString: sqlite3_column_text(statement, 24)), Img_1: String(cString: sqlite3_column_text(statement, 25)), Img_2: String(cString: sqlite3_column_text(statement, 26)), Img_3: String(cString: sqlite3_column_text(statement, 27)), Img_4: String(cString: sqlite3_column_text(statement, 28)), Img_5: String(cString: sqlite3_column_text(statement, 29)), Img_6: String(cString: sqlite3_column_text(statement, 30)), Img_7: String(cString: sqlite3_column_text(statement, 31)), Img_8: String(cString: sqlite3_column_text(statement, 32)), Img_9: String(cString: sqlite3_column_text(statement, 33)), Img_10: String(cString: sqlite3_column_text(statement, 34)), Img_11: String(cString: sqlite3_column_text(statement, 35)), Desc_050: String(cString: sqlite3_column_text(statement, 36)), Desc_075: String(cString: sqlite3_column_text(statement, 37)), Desc_100: String(cString: sqlite3_column_text(statement, 38)), Desc_125: String(cString: sqlite3_column_text(statement, 39)), Desc_150: String(cString: sqlite3_column_text(statement, 40)), Desc_175: String(cString: sqlite3_column_text(statement, 41)), Desc_200: String(cString: sqlite3_column_text(statement, 42)), Desc_225: String(cString: sqlite3_column_text(statement, 43)), Desc_250: String(cString: sqlite3_column_text(statement, 44)), Desc_275: String(cString: sqlite3_column_text(statement, 45)), Desc_300: String(cString: sqlite3_column_text(statement, 46)), Desc_325: String(cString: sqlite3_column_text(statement, 47)), Alcohol_Sugars : String(cString: sqlite3_column_text(statement, 48)), Alcohol_Fats : String(cString: sqlite3_column_text(statement, 49)))
            if records.count == 0 {
                if(conversation.isHidden == "1") {
                    records = [conversation]
                }
            } else {
                if(conversation.isHidden == "1") {
                    records.append(conversation)
                }
            }
        }
        sqlite3_finalize(statement)
        return records
    }
    
    func LoadAllCategoryName() -> [String] {
        OpenDataBase()
        var records = [String]()
        var statement: OpaquePointer?
        let query = "SELECT * FROM SubCategoryValue"
        if sqlite3_prepare_v2(db,query , -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let CategoryName = String(cString: sqlite3_column_text(statement, 0))
            if records.count == 0 {
                records.append("\(CategoryName)")
            } else {
                if records.contains("\(CategoryName)") { } else {
                    records.append("\(CategoryName)")
                }
            }
        }
        sqlite3_finalize(statement)
        return records
    }
    
    func LoadCategory(Categoryname : String) -> [Model] {
        OpenDataBase()
        var records = [Model]()
        var statement: OpaquePointer?
        let query = "SELECT * FROM SubCategoryValue WHERE Category_name = \'\(Categoryname)'"
        if sqlite3_prepare_v2(db,query , -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let conversation = Model(category_name: String(cString: sqlite3_column_text(statement, 0)),
                                     subCategory_name: String(cString: sqlite3_column_text(statement, 1)),
                                     subCategory_id: String(cString: sqlite3_column_text(statement, 19)),
                                     category_id: String(cString: sqlite3_column_text(statement, 21)),
                                     Calories: String(cString: sqlite3_column_text(statement, 3)),
                                     Carbs: String(cString: sqlite3_column_text(statement, 4)),
                                     Cholesterol: String(cString: sqlite3_column_text(statement, 5)),
                                     Fat: String(cString: sqlite3_column_text(statement, 6)),
                                     Fibers: String(cString: sqlite3_column_text(statement, 7)),
                                     Iron: String(cString: sqlite3_column_text(statement, 8)),
                                     MonoUnsaturated: String(cString: sqlite3_column_text(statement, 9)),
                                     PolyUnsaturated: String(cString: sqlite3_column_text(statement, 10)),
                                     Potassium: String(cString: sqlite3_column_text(statement, 11)),
                                     Protein: String(cString: sqlite3_column_text(statement, 12)),
                                     Saturated: String(cString: sqlite3_column_text(statement, 13)),
                                     Sodium: String(cString: sqlite3_column_text(statement, 14)),
                                     Sugars: String(cString: sqlite3_column_text(statement, 15)),
                                     Trans: String(cString: sqlite3_column_text(statement, 16)),
                                     Vitamin_A: String(cString: sqlite3_column_text(statement, 17)),
                                     Vitamin_C: String(cString: sqlite3_column_text(statement, 18)),
                                     Url_image: String(cString: sqlite3_column_text(statement, 20)),
                                     calcium: String(cString: sqlite3_column_text(statement, 2)), ishidden: String(cString: sqlite3_column_text(statement, 22)), Ispremium: String(cString: sqlite3_column_text(statement, 23)), Img_0: String(cString: sqlite3_column_text(statement, 24)), Img_1: String(cString: sqlite3_column_text(statement, 25)), Img_2: String(cString: sqlite3_column_text(statement, 26)), Img_3: String(cString: sqlite3_column_text(statement, 27)), Img_4: String(cString: sqlite3_column_text(statement, 28)), Img_5: String(cString: sqlite3_column_text(statement, 29)), Img_6: String(cString: sqlite3_column_text(statement, 30)), Img_7: String(cString: sqlite3_column_text(statement, 31)), Img_8: String(cString: sqlite3_column_text(statement, 32)), Img_9: String(cString: sqlite3_column_text(statement, 33)), Img_10: String(cString: sqlite3_column_text(statement, 34)), Img_11: String(cString: sqlite3_column_text(statement, 35)), Desc_050: String(cString: sqlite3_column_text(statement, 36)), Desc_075: String(cString: sqlite3_column_text(statement, 37)), Desc_100: String(cString: sqlite3_column_text(statement, 38)), Desc_125: String(cString: sqlite3_column_text(statement, 39)), Desc_150: String(cString: sqlite3_column_text(statement, 40)), Desc_175: String(cString: sqlite3_column_text(statement, 41)), Desc_200: String(cString: sqlite3_column_text(statement, 42)), Desc_225: String(cString: sqlite3_column_text(statement, 43)), Desc_250: String(cString: sqlite3_column_text(statement, 44)), Desc_275: String(cString: sqlite3_column_text(statement, 45)), Desc_300: String(cString: sqlite3_column_text(statement, 46)), Desc_325: String(cString: sqlite3_column_text(statement, 47)), Alcohol_Sugars : String(cString: sqlite3_column_text(statement, 48)), Alcohol_Fats : String(cString: sqlite3_column_text(statement, 49)))
            if records.count == 0 {
                if(conversation.isHidden == "1") {
                    records = [conversation]
                }
            } else {
                if(conversation.isHidden == "1") {
                    records.append(conversation)
                }
            }
        }
        sqlite3_finalize(statement)
        return records
    }
    
    func LoadItem(SubCategory_id : String) -> Model {
        OpenDataBase()
        var record : Model!
        var statement: OpaquePointer?
        let query = "SELECT * FROM SubCategoryValue WHERE SubCategory_id = \'\(SubCategory_id)'"
        if sqlite3_prepare_v2(db,query , -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let conversation = Model(category_name: String(cString: sqlite3_column_text(statement, 0)),
                                     subCategory_name: String(cString: sqlite3_column_text(statement, 1)),
                                     subCategory_id: String(cString: sqlite3_column_text(statement, 19)),
                                     category_id: String(cString: sqlite3_column_text(statement, 21)),
                                     Calories: String(cString: sqlite3_column_text(statement, 3)),
                                     Carbs: String(cString: sqlite3_column_text(statement, 4)),
                                     Cholesterol: String(cString: sqlite3_column_text(statement, 5)),
                                     Fat: String(cString: sqlite3_column_text(statement, 6)),
                                     Fibers: String(cString: sqlite3_column_text(statement, 7)),
                                     Iron: String(cString: sqlite3_column_text(statement, 8)),
                                     MonoUnsaturated: String(cString: sqlite3_column_text(statement, 9)),
                                     PolyUnsaturated: String(cString: sqlite3_column_text(statement, 10)),
                                     Potassium: String(cString: sqlite3_column_text(statement, 11)),
                                     Protein: String(cString: sqlite3_column_text(statement, 12)),
                                     Saturated: String(cString: sqlite3_column_text(statement, 13)),
                                     Sodium: String(cString: sqlite3_column_text(statement, 14)),
                                     Sugars: String(cString: sqlite3_column_text(statement, 15)),
                                     Trans: String(cString: sqlite3_column_text(statement, 16)),
                                     Vitamin_A: String(cString: sqlite3_column_text(statement, 17)),
                                     Vitamin_C: String(cString: sqlite3_column_text(statement, 18)),
                                     Url_image: String(cString: sqlite3_column_text(statement, 20)),
                                     calcium: String(cString: sqlite3_column_text(statement, 2)), ishidden: String(cString: sqlite3_column_text(statement, 22)), Ispremium: String(cString: sqlite3_column_text(statement, 23)), Img_0: String(cString: sqlite3_column_text(statement, 24)), Img_1: String(cString: sqlite3_column_text(statement, 25)), Img_2: String(cString: sqlite3_column_text(statement, 26)), Img_3: String(cString: sqlite3_column_text(statement, 27)), Img_4: String(cString: sqlite3_column_text(statement, 28)), Img_5: String(cString: sqlite3_column_text(statement, 29)), Img_6: String(cString: sqlite3_column_text(statement, 30)), Img_7: String(cString: sqlite3_column_text(statement, 31)), Img_8: String(cString: sqlite3_column_text(statement, 32)), Img_9: String(cString: sqlite3_column_text(statement, 33)), Img_10: String(cString: sqlite3_column_text(statement, 34)), Img_11: String(cString: sqlite3_column_text(statement, 35)), Desc_050: String(cString: sqlite3_column_text(statement, 36)), Desc_075: String(cString: sqlite3_column_text(statement, 37)), Desc_100: String(cString: sqlite3_column_text(statement, 38)), Desc_125: String(cString: sqlite3_column_text(statement, 39)), Desc_150: String(cString: sqlite3_column_text(statement, 40)), Desc_175: String(cString: sqlite3_column_text(statement, 41)), Desc_200: String(cString: sqlite3_column_text(statement, 42)), Desc_225: String(cString: sqlite3_column_text(statement, 43)), Desc_250: String(cString: sqlite3_column_text(statement, 44)), Desc_275: String(cString: sqlite3_column_text(statement, 45)), Desc_300: String(cString: sqlite3_column_text(statement, 46)), Desc_325: String(cString: sqlite3_column_text(statement, 47)), Alcohol_Sugars : String(cString: sqlite3_column_text(statement, 48)), Alcohol_Fats : String(cString: sqlite3_column_text(statement, 49)) )
            record = conversation
        }
        sqlite3_finalize(statement)
        if(record != nil) {
        return record
        } else {
            return Model()
        }
    }
    
    func DeleteRecord(Categoryid : String, SubCategoryid : String) {
        OpenDataBase()
        _ = [Model]()
        var query = ""
        var statement: OpaquePointer?
        if(SubCategoryid == "") {
            query = "DELETE FROM SubCategoryValue WHERE Category_id = \'\(Categoryid)'"
        } else {
            query = "DELETE FROM SubCategoryValue WHERE SubCategory_id = \'\(SubCategoryid)'"
        }
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            if (sqlite3_column_text(statement, 1)) != nil {
            }
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error finalizing prepared statement: \(errmsg)")
        }
    }
    
}
