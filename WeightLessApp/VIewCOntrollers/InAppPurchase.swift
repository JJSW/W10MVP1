 //
//  InAppPurchase.swift
//  ios_swift_in_app_purchases_sample
//
//  Created by Maxim Bilan on 7/27/15.
//  Copyright (c) 2015 Maxim Bilan. All rights reserved.
//

import Foundation
import StoreKit
import Firebase
 import SwiftMessages
class InAppPurchase : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
	
	static let sharedInstance = InAppPurchase()
	
#if DEBUG
	let verifyReceiptURL = "https://sandbox.itunes.apple.com/verifyReceipt"
#else
	let verifyReceiptURL = "https://buy.itunes.apple.com/verifyReceipt"
#endif
	
	let kInAppProductPurchasedNotification = "InAppProductPurchasedNotification"
	let kInAppPurchaseFailedNotification   = "InAppPurchaseFailedNotification"
	let kInAppProductRestoredNotification  = "InAppProductRestoredNotification"
	let kInAppPurchasingErrorNotification  = "InAppPurchasingErrorNotification"
	
	let unlockTestInAppPurchase1ProductId = "com.testing.iap1"
	let unlockTestInAppPurchase2ProductId = "com.testing.iap2"
	let autorenewableSubscriptionProductId = "com.testing.autorenewablesubscription"
	let nonrenewingSubscriptionProductId = "com.testing.nonrenewingsubscription"
    
    let UnlockPremiumFoods = "com.iblinfotech.app.WeightLessApp.UnlockPremiumFoods"
    
	override init() {
		super.init() 
		SKPaymentQueue.default().add(self)
	}
	
	func buyProduct(_ product: SKProduct) {
//        print("Sending the Payment Request to Apple")
		let payment = SKPayment(product: product)
		SKPaymentQueue.default().add(payment)
	}
	
	func restoreTransactions() {
        ActivityView.showActivityIndicator()
		SKPaymentQueue.default().restoreCompletedTransactions()
	}
	
	func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Error %@ \(error)")
        ActivityView.hideActivityIndicator()
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.warning)
        warning.configureDropShadow()
        let iconText = ["😳"].sm_random()!
        warning.configureContent(title: "Failed!", body: "\(error)", iconText: iconText)
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        SwiftMessages.show(config: warningConfig, view: warning)
		NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: error.localizedDescription)
	}
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print("Got the request from Apple")
		let count: Int = response.products.count
		if count > 0 {
			_ = response.products
			let validProduct: SKProduct = response.products[0] 
//            print(validProduct.localizedTitle)
//            print(validProduct.localizedDescription)
//            print(validProduct.price)
			buyProduct(validProduct);
		}
		else {
//            print("No products")
		}
	}
	
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        print("Received Payment Transaction Response from Apple");
		for transaction in transactions {
            let trans: SKPaymentTransaction = transaction
            print(trans.transactionState)
				switch trans.transactionState {
				case .purchased:
//                    print("Product Purchased")
                    let warning = MessageView.viewFromNib(layout: .cardView)
                    warning.configureTheme(.success)
                    warning.configureDropShadow()
                    let iconText = ["🤔"].sm_random()!
                    warning.configureContent(title: "Success!", body: "Product Purchased", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                    SwiftMessages.show(config: warningConfig, view: warning)
					savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction )
					NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductPurchasedNotification), object: nil)
					break
				case .failed:
//                    print(transaction.error as Any)
//                    print("Purchased Failed")
                    ActivityView.hideActivityIndicator()
                    let warning = MessageView.viewFromNib(layout: .cardView)
                    warning.configureTheme(.warning)
                    warning.configureDropShadow()
                    let iconText = ["😳"].sm_random()!
                    warning.configureContent(title: "Failed!", body: (transaction.error?.localizedDescription)!, iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                    SwiftMessages.show(config: warningConfig, view: warning)
                    SKPaymentQueue.default().finishTransaction(transaction )
					NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchaseFailedNotification), object: nil)
					break
				case .restored:
