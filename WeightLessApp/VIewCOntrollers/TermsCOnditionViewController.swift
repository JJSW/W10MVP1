//
//  TermsCOnditionViewController.swift
//  WeightLessApp
//
//  Created by IBL Infotech on 16/02/18.
//  Copyright © 2018 Krupa Detroja. All rights reserved.
//

import UIKit
import WebKit

class TermsCOnditionViewController: UIViewController, WKUIDelegate,WKNavigationDelegate{
    
    @IBOutlet var WebVIEW: WKWebView!
    var UrlText  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = NeavyBlueColor
        setnavgationbar(title: "Terms & Privacy Policy", backButton: true, self, #selector(leftBarButtonTapped),BackButtonTintColor: UIColor.white, TitleLabelColor: UIColor.white, MainBackgroundColor: NeavyBlueColor )
        let url = NSURL (string: "http://weightless10.com/terms-and-conditions/");
        let request = NSURLRequest(url: url! as URL);
        WebVIEW.load(request as URLRequest);
    }
    
    //Webview Delegate Methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // showActivityIndicator(show: true)
        ActivityView.showActivityIndicator()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ActivityView.showActivityIndicator()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ActivityView.hideActivityIndicator()
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
