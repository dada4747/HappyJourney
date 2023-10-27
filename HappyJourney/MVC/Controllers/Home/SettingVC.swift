//
//  SettingVC.swift
//  Internacia
//
//  Created by Admin on 20/10/22.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tbl_menuTable: UITableView!
    @IBOutlet weak var lbl_settingsLoc: UILabel!
    
    
    // varibales...
    var menu_array: [String] = []
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    //let navControl = getRootNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tbl_menuTable.delegate = self
        tbl_menuTable.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.displayUserInformation()
        addSideMenu()
        tbl_menuTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- Helper...
    func addSideMenu() -> Void {
        
        // remove if existed...
        let window = getWindow()
        let menu_view = window.viewWithTag(50000)
        if menu_view != nil {
            menu_view?.removeFromSuperview()
        }
        
        // slider menu...
        let side_menu = Bundle.main.loadNibNamed("SliderMenuView", owner: nil, options: nil)![0] as! SliderMenuView
        side_menu.frame = CGRect.init(x: -self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        side_menu.delegate = self
        side_menu.btn_bg.alpha = 0
        side_menu.tag = 50000
        UIApplication.shared.keyWindow?.addSubview(side_menu)
    }
    
    @objc func displayUserInformation() {
        
        lbl_settingsLoc.text =  "Settings"
        
        menu_array = ["My Profile","My Bookings","Change Password","Login"]
        
        // display user information...
        let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
        if profile_dict != nil {
            
            menu_array = ["My Profile","My Bookings", "Change Password","Logout"]
            
            if let profile = profile_dict as? [String: Any] {
                
                if let img_url = profile["image"] as? String {
                    
                    //img_profile.sd_setImage(with: URL.init(string: img_url), placeholderImage: UIImage.init(named: "ic_profile_dummy"))
                }
                
                if let userName = profile["user_name"] as? String {
                   // lbl_titleName.text = userName
                }
            }
        }
    }
    
    // MARK:- ButtonAction...
//    @IBAction func menuBtnClicked(_ sender: UIButton) {
//        // menu moving...
//        appDel.sideMenu_actions()
//    }
//    @IBAction func logoBtnClicked(_ sender: Any) {
//
//        guard let tabBar = self.tabBarController as? CustomTabBarVC else {
//            return
//        }
//        tabBar.TabBarButtonClicked(sender: tabBar.btn_tab0)
//    }

}


extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (40 * xScale)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu_array.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "SliderMenuCell") as? SliderMenuCell
        if cell == nil {
            tableView.register(UINib(nibName: "SliderMenuCell", bundle: nil), forCellReuseIdentifier: "SliderMenuCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SliderMenuCell") as? SliderMenuCell
        }
        
        // display information...
        cell?.display_sideMenuInformation(title_name: menu_array[indexPath.row])
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section_name = menu_array[indexPath.row]
        let pl_message = "Please Login"

        // menu actions...
        if section_name == "My Profile" {
            
            if profile_dict != nil {
                // move to my profile...
                let profile_vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                profile_vc.isFrom = "Setting"
                let navControl = getRootNavigation()

                navControl?.pushViewController(profile_vc, animated: true)
                //navControl?.pushViewController(vc, animated: true)
            } else {
                self.view.makeToast(message: pl_message)
            }
        }
        else if section_name == "My Bookings" {
            
            if profile_dict != nil {
                
                guard let tabBar = self.tabBarController as? CustomTabBarVC else {
                    return
                }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
//                vc.from = "Setting"
                let navControl = getRootNavigation()

                navControl?.pushViewController(vc, animated: true)
                
//                tabBar.TabBarButtonClicked(sender: tabBar.btn_tab2)

            } else {
                self.view.makeToast(message: pl_message)
            }
        }
        else if section_name == "Change Password" {
            
            if profile_dict != nil {
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                //navControl?.pushViewController(vc, animated: true)
                let navControl = getRootNavigation()

                navControl?.pushViewController(vc, animated: true)

//                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                self.view.makeToast(message: pl_message)
            }
        }
        else if section_name == "Logout" || section_name == "Login" {
            
            if profile_dict != nil {
                
                //user logout...
                UserDefaults.standard.set(nil, forKey: TMXUser_Profile)
            }
            
            // move to Login(Change root for window)...
            let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            let navigationController = UINavigationController(rootViewController: loginObj!)
            navigationController.isNavigationBarHidden = true
            appDel.window?.rootViewController = navigationController
        }
        else {}
    }
}


extension SettingsVC: SliderMenuViewDelegate {
    
    // MARK:- SMenuViewDelegate
    func sliderMenuActions(section_name: String) {
        
        // menu moving...
        let appDele : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDele.sideMenu_actions()
        print("slider menu : \(section_name)")
        
        // menu actions...
        if section_name == "About Us" {
            
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .AboutUs
            //navControl?.pushViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if section_name == "Contact Us" {
            
            // move to contact us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .ContactUs
            //navControl?.pushViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if section_name == "Privacy Policy" {
            
            // move to Privacy...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Privacy
            //navControl?.pushViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if section_name == "Terms & Conditions" {
            
            // move to about us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Terms
            //navControl?.pushViewController(vc, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if section_name == "Book Now" {
            
            guard let tabBar = self.tabBarController as? CustomTabBarVC else {
                return
            }
//            tabBar.TabBarButtonClicked(sender: tabBar.btn_tab1)
        }
        else if section_name == "My Profile" {
            
            if profile_dict != nil {
                // move to my profile...
                let profile_vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                self.navigationController?.pushViewController(profile_vc, animated: true)
                //navControl?.pushViewController(vc, animated: true)
            } else {
                let pl_message = "Please Login"
                self.view.makeToast(message: pl_message)
            }
        }
        else if section_name == "Logout" || section_name == "Login" {
            
            if profile_dict != nil {
                //user logout...
                UserDefaults.standard.set(nil, forKey: TMXUser_Profile)
            }
            
            // move to Login(Change root for window)...
            let loginObj = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginVC")
            let navigationController = UINavigationController(rootViewController: loginObj)
            navigationController.isNavigationBarHidden = true
            appDel.window?.rootViewController = navigationController
        }
 
        else {}
    }
}
