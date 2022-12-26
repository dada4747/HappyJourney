//
//  FlightPaymentVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import WebKit

class FlightPaymentVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var payment_url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInfo()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Helpers
    func setupInfo() {
        
        SwiftLoader.show(animated: true)
        VKKeyboardManager.shared.setDisable()
        
        // delegates
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // bottom shadow...
        view_header.viewShadow()
        
        // webview loading...
        self.perform(#selector(webviewCalling), with: nil, afterDelay: 1)
    }
    
    @objc func webviewCalling() {
        
        // request...
        if let url_string = payment_url {

            let urlString = URL.init(string: url_string)
            if let final_url = urlString {
                print("Final: \(final_url)")
                let url_req = URLRequest.init(url: final_url)
                webView.load(url_req)
                webView.allowsBackForwardNavigationGestures = true
            }
        }
        else {
            print("Url not available")
        }
    }
    
    // MARK: - ButtonAction...
    @IBAction func backBtnClicked(_ sender: Any) {
        
        VKKeyboardManager.shared.setEnable()
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension FlightPaymentVC: WKUIDelegate, WKNavigationDelegate {
    
    // MARK:- WKWebview
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("didStartProvisionalNavigation URL:\(String(describing: webView.url))")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        SwiftLoader.hide()
        print("Success URL:\(String(describing: webView.url))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         SwiftLoader.hide()
        print("webView loading - didFail")
    }

}

