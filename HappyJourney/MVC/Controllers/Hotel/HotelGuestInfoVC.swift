//
//  HotelGuestInfoVC.swift
//  Internacia
//
//  Created by Admin on 31/10/21.
//

import UIKit

class HotelGuestInfoVC: UIViewController {
    @IBOutlet weak var lbl_grandFinalTotal: UILabel!
    
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    
    // passengers list elements...
    @IBOutlet weak var tbl_adultNames: UITableView!
    @IBOutlet weak var tbl_childNames: UITableView!
    @IBOutlet weak var view_childMain: UIView!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    @IBOutlet weak var txt_promo: UITextField!
    
    @IBOutlet weak var adultMenu_HContraint: NSLayoutConstraint!
    @IBOutlet weak var childMenu_HContraint: NSLayoutConstraint!
    @IBOutlet weak var childMenu_YConstraint: NSLayoutConstraint!
    
    // booking info...
    @IBOutlet weak var lbl_noOfRooms: UILabel!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var lbl_roomType: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_gst: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!

    @IBOutlet weak var btn_applyPromo: CRButton!
    
    @IBOutlet weak var lbl_cancellation_till: UILabel!
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    
    var view_PromoCodeView: ToursPackageView?
    var selectedPromo: DCommonTopOfferItems?
    var countryISO_Dict: [String: String] = [:]
    var countries_array: [[String: String]] = []
    var termsBool = false
    var adult_count = 0
    var child_count = 0
    var infant_count = 0
    
    // SSR Variables...
    var isSSR: Bool = false
    var isSSRSeatSelected: Bool = false
    var SSRPaymentDict = [String: Any]()
    var  selectedRoomIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFrameAddView()
        // delegates...
        displayInformationAndDelegates()
        reloadTablesAndFrameAdjust()
//        view.backgroundColor = .appColor
        btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        
    }
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTablesAndFrameAdjust()
    }
    @IBAction func selectPromoCodeAction(_ sender: Any) {
        let result = DCommonModel.topOffer_Array.filter{ $0.module == "hotel"}
        if result.count == 0 {
            self.view.makeToast(message: "Promo Code Not available")
        } else {
            self.view_PromoCodeView?.packageType = .PromoCodes
            self.view_PromoCodeView?.promoCodeArray = result
            self.view_PromoCodeView?.displayInfo()
            self.view_PromoCodeView?.promoCodeDelegate = self
            self.view_PromoCodeView?.isHidden = false
            UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_PromoCodeView!)
        }
    
    }
    @IBAction func btnCancelPromoAction(_ sender: Any) {
        self.btn_selectPromo.isHidden = false
        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
        btn_applyPromo.setTitle("APPLY", for: .normal)
        FinalBreakupHotelModel.discount = 0.0
        self.displayBookingPriceInfo()

    }
    
    // MARK:- Helper
    func displayInformationAndDelegates() {
        
        lbl_noOfRooms.text = "\(AddRoomModel.addRooms_array.count)"
        lbl_hotelName.text = DHPreBookingModel.hotelName
        lbl_hotelAddress.text = DHPreBookingModel.hotelAddress
        lbl_roomType.text = DHPreBookingModel.roomType
        if DHTravelModel.select_room.is_refundable {
            lbl_cancellation_till.text = DHTravelModel.select_room.lastCancellationDate
        }else {
            lbl_cancellation_till.text = "Non-Refundable"
        }

        getISOCodeList()
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_adultNames.delegate = self
        tbl_adultNames.dataSource = self
        
        tbl_childNames.delegate = self
        tbl_childNames.dataSource = self
        
        // clear selection...
        clearAll_SelectedInfo()
        
        // check user login or not...
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                self.tf_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.tf_mobileNo.text = phone
            }
        }

        
        // counrty code display...
        //        let mobileISO_Dict = UserDefaults.standard.object(forKey: CTGMobile_IOS)
        //        if let final_mobileISO = mobileISO_Dict as? [String: String] {
        //            countryISO_Dict = final_mobileISO
        //            self.tf_isdCode.text = "\(String(describing: countryISO_Dict["iso"]!)) \(String(describing: countryISO_Dict["isd"]!))"
        //        }
        
        // mobile number...
        //        let mobile_no = UserDefaults.standard.object(forKey: CTGMobileNo)
        //        if let final_no = mobile_no as? String  {
        //            self.tf_mobileNo?.text = final_no
        //        }
    }
    
    func getISOCodeList() {
        
        // getting country codes...
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)

        if userProfile is [String: Any] {
            if let code = (userProfile as! [String: Any])["country_code"] as? String {
                countryISO_Dict = VKDialCodes.shared.getDialCode(country_code: "\(code)")
                displayDialCode(dailCode: countryISO_Dict)
            }
        } else {
            countryISO_Dict = VKDialCodes.shared.current_dialCode
            
            displayDialCode(dailCode: countryISO_Dict)
            
        }
