//
//  HistoryVoucherVC.swift
//  Internacia
//
//  Created by Admin on 30/08/22.
//

import UIKit
import WebKit
import PDFKit

class HistoryVoucherVC: UIViewController, URLSessionDelegate {

    @IBOutlet weak var headerView: CRView!
    @IBOutlet weak var web_view: WKWebView!
    
    var payment_url: String?
    var download_url : String?
    var booking_id: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInfo()
    }
    
    // MARK: - Helpers
    func setupInfo() {
        
        SwiftLoader.show(animated: true)
        VKKeyboardManager.shared.setDisable()
        
        // delegates
        web_view.uiDelegate = self
        web_view.navigationDelegate = self
        
        // bottom shadow...
        headerView.viewShadow()
        
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
                web_view.load(url_req)
                web_view.allowsBackForwardNavigationGestures = true
            }
        }
        else {
            print("Url not available")
        }
    }
    
    // MARK: - ButtonAction...
    @IBAction func backBtnClicked(_ sender: Any) {
        
        VKKeyboardManager.shared.setEnable()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadButtonAction(_ sender: Any) {
        SwiftLoader.show(animated: true)
        guard let url = URL(string: self.download_url!) else {return}
        print(url)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            let pathURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(self.booking_id!).pdf")
                                do {
                                    try data.write(to: pathURL, options: .atomic)
                                    print(pathURL)
                                    DispatchQueue.main.async {
                                        self.view.makeToast(message: "File Downloaded")
                                        SwiftLoader.hide()
                                    }
                                }catch{
                                    DispatchQueue.main.async {
                                        self.view.makeToast(message: "Error while downloading, try again")
                                        SwiftLoader.hide()
                                    }
                                    
                                }

        }
        
        task.resume()
        
    }
}

extension HistoryVoucherVC: WKUIDelegate, WKNavigationDelegate {
    
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
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        SwiftLoader.hide()
        self.navigationController?.popViewController(animated: true)
        print("didFailProvisionalNavigation URL:\(String(describing: webView.url))")
    }

}

