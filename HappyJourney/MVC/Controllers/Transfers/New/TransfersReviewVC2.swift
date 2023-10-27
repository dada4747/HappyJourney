//
//  TransfersReviewVC2.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 25/08/21.
//

import UIKit

class TransfersReviewVC2: UIViewController {
    @IBOutlet weak var contactInfo_popup: UIView!
    @IBOutlet weak var travellerInfo_popup: UIView!
    @IBOutlet weak var lbl_header_travellerInfo_popup: UILabel!

    @IBOutlet weak var btn_male: GradientButton!
    @IBOutlet weak var btn_female: GradientButton!
    
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_mobileNo: UITextField!
    @IBOutlet weak var tf_isdCode: UITextField!
    @IBOutlet weak var txt_hotel: UITextField!

    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_mobileNo: UILabel!
    @IBOutlet weak var txt_promocode: UITextField!

    @IBOutlet weak var lbl_price_bottom: UILabel!
    @IBOutlet weak var lbl_travellersCount_bottom: UILabel!
    @IBOutlet weak var lbl_travellerName: UILabel!

    // date pickers...
    @IBOutlet weak var datePicker_MainView: UIView!
    @IBOutlet weak var datePicker_View: UIDatePicker!
    
    @IBOutlet weak var view_tracellers_Before: UIView!
    @IBOutlet weak var view_tracellers_After: UIView!

    ///Fare breakup
        @IBOutlet weak var view_fareBreakup: UIView!
        @IBOutlet weak var lbl_baseFare_Breakup: UILabel!
        @IBOutlet weak var lbl_totalTax_Breakup: UILabel!
        @IBOutlet weak var lbl_convienceFee_Breakup: UILabel!
        @IBOutlet weak var lbl_totalFare_Breakup: UILabel!
    
    @IBOutlet weak var firstName_TF: UITextField!
    @IBOutlet weak var lastName_TF: UITextField!
    @IBOutlet weak var DOB_TF: UITextField!
    
    
    
    var genderIndex = 0
    var title_value = "1"

    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = [:]
    var passengerModel: DPassengerItem?

    var seletedPromoCode: [String: Any] = [:]
    var firstName = ""
    var lastName = ""
    
    @IBOutlet weak var img_dropHotels: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tf_mobileNo.keyboardType = .numberPad // For integers
        tf_mobileNo.delegate = self
        self.contactInfo_popup.frame = self.view.frame
        self.view.addSubview(contactInfo_popup)
        contactInfo_popup.alpha = 0
        
        self.travellerInfo_popup.frame = self.view.frame
        self.view.addSubview(travellerInfo_popup)
        travellerInfo_popup.alpha = 0
                
        self.view_fareBreakup.isHidden = true
        self.view_fareBreakup.frame = self.view.frame
        self.view.addSubview(self.view_fareBreakup)
        
