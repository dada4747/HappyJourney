//
//  PassengersListVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import WebKit

class PassengersListVC: UIViewController {
    
    
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var lbl_infantCount: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    
    // passengers list elements...
    @IBOutlet weak var tbl_adultNames: UITableView!
    @IBOutlet weak var tbl_childNames: UITableView!
    @IBOutlet weak var tbl_infantNames: UITableView!
    @IBOutlet weak var view_childMain: UIView!
    @IBOutlet weak var view_infantMain: UIView!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    @IBOutlet weak var txt_promo: UITextField!
    
    @IBOutlet weak var adultMenu_HContraint: NSLayoutConstraint!
    @IBOutlet weak var childMenu_HContraint: NSLayoutConstraint!
    @IBOutlet weak var childMenu_YConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infrantMenu_YConstraint: NSLayoutConstraint!
    //
    @IBOutlet weak var infantMenu_HContraint: NSLayoutConstraint!
    var view_PromoCodeView: ToursPackageView?

    // booking info...
    @IBOutlet weak var lbl_handBaggage: UILabel!
    @IBOutlet weak var lbl_checkInBaggage: UILabel!
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_gstFare: UILabel!
    @IBOutlet weak var lbl_extraService: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    // SSR Outlets...
    @IBOutlet weak var btnSSR: UIButton!
    @IBOutlet var view_SSR: UIView!
    @IBOutlet weak var web_view_SSR: WKWebView!
    @IBOutlet weak var btn_applyPromo: CRButton!
    
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    
    @IBOutlet weak var gst_credit_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gst_credit_view: UIView!
    @IBOutlet weak var scrolle_view: UIScrollView!
    
    @IBOutlet weak var tf_gst_number: UITextField!
    @IBOutlet weak var tf_gst_name: UITextField!
    @IBOutlet weak var tf_gst_email: UITextField!
    @IBOutlet weak var tf_gst_phone: UITextField!
    @IBOutlet weak var tf_gst_address: UITextField!
    
    @IBOutlet weak var img_addgst: UIImageView!
    @IBOutlet weak var lbl_gst_state: UILabel!
    var isExpandedGst = false
    var paramString: [String: String] = [:]
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
    
