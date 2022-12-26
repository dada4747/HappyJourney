//
//  SocialLoginVC.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit

class SocialLoginVC: UIViewController {
    
    @IBOutlet weak var btn_register: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController

    }

    
    @IBAction func loginAction(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
        
    }
    
    @IBAction func alreadyAcountAction(_ sender: Any) {
//        let home_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CustomTabBarVC") as! CustomTabBarVC
//        let navi_ctrl = UINavigationController.init(rootViewController: home_vc)
//        navi_ctrl.isNavigationBarHidden = true
//        appDel.window?.rootViewController = navi_ctrl
//        appDel.window?.makeKeyAndVisible()
        appDel.moveToHomeScreen()
    }
}

extension SocialLoginVC {
    func apiCall(paramString: [String: String], file: String){
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: file, httpMethod: .POST) { resultObj, success, error in
            // success status...
            if success == true {
                print("Social Login response: \(String(describing: resultObj))")

                if let result_dict = resultObj as? [String: Any] {
                    let data_dict: [String : Any] = ["title": 1, "user_type": result_dict["user_type"] ?? "", "email_id": result_dict["email"] ?? "", "address": "", "auth_user_pointer": result_dict["auth_user_pointer"] ?? "", "first_name": result_dict["first_name"] ?? "", "last_name": result_dict["last_name"] ?? "", "user_id": result_dict["user_id"] ?? "", "phone": result_dict["phone"] ?? "", "country_code": 91, "image": "", "user_name": ""]
                    let profile_dict = VKRemoveNull.shared.filterNulls_inDictionary(dictionary: data_dict , empty: true)
                    UserDefaults.standard.set(profile_dict, forKey: TMXUser_Profile)
                    appDel.window?.makeToast(message: result_dict["message"] as! String)
                    // move to home sreen...
                    appDel.moveToHomeScreen()
                } else {
                    print("Social Login response error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }

                SwiftLoader.hide()
            }
        }
    }
}
