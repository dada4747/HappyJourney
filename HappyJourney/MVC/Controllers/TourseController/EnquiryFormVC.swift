//
//  EnquiryFormVC.swift
//  ExtactTravel
//
//  Created by Admin on 17/08/22.
//

import UIKit

class EnquiryFormVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var view_headerView: UIView!
    @IBOutlet weak var lbl_packageName: UILabel!
    @IBOutlet weak var tf_Name: UITextField!
    @IBOutlet weak var tf_Email: UITextField!
    @IBOutlet weak var tf_contactNumber: UITextField!
    @IBOutlet weak var tf_message: UITextField!
    @IBOutlet weak var sv_formScrollview: UIScrollView!
    
    @IBOutlet weak var tf_departedPlace: UITextField!
    //MARK: - IBActions
    var packgeID : String?
    var packageName : String!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardNotification()
        lbl_packageName.text = packageName
        view_headerView.viewShadow()
        addTextFieldDelegate()
        
    }
    //MARK:- Functions
    func keyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func addTextFieldDelegate(){
        tf_Name.delegate = self
        tf_Email.delegate = self
        tf_message.delegate = self
        tf_contactNumber.delegate = self
        tf_departedPlace.delegate = self
    }
    func sendQueryFormValidation() {
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        if tf_Name.text?.count == 0 || tf_Name.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter name"
        }
        else if !(tf_Name.text?.isValidName())! {
            messageStr = "Please enter valid name"
        }
        else if tf_Email.text?.count == 0 || tf_Email.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter Email"
        }else if tf_Email.text?.isValidEmailAddress() == false {
            messageStr = "Please enter valid email address"
        } else if tf_contactNumber.text?.count == 0 || tf_contactNumber.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter mobile number"
        } else if tf_contactNumber.text?.isValidPhone() == false {
            messageStr = "Please enter valid contact number"

        }else if tf_departedPlace.text?.count == 0 || tf_departedPlace.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter departed place"
        }else if tf_message.text?.count == 0 || tf_message.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please enter message "
        } else{}
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        } else{
            self.dissmissKeyboard()
            self.view.isUserInteractionEnabled = false

            sendQueryApi()
        }
    }
    //MARK:- OBJC Function

    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.sv_formScrollview.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        sv_formScrollview.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        sv_formScrollview.contentInset = contentInset
    }
    
    //MARK: - IBActions
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func sendQueryClicked(_ sender: Any) {
        sendQueryFormValidation()
    }
    
}
//MARK: - UITextFieldDelegate
extension EnquiryFormVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tf_contactNumber {
            
            if string.isValidIntergerSet() == false {
                return false
            }
            let currentCharacterCount = textField.text?.count ?? 0
            if range.length + range.location > currentCharacterCount {
                return false
            }
            let newLength = currentCharacterCount + string.count - range.length
            return newLength <= 15
        }
        else if textField == tf_Name {
            
            if string.isValidAlphabetsSet() == false {
               return false
            }
            return true
        }
        return true
    }
    
    func dissmissKeyboard(){
        tf_Name.resignFirstResponder()
        tf_Email.resignFirstResponder()
        tf_contactNumber.resignFirstResponder()
        tf_message.resignFirstResponder()
        tf_departedPlace.resignFirstResponder()
    }
}

//MARK:- API Call
extension EnquiryFormVC {
    
    func sendQueryApi() -> Void {
        CommonLoader.shared.startLoader(in: view)

        let param: [String: String] = [
            "email": tf_Email.text!,
            "phone": tf_contactNumber.text!,
            "place": tf_departedPlace.text!,
            "message": tf_message.text!,
            "package_id": packgeID!,
            "first_name": tf_Name.text!,
        ]
        
        let paramString: [String: String] = ["enquiry":VKAPIs.getJSONString(object: param)]
        //API call
        VKAPIs.shared.getRequestFormdata(params: paramString, file: Tours_enquiry_mobile, httpMethod: .POST) { (resultObj, success, error) in
           
            // success status...
            if success == true {
                print("Send Query Response : \(String(describing: resultObj))")

                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                            // move to home sreen...
                        appDel.moveToHomeScreen()
                        appDel.window?.makeToast(message: result_dict["message"] as! String)
                    }
                    else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Send Query formate : \(String(describing: resultObj))")
                }
            } else {
                print("Send Query error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            CommonLoader.shared.stopLoader()
        }
    }
}