//        countryISO_Dict = VKDialCodes.shared.current_dialCode
//        displayDialCode(dailCode: countryISO_Dict)
//
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    
    func displayDialCode(dailCode: [String: String]) {
        
        self.tf_isdCode.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"
    }
    
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_total.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.totalFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, FinalBreakupHotelModel.totalFare)
        lbl_gst.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.gst  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator()) //String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, FinalBreakupHotelModel.convenienceFare)
        lbl_taxFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.convenienceFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, "0.00")
        lbl_totalFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.gst + FinalBreakupHotelModel.convenienceFare) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, (FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.convenienceFare))
        lbl_discount.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.discount  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_grandFinalTotal.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.gst + FinalBreakupHotelModel.convenienceFare) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        
    }
    
    func clearAll_SelectedInfo() {
        
        // adult count...
        for i in 0 ..< DHPassengerModel.adultArray.count {
            DHPassengerModel.adultArray[i].isSelected = false
        }
        
        // child count...
        for i in 0 ..< DHPassengerModel.childArray.count {
            DHPassengerModel.childArray[i].isSelected = false
        }
    }
    
    func reloadTablesAndFrameAdjust() {
        
        // reload tables...
        tbl_adultNames.reloadData()
        tbl_childNames.reloadData()
        
        // frames adjust...
        adultMenu_HContraint.constant = CGFloat((DHPassengerModel.adultArray.count * 40) + 80)
        
        childMenu_HContraint.constant = 0
        childMenu_YConstraint.constant = 0
        view_childMain.isHidden = true
        if DHTravelModel.child_count >= 1 {
            childMenu_HContraint.constant = CGFloat((DHPassengerModel.childArray.count * 40) + 80)
            view_childMain.isHidden = false

        }
        displayMaxPassengersCounts()
    }
    
    func displayMaxPassengersCounts() {
        
        // adult count...
        adult_count = 0
        for model in DHPassengerModel.adultArray {
            if model.isSelected == true {
                adult_count = adult_count + 1
            }
        }
        
        // child count...
        child_count = 0
        for model in DHPassengerModel.childArray {
            if model.isSelected == true {
                child_count = child_count + 1
            }
        }
        
        
        // selected passenger counts...
        lbl_adultCount.text = "AD \(adult_count)/\(DHTravelModel.adult_count)"
        lbl_childCount.text = "CH \(child_count)/\(DHTravelModel.child_count)"
        
    }
    
    func moveToAddPassengerFrom(indexS: Int, editIndex: Int) {
        
        // move to add passenger form...
        let formObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "GuestFormVC") as! GuestFormVC
        formObj.delegate = self
        if indexS == 0 {
            formObj.formType = .Adult
        }
        else if indexS == 1  {
            formObj.formType = .Child
        }
        else {}
        
        // editing...
        if editIndex != -1 {
            formObj.editIndex = editIndex
        }
        self.navigationController?.pushViewController(formObj, animated: true)
    }
    
    // MARK:- PassengerButtons
    @IBAction func addAdultButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 0, editIndex: -1)
    }
    
    @IBAction func addChildrenButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 1, editIndex: -1)
    }
    
    @IBAction func addInfantButtonClicked(_ sender: UIButton) {
        moveToAddPassengerFrom(indexS: 2, editIndex: -1)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        FinalBreakupHotelModel.discount = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func promoBtnClicked(_ sender: Any) {
        aplyPromo()
    }
    func removePromo() {
        FinalBreakupHotelModel.discount  = 0.0
        self.btn_applyPromo.setTitle("APPLY", for: .normal)
        self.btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        self.txt_promo.text = nil
        self.view.makeToast(message: "Promo Code Not Valid")
        self.displayBookingPriceInfo()
    }
    func appliedPromo() {
        self.btn_applyPromo.setTitle("APPLIED", for: .normal)
        self.btn_cancelPromo.isHidden = false
        self.btn_selectPromo.isHidden = true
        self.view.makeToast(message: "Promo Code Applied Successfully")
        
        self.displayBookingPriceInfo()
    }
    
    func aplyPromo(){
        if (txt_promo.text?.isEmpty == true) {
            self.view.makeToast(message: "Please select promo code")
        } else {
            CommonLoader.shared.startLoader(in: view)

            let userId = ""
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"hotel","total_amount_val": FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.convenienceFare, "user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee":FinalBreakupHotelModel.convenienceFare,"currency": DCurrencyModel.currency_saved?.currency_country ?? "INR"]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            print(result["discount_value"] as! String)
                            let value = Float(result["discount_value"] as! String)
                            if  FinalBreakupHotelModel.totalFare <= (self.selectedPromo?.minimum_amount)! || (value! > FinalBreakupHotelModel.totalFare) {
                                FinalBreakupHotelModel.total_amount_val = 0.0//FinalBreakupHotelModel.totalFare
                                self.removePromo()
                                
                            }else {
                                FinalBreakupHotelModel.discount  = Float(result["discount_value"] as! String)!
//                                FinalBreakupHotelModel.total_amount_val = Float(result["total_amount_val"] as! String)!
                                self.appliedPromo()
                            }
                            
                        } else {
                            
                            // error message...
                            if let message_str = result["message"] as? String {
                                self.view.makeToast(message: message_str)
                            }
                        }
                    } else {
                        print("Promo code formate : \(String(describing: resultObj))")
                    }
                }
                CommonLoader.shared.stopLoader()

            }

        }
    }
    
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview?.superview
        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        fieldRect.size.width = fieldRect.size.width - fieldRect.size.width/2 + 50
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        
        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        // select count based one category...
        var adult_maxCount = 0
        var child_maxCount = 0
        
        adult_maxCount = DHTravelModel.adult_count
        child_maxCount = DHTravelModel.child_count
        
        // validations...