    var selectedPromo: DCommonTopOfferItems?
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile) as? [String: Any] ?? [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.layer.frame.size.height -= 255

        gst_credit_view.isHidden = true
        gst_credit_HConstraint.constant = 0
        lbl_gst_state.text = DStorageModel.states.first!["name"]
        // delegates...
        addFrameAddView()

        displayInformationAndDelegates()
        reloadTablesAndFrameAdjust()
        btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        
        // getting passengers list from server...
        if (DPassengerModel.adultArray.count == 0) && (DPassengerModel.childArray.count == 0) && (DPassengerModel.infantArray.count == 0) {
            //self.getAllPassengersList()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTablesAndFrameAdjust()
    }
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    
    
    // MARK:- Helper
    func displayInformationAndDelegates() {
        
        self.view_SSR.isHidden = true
        self.view_SSR.frame = self.view.frame
        self.view.addSubview(self.view_SSR)
//        view.backgroundColor = .appColor
        getISOCodeList()
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_adultNames.delegate = self
        tbl_adultNames.dataSource = self
        
        tbl_childNames.delegate = self
        tbl_childNames.dataSource = self
        
        tbl_infantNames.delegate = self
        tbl_infantNames.dataSource = self

        // clear selection...
        clearAll_SelectedInfo()
        
        // check user login or not...
//        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
//        if userProfile is [String: Any] {
//
//            // after login...
//            if let email_id = (userProfile as! [String: Any])["email"] as? String {
//                self.tf_email.text = email_id
//            }
//        }
//
        
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
    
    func displayUserProfile() {
        
//          if profile_dict != nil {
//
//              if let email_id = profile_dict["email_id"] as? String {
//                  self.tf_email.text = email_id
//              }
//              if let iso_code = (profile_dict as! [String: Any])["country_code"] as? String {
//
//                  //phone_code
//                  self.tf_isdCode.text = String.init(format: "+%@",iso_code)
//                  countryISO_Dict =  getDialCode(country_code: iso_code)
//                  let img_iso = selected_code["ISOCode"] ?? ""
//                  img_country.image = UIImage.init(named: String.init(format: "%@.png", img_iso.lowercased()))
//              }
//              if let phone_number = (profile_dict as! [String: Any])["phone"] as? String {
//                  self.txt_phoneNumber.text = phone_number
//              }
//           }
//          else {
//               selected_code = ["DailCode": "+91",
//                                "Country": "India",
//                                 "ISOCode": "IN"]
//              displayDialCode(dailCode: selected_code)
//          }
    }
    
    func getISOCodeList() {
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
        // getting country codes...
//        countryISO_Dict = VKDialCodes.shared.current_dialCode
//        displayDialCode(dailCode: countryISO_Dict)
        
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
        lbl_baseFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( FinalBreakupModel.baseFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupModel.currency, FinalBreakupModel.baseFare)
        lbl_taxFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( FinalBreakupModel.totalTax * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String.init(format: "%@ %.2f", FinalBreakupModel.currency, FinalBreakupModel.totalTax)
        lbl_totalFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare) - FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupModel.currency, FinalBreakupModel.totalFare)
        lbl_gstFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( FinalBreakupModel.gstFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupModel.currency, FinalBreakupModel.gstFare)
        lbl_grandTotal.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( ((FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare) - FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupModel.currency, FinalBreakupModel.totalFare)
        lbl_convenienceFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( FinalBreakupModel.convenienceFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_extraService.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( 0.0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_discount.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ( FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_checkInBaggage.text = DFlightStopsModel.flightTrip_array[0].baggage
        lbl_handBaggage.text = DFlightStopsModel.flightTrip_array[0].cabin_baggage
    }
    
    
    func clearAll_SelectedInfo() {
        
        // adult count...
        for i in 0 ..< DPassengerModel.adultArray.count {
            DPassengerModel.adultArray[i].isSelected = false
        }
        
        // child count...
        for i in 0 ..< DPassengerModel.childArray.count {
            DPassengerModel.childArray[i].isSelected = false
        }
        
        // infant count...
        for i in 0 ..< DPassengerModel.infantArray.count {
            DPassengerModel.infantArray[i].isSelected = false
        }
    }
    
    func reloadTablesAndFrameAdjust() {
        
        // reload tables...
        tbl_adultNames.reloadData()
        tbl_childNames.reloadData()
        tbl_infantNames.reloadData()
        
        // frames adjust...
        adultMenu_HContraint.constant = CGFloat((DPassengerModel.adultArray.count * 40) + 146)
        
        childMenu_HContraint.constant = 0
        childMenu_YConstraint.constant = 0
        
        infantMenu_HContraint.constant = 0
        infrantMenu_YConstraint.constant = 0
        
        if DTravelModel.childCount >= 1 {
            childMenu_YConstraint.constant = 20

            childMenu_HContraint.constant = 20
            childMenu_HContraint.constant = CGFloat((DPassengerModel.childArray.count * 40) + 146)
        }
        if DTravelModel.infantCount >= 1 {
            infrantMenu_YConstraint.constant = 20
            infantMenu_HContraint.constant = CGFloat((DPassengerModel.infantArray.count * 40) + 146)
        }
        displayMaxPassengersCounts()
    }
    
    func displayMaxPassengersCounts() {
        
        // adult count...
        adult_count = 0
        for model in DPassengerModel.adultArray {
            if model.isSelected == true {
                adult_count = adult_count + 1
            }
        }
        
        // child count...
        child_count = 0
        for model in DPassengerModel.childArray {
            if model.isSelected == true {
                child_count = child_count + 1
            }
        }
        
        // infant count...
        infant_count = 0
        for model in DPassengerModel.infantArray {
            if model.isSelected == true {
                infant_count = infant_count + 1
            }
        }
        
        
        // selected passenger counts...
        lbl_adultCount.text = "AD \(adult_count)/\(DTravelModel.adultCount)"
        lbl_childCount.text = "CH \(child_count)/\(DTravelModel.childCount)"
        lbl_infantCount.text = "IN  \(infant_count)/\(DTravelModel.infantCount)"

    }
    
    func moveToAddPassengerFrom(indexS: Int, editIndex: Int) {
        
        // move to add passenger form...
        let formObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "PassengerFormVC") as! PassengerFormVC
        formObj.delegate = self
        if indexS == 0 {
            formObj.formType = .Adult
        }
        else if indexS == 1  {
            formObj.formType = .Child
        }
        else if indexS == 2 {
            formObj.formType = .Infant
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
        FinalBreakupModel.discount = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hideSSRBtnClicked(_ sender: Any) {
        
        self.view_SSR.isHidden = true
    }
    
    @IBAction func SSRSeatSelection(_ sender: UIButton) {
        
        if isSSR {
            isSSR = false
            btnSSR.setImage(UIImage.init(named: "ic_check"), for: .normal)
        }
        else {
            isSSR = true
            btnSSR.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
    }
    
    @IBAction func selectPromoAction(_ sender: Any) {
        let flightPromo = DCommonModel.topOffer_Array.filter{ $0.module == "flight"}
        if flightPromo.count == 0 {
            self.view.makeToast(message: "No Promocode available ")
        }else {
            self.view_PromoCodeView?.packageType = .PromoCodes
            self.view_PromoCodeView?.promoCodeArray = flightPromo
            self.view_PromoCodeView?.displayInfo()
            self.view_PromoCodeView?.promoCodeDelegate = self
            self.view_PromoCodeView?.isHidden = false
            UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_PromoCodeView!)

        }
//        if DCommonModel.topOffer_Array.filter(<#T##(Self.Element) -> Bool#>)

    }
    @IBAction func cancelPRomoAction(_ sender: Any) {
        self.btn_selectPromo.isHidden = false
        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
        btn_applyPromo.setTitle("APPLY", for: .normal)
        FinalBreakupModel.discount = 0.0
        self.displayBookingPriceInfo()

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
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"flight","total_amount_val":FinalBreakupModel.baseFare + FinalBreakupModel.totalTax + FinalBreakupModel.convenienceFare,"user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee":FinalBreakupModel.convenienceFare,"currency":DCurrencyModel.currency_saved?.currency_country ?? "INR"]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]
            
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response data...
                            print(result["discount_value"] as! String)
                            let value = Float(result["discount_value"] as! String)

                            if  FinalBreakupModel.totalFare <= (self.selectedPromo?.minimum_amount)! || (value! > FinalBreakupModel.totalFare) {
                                self.removePromo()
                                
                            }else {
                                FinalBreakupModel.discount  = Float(result["discount_value"] as! String)!
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
    func isValidGST(testStr:String) -> Bool {
        
        return testStr.range(of: "[ !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+", options: .regularExpression) != nil
    }
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        
        self.view.isUserInteractionEnabled = false
        
        // form validations...
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""
        
        // select count based one category...
        var adult_maxCount = 0
        var child_maxCount = 0
        
        adult_maxCount = DTravelModel.adultCount
        child_maxCount = DTravelModel.childCount

        // validations...
//        if ((adult_count != 1 || child_count != 0)) {
//            messageStr = "Please select only one adult"
//        }
//        else
        if isExpandedGst == true {
            if (tf_gst_phone.text?.count == 0 || tf_gst_phone.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter mobile number"
            }else if !((tf_gst_phone.text?.isValidPhone())!) {
                messageStr = "Please enter valide mobile number for GST"
            }else if (tf_gst_email.text?.count == 0 || tf_gst_email.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter email id for GST"
            }
            else if !(tf_gst_email.text?.isValidEmailAddress())! {
                messageStr = "Please enter valid email for GST"
            }
            else if !(tf_gst_name.text?.isValidInput())! {
                messageStr = "Please enter valid Company Name"
            } else if isValidGST(testStr: tf_gst_number.text!) {
                messageStr = "Please enter valid GST Number"
            }else if (tf_gst_address.text?.count == 0 || tf_gst_address.text?.trimmingCharacters(in: whitespace).count == 0) {
                messageStr = "Please enter address "
            }
        }else {
            tf_gst_phone.text = ""
            tf_gst_email.text = ""
            tf_gst_name.text = ""
            tf_gst_address.text = ""

        }
        if (adult_maxCount != adult_count ) {
            messageStr = "Please add all adults"
        }
        else if (child_maxCount != child_count) {
            messageStr = "Please add all children"
        }
        else if (DTravelModel.infantCount != infant_count) {
            messageStr = "Please add all infants"
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
        }else if !((tf_mobileNo.text?.isValidPhone())!) {
            messageStr = "Please enter mobile number"
        }
//        else if termsBool == false {
//            messageStr = "Please acccept terms and conditions"
//        }
        else {
        
            // flight is international..
            if (DFlightSearchModel.is_domestic == false) {
                
                // infant passport information...
                for model in DPassengerModel.infantArray {
                    if model.isSelected == true {
                        
                        if model.passport_no == nil  {
                            messageStr = String(format: "%@ %@ (Infant) passport information not available", model.first_name!, model.last_name!)
                            break
                        }
                        else if model.passport_expiry != nil {
                            
                            let passport_expDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: model.passport_expiry!)
                            if (DTravelModel.departDate.compare(passport_expDate) == .orderedDescending) {
                                
                                messageStr = String(format: "Hi %@ %@ (Infant), \nyour passport going to expire before your journey.", model.first_name!, model.last_name!)
                                break
                            }
                        }
                        else {}
                    }
                }
                
                // child passport information...
                for model in DPassengerModel.childArray {
                    if model.isSelected == true {
                        
                        if model.passport_no == nil  {
                            messageStr = String(format: "%@ %@ (Child) passport information not available", model.first_name!, model.last_name!)
                            break
                        }
                        else if model.passport_expiry != nil {
                            
                            let passport_expDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: model.passport_expiry!)
                            if (DTravelModel.departDate.compare(passport_expDate) == .orderedDescending) {
                                
                                messageStr = String(format: "Hi %@ %@ (Child), \nyour passport going to expire before your journey.", model.first_name!, model.last_name!)
                                break
                            }
                        }
                        else {}
                    }
                }
                
                // adult passport information...
                for model in DPassengerModel.adultArray {
                    if model.isSelected == true {
                        
                        if model.passport_no == nil  {
                            messageStr = String(format: "%@ %@ (Adult) passport information not available", model.first_name!, model.last_name!)
                            break
                        }
                        else if model.passport_expiry != nil {
                            
                            
                            let passport_expDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: model.passport_expiry!)
                            print(DTravelModel.departDate)
                            print(passport_expDate)
                            if (DTravelModel.departDate.compare(passport_expDate) == .orderedDescending) {
                                
                                messageStr = String(format: "Hi %@ %@ (Adult), \nyour passport going to expire before your journey.", model.first_name!, model.last_name!)
                                break
                            }
                        }
                        else {}
                    }
                }
            }
        }
        
        // validation...
        if messageStr.count != 0 {
            //self.view.makeToast(message: messageStr)
            
            // alert...
            let alertContorller = UIAlertController.init(title: "Alert!", message: messageStr, preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
            })
            alertContorller.addAction(okAction)
            self.present(alertContorller, animated: true, completion: nil)
        }
        else {
            
            // mobile numbers...
            var mobileNo = String(format: "%@ %@", countryISO_Dict["DialCode"]!, tf_mobileNo.text!)
            //mobileNo = mobileNo.replacingOccurrences(of: "+", with: "")
            DPassengerModel.email_id = tf_email.text!
            DPassengerModel.mobile_no = mobileNo
            
            // store old information...
//            UserDefaults.standard.set(countryISO_Dict, forKey: CTGMobile_IOS)
//            UserDefaults.standard.set(tf_mobileNo.text!, forKey: CTGMobileNo)
            
            flightPreBooking_HTTPConnection()
            
             // move to flight review screen...
//            let vc = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightReviewVC") as! FlightReviewVC
//            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.view.isUserInteractionEnabled = true
 
    }
    @IBAction func expand_gst_option(_ sender: Any) {
        if isExpandedGst == false {
            img_addgst.image = UIImage(named: "ic_minus1")
            isExpandedGst = true
            gst_credit_view.isHidden = false
            gst_credit_HConstraint.constant = 270
            var contentInset:UIEdgeInsets = self.scrolle_view.contentInset
//            contentInset.bottom = 270
            scrolle_view.contentInset = contentInset
        }else {
            img_addgst.image = UIImage(named: "ic_plus1")
            isExpandedGst = false
            gst_credit_HConstraint.constant = 0
            gst_credit_view.isHidden = true
            var contentInset:UIEdgeInsets = self.scrolle_view.contentInset
//            contentInset.bottom -= 270
            scrolle_view.contentInset = contentInset
        }

    }
    
    @IBAction func selectGSTStateAction(_ sender: UIButton) {
        let parent_view = sender.superview
        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        fieldRect.size.width = fieldRect.size.width
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_stateArray = self
        tbl_popView.DType = .State
        tbl_popView.state_array = DStorageModel.states
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
}

extension PassengersListVC : PromoCodeDelegate , StateDelegates {
    func selectedState(state: [String : String]) {
        print(state)
        lbl_gst_state.text = state["name"]
    }
    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
        selectedPromo = promoCode
        txt_promo.text = promoCode.promoCode
    }
    
    
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

extension PassengersListVC: UITableViewDataSource, UITableViewDelegate, passengerCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_adultNames {
            return DPassengerModel.adultArray.count
        }
        else if tableView == tbl_childNames {
            return DPassengerModel.childArray.count
        }
        else if tableView == tbl_infantNames {
            return DPassengerModel.infantArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
        if cell == nil {
            tableView.register(UINib(nibName: "PassengerCell", bundle: nil), forCellReuseIdentifier: "PassengerCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
        }
        cell?.delegate = self
        
        
        // display information...
        if tableView == tbl_adultNames {
            cell?.displayPassenger_information(model: DPassengerModel.adultArray[indexPath.row])
        }
        else if tableView == tbl_childNames {
            cell?.displayPassenger_information(model: DPassengerModel.childArray[indexPath.row])
        }
        else if tableView == tbl_infantNames {
            cell?.displayPassenger_information(model: DPassengerModel.infantArray[indexPath.row])
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
            for model in DPassengerModel.adultArray {
                if model.isSelected == true {
                    adultCount = adultCount + 1
                }
            }
            
            // max count...
            var adult_MaxCount = 1
            
            adult_MaxCount = DTravelModel.adultCount
            
//            if comingType == .Flights {
//                adult_MaxCount = DTravelModel.adultCount
//            }
//            else if comingType == .Hotels {
//                adult_MaxCount = DHTravelModel.adult_count
//            }
//            else {}
            
            // adult max count
            if (adultCount >= adult_MaxCount) && DPassengerModel.adultArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum adult selection \(adult_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DPassengerModel.adultArray[(indexPath?.row)!].isSelected == true {
                DPassengerModel.adultArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DPassengerModel.adultArray[(indexPath?.row)!].isSelected = true
            }
        }
        else if tableView == tbl_childNames {
            
            // getting selection count...
            var childCount = 0
            for model in DPassengerModel.childArray {
                if model.isSelected == true {
                    childCount = childCount + 1
                }
            }
            
            // max count...
            var child_MaxCount = 1
            
            child_MaxCount = DTravelModel.childCount
//            if comingType == .Flights {
//                child_MaxCount = DTravelModel.childCount
//            }
//            else if comingType == .Hotels {
//                child_MaxCount = DHTravelModel.child_count
//            }
//            else {}
            
            
            // child max count
            if (childCount >= child_MaxCount) && DPassengerModel.childArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum child selection \(child_MaxCount) only")
                return
            }
            
            // replace selection element...
            if DPassengerModel.childArray[(indexPath?.row)!].isSelected == true {
                DPassengerModel.childArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DPassengerModel.childArray[(indexPath?.row)!].isSelected = true
            }
        }
        else if tableView == tbl_infantNames {
            
            // getting selection count...
            var infantCount = 0
            for model in DPassengerModel.infantArray {
                if model.isSelected == true {
                    infantCount = infantCount + 1
                }
            }
            
            // infant max count
            if (infantCount >= DTravelModel.infantCount) && DPassengerModel.infantArray[(indexPath?.row)!].isSelected == false {
                self.view.makeToast(message: "Maximum infant selection \(DTravelModel.infantCount) only")
                return
            }
            
            // replace selection element...
            if DPassengerModel.infantArray[(indexPath?.row)!].isSelected == true {
                DPassengerModel.infantArray[(indexPath?.row)!].isSelected = false
            }
            else {
                DPassengerModel.infantArray[(indexPath?.row)!].isSelected = true
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
        else if tableView == tbl_infantNames {
            moveToAddPassengerFrom(indexS: 2, editIndex: (indexPath?.row)!)
        }
        else {}
    }
}

extension PassengersListVC: PassengerFormDelegate, ISOCodeDelegate {
    
    // MARK:- PassengerFormDelegate
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

extension PassengersListVC {

    // MARK:- API's
    func flightPreBooking_HTTPConnection() {

        let user_id = ""

        // params...
        let params:[String: Any] =
        [ "token_key": DFlightStopsModel.preBookingItem?.token_key! ?? "",// "bd34e11898f8ce4fc82a5fab60ddbf32",
                "Email": DPassengerModel.email_id,//"vanitha.provab@gmail.com",
                "ContactNo": tf_mobileNo.text ?? "",//"9960077482",// DPassengerModel.mobile_no,//"7795889630",
                "AddressLine1":"E-city",
                "City":"banglore",
                "PinCode":"4456666",
                "CountryCode":"IN",
                "CountryName":"India",
                "search_id": DFlightSearchModel.search_id,//"2510",
                "total_amount_val": String.init(format: "%.2f", FinalBreakupModel.totalFare),//"72.00",
                "currency": DCurrencyModel.currency_saved?.currency_country ?? "USD",
                "currency_symbol":  DCurrencyModel.currency_saved?.currency_symbol ?? "$",//"$"
                "convenience_fee": String.init(format: "%.2f", FinalBreakupModel.convenienceFare),//"0.00",
                "tax": String.init(format: "% .2f", FinalBreakupModel.gstFare),
                "promo_code_discount_val": String.init(format: "%.2f", FinalBreakupModel.discount),//"0.00",
                "promo_code": txt_promo.text ?? "",
                "customer_id": user_id.getUserId(),//"1297",
                "payment_method":"PNHB1",
                "Passengers":getPassengers(),
              "gst_number": tf_gst_number.text ?? "",
              "gst_company_name": tf_gst_name.text ?? "",
              "gst_email": tf_gst_email.text ?? "",
              "gst_phone":tf_gst_phone.text ?? "",
              "gst_address": tf_gst_address.text ?? "",
              "gst_state": lbl_gst_state.text ?? "",
            ]



        let param_tokens:[String: Any] = ["flight_token_table_id": DFlightStopsModel.preBookingItem?.flight_token_table_id ?? ""]

        //var paramString:[String: String] = [:]

        paramString["token"] = VKAPIs.getJSONString(object: param_tokens)
        paramString["flight_book"] = VKAPIs.getJSONString(object: params)
        paramString["search_ssr_hash"] =  DFlightStopsModel.preBookingItem?.search_hash ?? ""
        paramString["wallet_bal"] = VKAPIs.getJSONString(object: "off")

        if isSSR && !isSSRSeatSelected {

            paramString["booking_step"] = "additional_ssr"

            //DTravelModel.isPaymemt = true

            // seat selection webview load here...
            let data = VKAPIs.shared.getDatafrom(params: paramString)
            let urlStr = String.init(format: "%@/%@",TMX_Base_URL, FLIGHT_PreBooking)
            print("Url: \(urlStr)")
            let url = URL(string: urlStr)!
            let request = VKAPIsClient().getRequestFormdata(url: url, httpMethod: .POST, httpBody: data)//.getRequestXwwwform(url: url!, httpMethod: .POST, httpBody: data)

            // load url request...
            self.view_SSR.isHidden = false
            self.web_view_SSR.navigationDelegate = self
            web_view_SSR.load(request)
            return
        }
        else {

            paramString["booking_step"] = VKAPIs.getJSONString(object: "book")
            moveToReviewPage(params: paramString)
        }
    }

     // MARK:- Utilities
    func successMovements(info: [String: Any]) {

        self.SSRPaymentDict = info

        if let ssrDict = info["data"] as? [String: Any] {

            FinalBreakupModel.extraServicecharge = Float(String.init(describing: ssrDict["extra_services_total_price"]!))!
        }
//        moveToReviewPage(params: params)
    }

    func moveToReviewPage(params: [String: String]) {

        // move to next screen...
        let fReviewVC = self.storyboard?.instantiateViewController(withIdentifier: "FlightReviewVC") as! FlightReviewVC
        fReviewVC.paramString = params
        //fReviewVC.SSRPaymentDict = SSRPaymentDict
        //fReviewVC.isSSR = isSSR
        self.navigationController?.pushViewController(fReviewVC, animated: false)
    }

    func getPassengers() -> [Any] {

        // adding passenger information...
        var passenger_array: [[String: String]] = []
        for model in DPassengerModel.adultArray {
            if model.isSelected == true {

                let passenger: [String: String] =

                    ["Gender": model.gender_value ?? "1",
                                                   "lead_passenger": "0",
                                                   "passenger_type": model.person_type,
                                                   "Title": model.title_value ?? "1",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth!,
                                                   "PassportNumber": model.passport_no ?? "",
                                                   "PassportExpiry": model.passport_expiry ?? "",
                                                   "PassportIssueCountry": "91",
                     "selection": "1"]
                passenger_array.append(passenger)
            }
        }

        for model in DPassengerModel.childArray {
            if model.isSelected == true {

                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
                                                   "lead_passenger": "0",
                                                   "passenger_type": model.person_type,
                                                   "Title": model.title_value ?? "1",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth!,
                                                   "PassportNumber": model.passport_no ?? "",
                                                   "PassportExpiry": model.passport_expiry ?? "",
                                                   "PassportIssueCountry": "91",
                                                   "selection": "1"]
                passenger_array.append(passenger)
            }
        }

        for model in DPassengerModel.infantArray {
            if model.isSelected == true {

                let passenger: [String: String] = ["Gender": model.gender_value ?? "1",
                                                   "lead_passenger": "0",
                                                   "passenger_type": model.person_type,
                                                   "Title": model.title_value ?? "1",
                                                   "FirstName": model.first_name!,
                                                   "LastName": model.last_name!,
                                                   "DateOfBirth": model.dateOf_birth!,
                                                   "PassportNumber": model.passport_no ?? "",
                                                   "PassportExpiry": model.passport_expiry ?? "",
                                                   "PassportIssueCountry": "91",
                                                   "selection": "1"]
                passenger_array.append(passenger)
            }
        }
        passenger_array[0]["lead_passenger"] = "1"
        return passenger_array
    }
}


extension PassengersListVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        CommonLoader.shared.startLoader(in: view)
        print("Strat to load")

    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
        CommonLoader.shared.stopLoader()
        webView.evaluateJavaScript("document.body.innerHTML")
        { [weak self](result, error) in
            
            if error != nil {
                print("Web error : \(String(describing: error?.localizedDescription))")
            }
            else {
                print("web result : \(String(describing: result))")
                if result != nil {
                    if let responseString = result as? String {
                        if let data = responseString.data(using: String.Encoding.utf8) {
                            do {
                                let result_obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                self?.view_SSR.isHidden = true
                                if let result_dict = result_obj as? [String: Any] {
                                    if result_dict["status"] as? Bool == true {
                                        print("Success : \(result_dict)")
                                        self?.successMovements(info: result_dict)
                                    }
                                    else {
                                        self?.paramString["booking_step"] = "book"
                                        print("Failure : \(result_dict)")
                                    }
                                    
                                }
                                print(result_obj)
                            }
                            catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                }
            }
        }
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CommonLoader.shared.stopLoader()
        print("webView loading - didFail")
    }
}
