//
//  MyProfileVC.swift
//  Internacia
//
//  Created by Admin on 28/10/22.
//

import UIKit


class MyProfileVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var btn_changePassYAxis: NSLayoutConstraint!
    @IBOutlet weak var img_profile: UIImageView!
    @IBOutlet weak var txt_firstName: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    @IBOutlet weak var txt_emailId: UITextField!
    @IBOutlet weak var txt_contactNumber: UITextField!
    @IBOutlet weak var txt_address: UITextField!
    @IBOutlet weak var view_save: UIView!
    @IBOutlet weak var btn_camera: UIButton!
    @IBOutlet weak var view_content: UIView!
    @IBOutlet weak var titlesMain_View: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var btn_changePassword: CRButton!
    
    @IBOutlet weak var btn_deleteAccount: GradientButton!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var messageHeader: UIView!
    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var lbl_deleteNote: UILabel!
    private var s_image: UIImage?
    var title_name = "Mr"
    var defaultColor = UIColor.secInteraciaBlue
    var profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    var user_id = ""
    var isFrom : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if profile_dict != nil {
            messageHeader.isHidden = true
            editbutton.isHidden = false
            addDelegate()
            displayMyProfile()
        } else {
          messageHeader.isHidden = false
            editbutton.isHidden = true
//            self.navigationController?.popViewController(animated: true)
            self.view.makeToast(message: "Please login")
        }
        
        if isFrom == "Menu" {
            backButton.isHidden = false
        }else{
            backButton.isHidden = true
        }
        
    }
    
    
    
    // MARK: - Helper
    func addDelegate() {
        
        // bottom shadow...
        view_header.viewShadow()
        
        txt_firstName.delegate = self
        txt_lastName.delegate = self
        txt_emailId.delegate = self
        txt_contactNumber.delegate = self
        txt_address.delegate = self
        
        //disable...
        txt_emailId.isUserInteractionEnabled = false
        view_save.isHidden = true
        btn_changePassYAxis.constant = 20
        btn_camera.isHidden = true
        titlesMain_View.isUserInteractionEnabled = false
        cardView.isUserInteractionEnabled =  false
        btn_changePassword.isHidden = true
        btn_deleteAccount.isHidden = true
        lbl_deleteNote.isHidden = true
    }
    
    func titlesSelectionColor() {
        
        // selection color changing...
        for childView in titlesMain_View.subviews {
            if childView is UIButton {
                
                let btn = childView as! UIButton
                btn.backgroundColor = UIColor.white
                btn.setTitleColor(defaultColor, for: .normal)
                
                if btn.currentTitle == title_name {
                    btn.backgroundColor = defaultColor
                    btn.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
    }
    
    func displayMyProfile() {
        profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
        if profile_dict != nil {
            
            if let profile = profile_dict as? [String: Any] {
                
                if let userId = profile["user_id"] as? String {
                    self.user_id = userId
                }
                
                if let fName = profile["first_name"] as? String {
                    txt_firstName.text = fName
                }
                if let lName = profile["last_name"] as? String {
                    txt_lastName.text = lName
                }
                if let phone = profile["phone"] as? String {
                    txt_contactNumber.text = phone
                }
                if let emailId = profile["email_id"] as? String {
                    txt_emailId.text = emailId
                }
                if let address = profile["address"] as? String {
                    txt_address.text = address
                }
                if let img_url = profile["image"] as? String {
                    img_profile.sd_setImage(with: URL.init(string: img_url), placeholderImage: UIImage.init(named: "ic_profile_dummy"))
                }
            }
        }
    }
    
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func titlesButtonsClicked(_ sender: UIButton) {
        
        title_name = sender.currentTitle!
        titlesSelectionColor()
    }
    
    @IBAction func editBtnClicked(_ sender: UIButton) {
        
        //disable...
        view_save.isHidden = false
        btn_changePassYAxis.constant = 75
        btn_camera.isHidden = false
        self.view_content.isUserInteractionEnabled = true
        self.titlesMain_View.isUserInteractionEnabled = true
        self.cardView.isUserInteractionEnabled =  true
        btn_changePassword.isHidden = false
        btn_deleteAccount.isHidden = false
        lbl_deleteNote.isHidden = false
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        if txt_firstName.text?.count == 0 || txt_firstName.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter first name"
        }
        else if txt_lastName.text?.count == 0 || txt_lastName.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter last name"
        }
        else if txt_emailId.text?.count == 0 || txt_emailId.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter email id"
        }
        else if txt_emailId.text?.isValidEmailAddress() == false {
            messageStr = "Please enter valid email address"
        }
        else if txt_contactNumber.text?.count == 0 || txt_contactNumber.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter mobile number"
        }

        // validation message...
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            
            // calling register...
            self.dismiss_keyboard()
            updateProfile_HTTPConnection()
        }
    }
    
    @IBAction func changePassBtnClicked(_ sender: Any) {
        addDelegate()
        displayMyProfile()
    }
    
    @IBAction func deleteAcountBtnClicked(_ sender: Any) {
        deleteAccountApiCall(sender)
    }
    @IBAction func cameraBtnClicked(_ sender: Any) {
        
        // select images...
        DImagePicker.shared.view_ctrl = self
        DImagePicker.shared.delegate = self
        DImagePicker.shared.addAlertViewCtrl(isEdit: true)
    }
    
    @IBAction func navigateToLogin(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
    }
    
    @IBAction func naviagateToRegister(_ sender: Any) {
        let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC")
        let navigationController = UINavigationController(rootViewController: loginObj!)
        navigationController.isNavigationBarHidden = true
        appDel.window?.rootViewController = navigationController
    }
}