//        if ((adult_count == 0) || child_count != 0) {
//            messageStr = "Please select one adult"
//        } else if (child_count != 0){
//            messageStr = "Please select one child"
//        }
//        else
        if (adult_maxCount != adult_count ) {
            messageStr = "Please add all adults"
        }
        else if (child_maxCount != child_count) {
            messageStr = "Please add all children"
        }
        else if (tf_email.text?.count == 0 || tf_email.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter email id"
        }
        else if !(tf_email.text?.isValidEmailAddress())! {
            messageStr = "Please enter valid email"
        }
        else if (tf_isdCode.text?.count == 0 || tf_isdCode.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please select ISD code"
        }
        else if (tf_mobileNo.text?.count == 0 || tf_mobileNo.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter mobile number"
        }else if (!(tf_mobileNo.text?.isValidPhone())!){
            messageStr = "Please enter mobile number"
        }
        else {}
        
        // validation...
        if messageStr.count != 0 {
            
            self.view.makeToast(message: messageStr)
            
            //            // alert...
            //            let alertContorller = UIAlertController.init(title: "Alert!", message: messageStr, preferredStyle: .alert)
            //            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
            //            })
            //            alertContorller.addAction(okAction)
            //            self.present(alertContorller, animated: true, completion: nil)
        }
        else {
            
            // mobile numbers...
            let mobileNo = String(format: "%@ %@", countryISO_Dict["DialCode"]!, tf_mobileNo.text!)
            DHPassengerModel.email_id = tf_email.text!
            print(mobileNo)
            DHPassengerModel.mobile_no = mobileNo
            
            hotelPreBooking_HTTPConnection()
            
        }
        self.view.isUserInteractionEnabled = true
        
    }
    
    @IBAction func cancellation_policy_clicked(_ sender: Any) {
        var msg = DHTravelModel.select_room.cancel_policy
        msg = msg?.replacingOccurrences(of: "<br/>", with: " ") ?? ""
        
        let alert = UIAlertController(title: "Cancellation Policy",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension HotelGuestInfoVC {
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tf_mobileNo {
            return string.isValidIntergerSet()
        }
        return true
    }
    
    func dismissKeyboardMethod() {
        // resigns...
        tf_email.resignFirstResponder()
        tf_mobileNo.resignFirstResponder()
    }
}

extension HotelGuestInfoVC: UITableViewDataSource, UITableViewDelegate, hPassengerCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_adultNames {
            return DHPassengerModel.adultArray.count
        }
        else if tableView == tbl_childNames {
            return DHPassengerModel.childArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        if cell == nil {
            tableView.register(UINib(nibName: "HPassengerCell", bundle: nil), forCellReuseIdentifier: "HPassengerCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        }
        cell?.delegate = self
        
        
        // display information...
        if tableView == tbl_adultNames {
            cell?.displayPassenger_information(model: DHPassengerModel.adultArray[indexPath.row])
        }
        else if tableView == tbl_childNames {
            cell?.displayPassenger_information(model: DHPassengerModel.childArray[indexPath.row])
        }
        else {}
        
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK:- CellButtonActions
    func selectionButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // getting table...
        var tableView: UITableView?
        if let superView = cell.superview as? UITableView {
            tableView = superView
        }
        print("Table : \(String(describing: tableView))")
        
        
        // main actions...
        let indexPath = tableView? .indexPath(for: cell)
        if tableView == tbl_adultNames {
            
            // getting selection count...
            var adultCount = 0
            for model in DHPassengerModel.adultArray {
                if model.isSelected == true {
                    adultCount = adultCount + 1
                }
            }
            
            // max count...
            var adult_MaxCount = 1
            
            adult_MaxCount = DHTravelModel.adult_count
            
            // adult max count
            if (adultCount >= adult_MaxCount) && DHPassengerModel.adultArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum adult selection \(adult_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DHPassengerModel.adultArray[(indexPath?.row)!].isSelected == true {
                DHPassengerModel.adultArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DHPassengerModel.adultArray[(indexPath?.row)!].isSelected = true
            }
        }
        else if tableView == tbl_childNames {
            
            // getting selection count...
            var childCount = 0
            for model in DHPassengerModel.childArray {
                if model.isSelected == true {
                    childCount = childCount + 1
                }
            }
            
            // max count...
            var child_MaxCount = 1
            
            child_MaxCount = DHTravelModel.child_count
            
            // child max count
            if (childCount >= child_MaxCount) && DHPassengerModel.childArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum child selection \(child_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DHPassengerModel.childArray[(indexPath?.row)!].isSelected == true {
                DHPassengerModel.childArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DHPassengerModel.childArray[(indexPath?.row)!].isSelected = true
            }
        }
            
        else {}
        
        // display selection informations...
        displayMaxPassengersCounts()
        tableView?.reloadData()
    }
    
    func editButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // getting table...
        var tableView: UITableView?
        if let superView = cell.superview as? UITableView {
            tableView = superView
        }
        print("Table : \(String(describing: tableView))")
        
        
        // main actions...
        let indexPath = tableView? .indexPath(for: cell)
        if tableView == tbl_adultNames {
            moveToAddPassengerFrom(indexS: 0, editIndex: (indexPath?.row)!)
        }
        else if tableView == tbl_childNames {
            moveToAddPassengerFrom(indexS: 1, editIndex: (indexPath?.row)!)
        }
        else {}
    }
}

extension HotelGuestInfoVC: GuestFormDelegate, ISOCodeDelegate , PromoCodeDelegate {
    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
        selectedPromo = promoCode
        txt_promo.text = promoCode.promoCode
    }
    
    // MARK:- GuestFormDelegate
    func addOrUpdate_PassengersSending(Reload: Bool) {
        DispatchQueue.main.async {
            self.reloadTablesAndFrameAdjust()
        }
    }
    
    // MARK:- ISOCodeDelegate
    func countryISOCode(dial_code: [String : String]) {
        
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
}

extension HotelGuestInfoVC {
    
    // MARK:- API's

    func hotelPreBooking_HTTPConnection() {
        print(DHPassengerModel.mobile_no)
        
        let user_id = ""
        // params...
        let params:[String: Any] = ["ProvabAuthKey": DHPreBookingModel.preBookingItem?.token_key ?? "",
                                    "Email": DHPassengerModel.email_id ,
                                    "ContactNo": DHPassengerModel.mobile_no ,
                                    "AddressLine1": "E-City",
                                    "City": "Bengaluru",
                                    "PinCode": "560100",
                                    "CountryCode": "IN",
                                    "CountryName": "India",
                                    "search_id": String.init(format: "%@", DHotelSearchModel.search_id),
                                    "promo_code": txt_promo.text ?? "",
                                    "promo_code_discount_val": String.init(format: "% .2f", FinalBreakupHotelModel.discount),
                                    "final_fare": String.init(format: "% .2f", FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.gst),
                                    "tax": String.init(format: "% .2f", FinalBreakupHotelModel.gst),
                                    "convenience_fee": String.init(format: "% .2f", FinalBreakupHotelModel.convenienceFare),
                                    "customer_id": user_id.getUserId(),
                                    "payment_method": DHPreBookingModel.preBookingItem?.payment_method ?? "",
                                    "Passengers": getPassengers()]
        
        var paramString:[String: String] = [:]
        
        paramString["hotel_params"] = VKAPIs.getJSONString(object: params)
        paramString["Token"] = DHPreBookingModel.preBookingItem?.token ?? ""
        paramString["Token_key"] = DHPreBookingModel.preBookingItem?.token_key ?? ""
        paramString["wallet_bal"] = "off"
        
        moveToReviewPage(params: paramString)
        
    }
    
    func moveToReviewPage(params: [String: String]) {
        
        // move to next screen...
        let hReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "HotelReviewVC") as! HotelReviewVC
        hReviewVC.paramString = params
        self.navigationController?.pushViewController(hReviewVC, animated: false)
    }
    
    func getPassengers() -> [Any] {
        
        // adding passenger information...
        var passenger_array: [[String: String]] = []
        for model in DHPassengerModel.adultArray {
            if model.isSelected == true {
                
                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
                                                   "Pax_Type": "1",
                                                   "Title": model.title_name ?? "Mr",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth!,
                                                   "PassportNumber": "",
                                                   "PassportExpiry": "",
                                                   "PassportIssueCountry": "91",
                                                   "selection": "1"]
                passenger_array.append(passenger)
            }
        }
        
        for model in DHPassengerModel.childArray {
            if model.isSelected == true {
                
                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
                                                   "Pax_Type": "2",
                                                   "Title": model.title_name ?? "Mr",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth!,
                                                   "PassportNumber": "",
                                                   "PassportExpiry": "",
                                                   "PassportIssueCountry": "91",
                                                   "selection": "1"]
                passenger_array.append(passenger)
            }
        }
        
        passenger_array[0]["lead_passenger"] = "1"
        return passenger_array
    }
}