        view_tracellers_Before.alpha = 1
        view_tracellers_After.alpha = 0
        
//        var attributedText = NSMutableAttributedString(string: "Important : enter your name Your ticket and flights information will be Sent here  is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it ", attributes: [NSAttributedString.Key.font: UIFont(name: "Aeonik-Regular", size: 13)])
//
//        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:11))
        if DBlockTripsModel.pre_booking_params?.HotelPickup == true {
            txt_hotel.placeholder = "Hotel Name"
            img_dropHotels.isHidden = false
        }else {
            txt_hotel.placeholder = "Hotel Pickup Not Available"
            img_dropHotels.isHidden = true
        }
        lbl_header_travellerInfo_popup.text = ""//Important : enter your name Your ticket and flights information will be Sent here  is simply dummy text of the printing and typesetting industry. LoremIpsum has been the industry’s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it"
        initGenderView()
        initFareBreakup()
        getISOCodeList()
        initContactInfoView()
    }
    
    func initGenderView(){
        if genderIndex == 0{
            btn_male.startColor = UIColor.secInteraciaBlue
            btn_male.endColor = UIColor.primInteraciaPink
//            btn_male.backgroundColor = UIColor(red: 19/255, green: 25/255, blue: 59/255, alpha: 1.0)
//            btn_female.backgroundColor = UIColor(red: 221/255, green: 222/255, blue: 223/255, alpha: 1.0)
            btn_female.startColor = UIColor(red: 221/255, green: 222/255, blue: 223/255, alpha: 1.0)
            btn_female.endColor = UIColor(red: 221/255, green: 222/255, blue: 223/255, alpha: 1.0)
            btn_male.setTitleColor(UIColor.white, for: .normal)
            btn_female.setTitleColor(UIColor.black, for: .normal)
            
            btn_female.imageView?.isHidden = true
            btn_male.imageView?.isHidden = false
        }else{
            btn_male.startColor = UIColor(red: 221/255, green: 222/255, blue: 223/255, alpha: 1.0)
            btn_male.endColor = UIColor(red: 221/255, green: 222/255, blue: 223/255, alpha: 1.0)
            btn_female.startColor = UIColor.secInteraciaBlue
            btn_female.endColor = UIColor.primInteraciaPink
            
            btn_male.setTitleColor(UIColor.black, for: .normal)
            btn_female.setTitleColor(UIColor.white, for: .normal)
            
            btn_male.imageView?.isHidden = true
            btn_female.imageView?.isHidden = false
            
        }
    }
    
    func initFareBreakup(){
        if let model = DBlockTripsModel.pre_booking_params{
//            if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                let value =  currencyConversion["value"] as? String
//
//
//                let multipliedValue1 = (DBlockTripsModel.total_price ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//                let multipliedValue3 = (model.taxes ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//                let multipliedValue4 = (DBlockTripsModel.convenience_fees ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//
//
//
//                self.lbl_baseFare_Breakup.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//                self.lbl_totalTax_Breakup.text = symbol + " " + String(format: "%.2f", multipliedValue3)
//                self.lbl_convienceFee_Breakup.text = symbol + " " + String(format: "%.2f", multipliedValue4)
//
//
//
//                self.lbl_totalFare_Breakup.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//
//                self.lbl_price_bottom.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//
//            }
//
            self.lbl_baseFare_Breakup.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(DBlockTripsModel.total_price!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//symbol + " " + String(format: "%.2f", multipliedValue1)
            self.lbl_totalTax_Breakup.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model.taxes) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//symbol + " " + String(format: "%.2f", multipliedValue3)
            self.lbl_convienceFee_Breakup.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(DBlockTripsModel.convenience_fees!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// symbol + " " + String(format: "%.2f", multipliedValue4)

            
            
            self.lbl_totalFare_Breakup.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(DBlockTripsModel.total_price!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// symbol + " " + String(format: "%.2f", multipliedValue1)
            
            self.lbl_price_bottom.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(DBlockTripsModel.total_price!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator()) // symbol + " " + String(format: "%.2f", multipliedValue1)
            
            
        }
    }
    
    func initContactInfoView(){
        let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile) as? [String: Any]
        if profile_dict != nil {
            self.lbl_email.text = profile_dict?["email_id"] as? String ?? ""
            self.lbl_mobileNo.text = profile_dict?["phone"] as? String ?? ""
            ///in popup
            self.tf_email.text = profile_dict?["email_id"] as? String ?? ""
            self.tf_mobileNo.text = profile_dict?["phone"] as? String ?? ""

        }
    }
    
    func openTravellersPopup(){
        self.travellerInfo_popup.alpha = 1
        self.datePicker_MainView.alpha = 0
    }
    
    func closeTravellersPopup(){
        self.travellerInfo_popup.alpha = 0
    }
    
    // MARK:- Helper
    func getISOCodeList() {
        
        // getting country codes...
        countryISO_Dict = VKDialCodes.shared.current_dialCode
        displayDialCode(dailCode: countryISO_Dict)
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    
    
    func displayDialCode(dailCode: [String: String]) {
        self.tf_isdCode.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"
    }
    
    func validatePromoCodeAPICall(obj: [String: Any]){
        let user_id = ""
        var dict = ["module":"Transfer","promo_code":obj["promo_code"] as? String ?? "","convenience_fee":"","email":"","user_id":user_id.getUserId(),"currency":"SAR","total_amount_val":obj["value"] as? String ?? ""]
        let jsonString = VKAPIs.getJSONString(object: dict)
        let params: [String: Any] = ["get_promo": jsonString]
        // calling api...
        SwiftLoader.show(animated: true)

        VKAPIs.shared.getRequestFormdata(params: nil, file: validatePromoCode, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("validatePromoCode Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let data = result_dict["data"] as? [[String: Any]]{
                        
                    }
                } else {
                    print("validatePromoCode Response: formate : \(String(describing: resultObj))")
                }
            } else {
                print("validatePromoCode Response error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            SwiftLoader.hide()
        }
    }
    
    func preBookingAPIConnection(){
        
        let user_id = ""
        // params...
        var params:[String: Any] = ["BlockTourId": DBlockTripsModel.pre_booking_params?.BlockTourId,
                                    "token": DBlockTripsModel.token ,
                                    "token_key": DBlockTripsModel.token_key,
                                    "op": "book_flight",
                                    "promo_code_discount_val": "0.0",
                                    "promo_code": "",
                                    "promo_actual_value": "",
                                    "code": "",
                                    "module_type": DBlockTripsModel.module_value,
                                    "customer_id": user_id.getUserId(),
                                    "total_amount_val": String.init(format: "% .2f", DBlockTripsModel.total_price ?? 0.0),
                                    //"convenience_fee": String.init(format: "% .2f", DBlockTripsModel.convenience_fees ?? 0.0),
                                    //"convenience_fee": "0",
                                    "convenience_fee": String.init(format: "% .2f", DBlockTripsModel.convenience_fees ?? 0.0),
                                    "currency_symbol": "$",
                                    "currency": "USD",
                                    "billing_country": "92",
                                    "billing_city": "bangalore",
                                    "billing_zipcode": "560037",
                                    "billing_address_1": "bangalore E-city",
                                    "country_code": "IN",
                                    "passenger_contact": lbl_mobileNo.text ?? "",
                                    "billing_email": lbl_email.text ?? "",
                                    "tc": "on",
                                    "payment_method": "PNHB1",
                                    "hotel_pickup_list_name": txt_hotel.text ?? "",
                                    "passenger_type": ["1"],
                                    "lead_passenger": ["1"],
                                    "name_title": [title_value],
                                    "first_name": [firstName],
                                    "last_name": [lastName],
                                    "booking_source": DBlockTripsModel.booking_source
                                    
        ]
        ///booking questions
//        var questionsIds = [String]()
//        var answers = [String]()
//
//        for model in DBlockTripsModel.pre_booking_params?.bookingQuestionsList ?? [] {
//            questionsIds.append(String(model.questionId ?? 0))
//            answers.append(model.answerEntered ?? "")
//        }
//        params["question_Id"] = questionsIds
//        params["question"] = answers
        
//        "question_Id": [
//                 [14],
//                 [9],
//                 [10],
//                 [15]
//             ],
//             "question": "[Test]"
        
        var questionsIds = [Any]()
        for model in DBlockTripsModel.pre_booking_params?.bookingQuestionsList ?? [] {
            let value = [model.questionId ?? 0]
            questionsIds.append(value)
        }
        params["question_Id"] = questionsIds
        params["question"] = "[Test]"
        
        var paramString:[String: String] = [:]
        
        paramString["booking_params"] = VKAPIs.getJSONString(object: params)
        paramString["wallet_bal"] = "off"
//        SwiftLoader.show(animated: true)
        CommonLoader.shared.startLoader(in: view)

        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: TRANSFER_Pre_Booking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("TRANSFER_Pre_Booking success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            
                            // move to payment...
                            let pay_vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarPaymentVC") as! CarPaymentVC
                            pay_vc.payment_url = data_dict["return_url"] as? String
                            self.navigationController?.pushViewController(pay_vc, animated: true)
                        }
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("TRANSFER_Pre_Booking formate : \(String(describing: resultObj))")
                }
            } else {
                print("TRANSFER_Pre_Booking error : \(String(describing: error?.localizedDescription))")
            }
            SwiftLoader.hide()
            CommonLoader.shared.stopLoader()
        }
        
    }
    
    //MARK:- Actions
    
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func contactInfo_Clicked(_ sender: Any) {
        self.contactInfo_popup.alpha = 1
    }
    @IBAction func fareBreakup_Clicked(_ sender: Any) {
        self.view_fareBreakup.isHidden = false
    }
    @IBAction func fareBreakup_Back_Clicked(_ sender: Any) {
        self.view_fareBreakup.isHidden = true
    }
    @IBAction func addTraveller_Clicked(_ sender: Any) {
        openTravellersPopup()
    }
    @IBAction func editTraveller_Clicked(_ sender: Any) {
        openTravellersPopup()
    }
    @IBAction func confirm_contactInfo_Clicked(_ sender: Any) {
        self.contactInfo_popup.alpha = 0
        
        lbl_email.text = tf_email.text
        lbl_mobileNo.text = tf_mobileNo.text
    }
    
    @IBAction func confirm_addTravellerInfo_Clicked(_ sender: Any) {
        if firstName_TF.text == "" || lastName_TF.text == "" {
            self.view.makeToast(message: "Please enter Traveller Details")

        }else if DOB_TF.text == ""  {
            self.view.makeToast(message: "Please enter Date Of Birth")
        } else {
            closeTravellersPopup()
            view_tracellers_Before.alpha = 0
            view_tracellers_After.alpha = 1
            
            firstName = firstName_TF.text ?? ""
            lastName = lastName_TF.text ?? ""
            var title_name = "Mr"
            if title_value == "1" {
                title_name = "Mr"
            }else {
                title_name = "Ms"
            }
            lbl_travellerName.text = title_name + " " + firstName + " " + lastName
        }
    }
    
    @IBAction func male_Clicked(_ sender: Any) {
        genderIndex = 0
        title_value = "1"
        initGenderView()
        
    }
    @IBAction func female_Clicked(_ sender: Any) {
        genderIndex = 1
        title_value = "2"
        initGenderView()
    }
    
    @IBAction func dateOfBirthAndExpireDatesButtonsClicked(_ sender: UIButton) {
        
        datePicker_View.minimumDate = nil
        datePicker_View.maximumDate = NSDate() as Date
        
        dismissKeyboardMethod()
        self.datePicker_MainView.alpha = 1
    }
    
    @IBAction func promoCodePopupClicked(_ sender: UIButton) {
        let vc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "PromoCodesViewController") as! PromoCodesViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func applyPromoCodeClicked(_ sender: UIButton) {
        self.validatePromoCodeAPICall(obj: seletedPromoCode)
    }
    
    
    @IBAction func hotelListBtnClicked(_ sender: UIButton) {
        
        if DBlockTripsModel.pre_booking_params?.HotelPickup == true {
            // getting current position...
            let parent_view = sender.superview
            let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
            
            // table pop view...
            let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
            tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            tbl_popView.delegate_Custom = self
            tbl_popView.DType = .Custom
            let filteredArr = DBlockTripsModel.pre_booking_params?.hotelsList.map {$0.hotel_name}
            tbl_popView.customArray = filteredArr ?? []
            tbl_popView.changeMainView_Frame(rect: fieldRect)
            self.view.addSubview(tbl_popView)
        }else{
            txt_hotel.placeholder = "Hotel Pickup Not Available"

        }
     
        
    }
    
    @IBAction func issuingCountryButtonClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    // MARK:- PickerButtons
    @IBAction func hiddenDatePicker_ButtonClicked(_ sender: UIButton) {
        self.datePicker_MainView.alpha = 0
    }
    
    @IBAction func pickerCancelAndDone_ButtonClicked(_ sender: UIButton) {
        
        // done button aciton
        
        DOB_TF.text = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                  date: self.datePicker_View.date)
        
        self.datePicker_MainView.alpha = 0
    }
    @IBAction func preBooking_ButtonClicked(_ sender: UIButton) {
        if firstName == "" {
            self.view.makeToast(message: "Please enter Traveller Details")
            return
        }else if lbl_email.text == ""{
            self.view.makeToast(message: "Please enter email")
            return
        }else if lbl_mobileNo.text == ""{
            self.view.makeToast(message: "Please enter mobile number")
            return
        }
        preBookingAPIConnection()
    }
}
// MARK:- UITextFieldDelegate
extension TransfersReviewVC2: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tf_mobileNo {
            let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
        }else{
            return true
        }
    }
        
    func dismissKeyboardMethod() {
        
        // resigns...
        firstName_TF.resignFirstResponder()
        lastName_TF.resignFirstResponder()
    }
}

extension TransfersReviewVC2: PromoCodeSelection{
    func promocodeSelected(obj: [String : Any]) {
        self.seletedPromoCode = obj
        self.txt_promocode.text = obj["promo_code"] as? String ?? ""
    }
    
    
}
// MARK:- CustomDelegate
extension TransfersReviewVC2: CustomDelegate {
    func CustomListDropDownSelection(selected_Str: String, selectedIndex: Int) {
        print(selected_Str)
        self.txt_hotel.text = selected_Str

    }
}
// MARK:- ISOCodeDelegate
extension TransfersReviewVC2: ISOCodeDelegate {
    
    func countryISOCode(dial_code: [String : String]) {
        
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
}