extension MyProfileVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate & TablePopViewDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func dismiss_keyboard() -> Void {
        
        // resign key boards...
        txt_firstName.resignFirstResponder()
        txt_lastName.resignFirstResponder()
        txt_emailId.resignFirstResponder()
        txt_contactNumber.resignFirstResponder()
        txt_address.resignFirstResponder()
    }
   
}

extension MyProfileVC: DImagePickerDelegate {
    
    // MARK:- DImagePickerDelegate
    func imagePickerDidSelected(image: UIImage) {
        
        // selected images...
        s_image = image
        img_profile.image = s_image
    }
    
    func imagePickerDidCancel() {
    }
}


extension MyProfileVC {
    
    // MARK:- API's
    func updateProfile_HTTPConnection() {
        
        SwiftLoader.show(animated: true)
        
        var title_value = "1"
        if title_name == "Ms" {
            title_value = "2"
        } else if title_name == "Mrs" {
            title_value = "3"
        } else {}
        
        // params...
        let params: [String: String] = ["user_id": user_id,
                                        "title": title_value,
                                        "first_name": txt_firstName.text!,
                                        "last_name": txt_lastName.text!,
                                        "phone": txt_contactNumber.text!,
                                        "country_code": "91",
                                        "address": txt_address.text!]
        
        print("params: \(params)")
        
        // image params...
        var images: [String: UIImage] = [:]
        if s_image != nil {
            images["image"] = s_image
        }
        
        // calling api...
        VKAPIs.shared.getRequestFormdata(params: params, images: images, file: User_UpdateProfile, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Update Profile : \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let data_dict = result_dict["data"] as? [String: Any] {
                            
                            // store user profiles...
                            let profile_dict = VKRemoveNull.shared.filterNulls_inDictionary(dictionary: data_dict, empty: true)
                            
                            UserDefaults.standard.set(profile_dict, forKey: TMXUser_Profile)
                            appDel.window?.makeToast(message: result_dict["msg"] as! String)
                            DispatchQueue.main.async {
                                self.addDelegate()
                                self.displayMyProfile()
                                
                            }
                            //NotificationCenter.default.post(name: yNotify_ProfileUpdate, object: nil)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else {
                        
                        // error message...
                        if let message_str = result_dict["msg"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Update Profile formate : \(String(describing: resultObj))")
                }
            } else {
                print("Update Profile error : \(String(describing: error?.localizedDescription))")
            }
            SwiftLoader.hide()
        }
    }
    func deleteAccountApiCall(_ sender: Any){
        let user_id = ""
        let uuid = ""
        SwiftLoader.show(animated: true)
        let params: [String: String] = ["user_id": user_id.getUserId(),"uuid": uuid.getUUID()]

        VKAPIs.shared.getRequestXwwwform(params: params, file: "general/deactivate_account", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("deActivate user responce: \(String(describing: resultObject))")
                if let result_dict = resultObject as? [String : Any] {
                    if result_dict["status"] as? Bool == true {
                        if self.profile_dict != nil {
                            //user logout...
                            UserDefaults.standard.set(nil, forKey: TMXUser_Profile)
                        }
                        appDel.window?.makeToast(message: "Account Deactivated Successfully")
                        self.navigateToLogin(sender)
//                        self.navigationController?.popViewController(animated: true)

                    }
//                }
            } else {
                print("deActivate user formate : \(String(describing: resultObject))")
            }
            } else {
                print("deActivate user error: \(String(describing: error?.localizedDescription))")
            }
            SwiftLoader.hide()

        }
    }
}