//                    print("Product Restored")
                    ActivityView.hideActivityIndicator()
                    let warning = MessageView.viewFromNib(layout: .cardView)
                    warning.configureTheme(.success)
                    warning.configureDropShadow()
                    let iconText = ["🤔"].sm_random()!
                    warning.configureContent(title: "Success!", body: "Product Restored", iconText: iconText)
                    warning.button?.isHidden = true
                    var warningConfig = SwiftMessages.defaultConfig
                    warningConfig.presentationContext = .window(windowLevel: UIWindowLevelNormal)
                    SwiftMessages.show(config: warningConfig, view: warning)
					savePurchasedProductIdentifier(trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction )
					NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppProductRestoredNotification), object: nil)
					break
				default:
                    ActivityView.showActivityIndicator()
					break
				}
			}
	}
	
	func savePurchasedProductIdentifier(_ productIdentifier: String!) {
		UserDefaults.standard.set(productIdentifier, forKey: productIdentifier)
		UserDefaults.standard.synchronize()
        UserDefaults.standard.set("Lunch", forKey: "isPurchased")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReloadData"), object: nil)
        receiptValidation()
	}
    
    func updateArtist(Date : String){
        //creating artist with the new given values
        let userID = Auth.auth().currentUser?.uid
        let artist = ["id":UserDefaults.standard.string(forKey: "id") as Any,
                      "uid":userID!,
                      "email": UserDefaults.standard.string(forKey: "UserEmail") as Any,
                      "purchasedate": Date,
                      "isPurchased": UserDefaults.standard.string(forKey: "isPurchased") as Any,
                      "isBlocked": "1",
                      "DailyTarget": UserDefaults.standard.string(forKey: "DailyTarget") as Any,
                      "DailyTargetIndex": UserDefaults.standard.string(forKey: "DailyTargetIndex") as Any,
                      "DailypercentTarget": UserDefaults.standard.string(forKey: "DailypercentTarget") as Any
            ] as [String : Any]
        //updating the artist using the key of the artist
        Database.database().reference().child("UserList").child(UserDefaults.standard.string(forKey: "id")!).setValue(artist)
    }
	
	func receiptValidation() {
		let receiptFileURL = Bundle.main.appStoreReceiptURL
		let receiptData = try? Data(contentsOf: receiptFileURL!)
		let recieptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
		let jsonDict: [String: AnyObject] = ["receipt-data" : recieptString! as AnyObject, "password" : "6890715389f743d5a3879fd456b6fd62" as AnyObject]
		do {
			let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
			let storeURL = URL(string: verifyReceiptURL)!
			var storeRequest = URLRequest(url: storeURL)
			storeRequest.httpMethod = "POST"
			storeRequest.httpBody = requestData
			let session = URLSession(configuration: URLSessionConfiguration.default)
			let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
				do {
					let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//                    print(jsonResponse)
					if let date = self?.getPurchaseDateFromResponse(jsonResponse as! NSDictionary) {
//                        print(date)
                        self?.updateArtist(Date: "\(date)")
                        ActivityView.hideActivityIndicator()
					}
				} catch let parseError {
//                    print(parseError)
				}
			})
			task.resume()
		} catch let parseError {
//            print(parseError)
		}
	}
	
	func getPurchaseDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
		if let receiptInfo: NSDictionary = jsonResponse["receipt"] as? NSDictionary {
//            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
			if let PurchaseDate = receiptInfo["request_date"] as? String {
				let Purchasedate: Date = formatter.date(from: PurchaseDate) as Date!
				return Purchasedate
			}
			return nil
		} else {
			return nil
		}
	}
	
	func unlockProduct(_ productIdentifier: String!) {
        ActivityView.showActivityIndicator()
		if SKPaymentQueue.canMakePayments() {
			let productID: NSSet = NSSet(object: productIdentifier)
			let productsRequest: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
			productsRequest.delegate = self
			productsRequest.start()
//            print("Fetching Products")
		} else {
//            print("Сan't make purchases")
			NotificationCenter.default.post(name: Notification.Name(rawValue: kInAppPurchasingErrorNotification), object: NSLocalizedString("CANT_MAKE_PURCHASES", comment: "Can't make purchases"))
		}
	}
	
	func buyUnlockTestInAppPurchase1() {
		unlockProduct(UnlockPremiumFoods)
	}
}
