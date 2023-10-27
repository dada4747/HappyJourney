//
//  SliderMenuView.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

//protocol
protocol SliderMenuViewDelegate: class {
    func sliderMenuActions(section_name: String)
}

class SliderMenuView: UIView {
    
    // MARK:- Outlets
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var tbl_menuTable: UITableView!
    @IBOutlet weak var btn_bg: UIButton!
    @IBOutlet weak var lbl_titleName: UILabel!
    
    @IBOutlet weak var lbl_mobileNumber: UILabel!
    
    // variables...
    var delegate: SliderMenuViewDelegate?
    var menu_array: [String] = []
    
    var manage_pass: Bool = false

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_mobileNumber.text = ""
        tbl_menuTable.delegate = self
        tbl_menuTable.dataSource = self
        self.displayUserInformation()
        
        //addNotifications()
        
    }
    
//    deinit {
//        self.removeNotification()
//    }
    
    // MARK:- Helper...
    @objc func displayUserInformation() {
        //, "My Account", "My Bookings", "My Rewards","Wishlist"
        menu_array = ["Home", "Create Account", "About Us", "Contact Us", "Terms & Conditions", "Privacy Policy", "Login"]
        
        // display user information...
        lbl_titleName.text = "Welcome Guest"
        let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
        if profile_dict != nil {
            
//            menu_array = ["Home", "My Account", "My Bookings", "My Rewards", "Wishlist", "Notifications", "About Us", "Contact Us", "Terms & Conditions", "Privacy Policy", "Change Password", "Rate Us", "Logout"]
            menu_array = ["Home", "My Account", "My Bookings", "About Us", "Contact Us", "Terms & Conditions", "Privacy Policy", "Change Password", "Logout"]
            if let profile = profile_dict as? [String: Any] {
                
                if let img_url = profile["image"] as? String {
                    
                    img_profile.sd_setImage(with: URL.init(string: img_url), placeholderImage: UIImage.init(named: "ic_profile_dummy"))
                }
                
                if let fName = profile["first_name"] as? String, let lName = profile["last_name"] as? String {
                    lbl_titleName.text = "\(fName) \(lName)"
                }
                if let mob_number = profile["phone"] as? String {
                    lbl_mobileNumber.text = mob_number
                }
            }
        }
    }
    
    // MARK:- ButtonAction
    @IBAction func hiddenButtonClicked(_ sender: UIButton) {
        
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.sideMenu_actions()
    }
    
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        //delegate?.SliderMenuViewDelegate(selected_name: "Profile")
    }


}

extension SliderMenuView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (45 * xScale)
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
        if indexPath.row == 0 {
            cell?.view_gradient.startColor = UIColor(hexString: "#3A91EC")
            cell?.view_gradient.endColor = UIColor(hexString: "#426ED9")
        }else if indexPath.row == 1 {
            cell?.view_gradient.startColor = UIColor(hexString: "#FF825F")
            cell?.view_gradient.endColor = UIColor(hexString: "#FF4C51")

        }else if indexPath.row == 2 {
            cell?.view_gradient.startColor = UIColor(hexString: "#FF895F")
            cell?.view_gradient.endColor = UIColor(hexString: "#FF9E38")

        }else if indexPath.row == 3 {
            cell?.view_gradient.startColor = UIColor(hexString: "#26C8A8")
            cell?.view_gradient.endColor = UIColor(hexString: "#62C76D")

        }else if indexPath.row == 4 {
            cell?.view_gradient.startColor = UIColor(hexString: "#FF895F")
            cell?.view_gradient.endColor = UIColor(hexString: "#FFD438")

        }else {
//            cell?.view_gradient.startColor
        }
                    
                    
                     
            
        cell?.display_sideMenuInformation(title_name: menu_array[indexPath.row])
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sliderMenuActions(section_name: menu_array[indexPath.row])
    }
}
