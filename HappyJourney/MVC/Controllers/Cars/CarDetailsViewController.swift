//
//  CarDetailsViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 13/07/21.
//

import UIKit

class CarDetailsViewController: UIViewController {
    @IBOutlet weak var tbl_openingHours: UITableView!
    
    @IBOutlet weak var view_payOnPickup: UIView!
    @IBOutlet weak var tbl_payOnPickup: UITableView!
    @IBOutlet weak var hei_payOnPickupTableView: NSLayoutConstraint!

    
    @IBOutlet weak var hei_openingHoursTableView: NSLayoutConstraint!
    @IBOutlet weak var hei_locationSubView: NSLayoutConstraint!
    @IBOutlet weak var hei_locationMainView: NSLayoutConstraint!
    ///Pickup
    @IBOutlet weak var lbl_pick_name: UILabel!
    @IBOutlet weak var lbl_pick_StreetNmbr: UILabel!
    @IBOutlet weak var lbl_pick_CityName: UILabel!
    @IBOutlet weak var lbl_pick_PostalCode: UILabel!
    @IBOutlet weak var lbl_pick_CountryName: UILabel!
    @IBOutlet weak var lbl_pick_Telephone: UILabel!
    @IBOutlet weak var lbl_pick_DateTime: UILabel!
    
    ///Drop
    @IBOutlet weak var lbl_drop_name: UILabel!
    @IBOutlet weak var lbl_drop_StreetNmbr: UILabel!
    @IBOutlet weak var lbl_drop_CityName: UILabel!
    @IBOutlet weak var lbl_drop_PostalCode: UILabel!
    @IBOutlet weak var lbl_drop_CountryName: UILabel!
    @IBOutlet weak var lbl_drop_Telephone: UILabel!
    @IBOutlet weak var lbl_drop_DateTime: UILabel!

    @IBOutlet weak var tbl_extras: UITableView!
    @IBOutlet weak var hei_extrasTableView: NSLayoutConstraint!

    @IBOutlet weak var lbl_pickUpInstruction: UILabel!
    @IBOutlet weak var lbl_dropOffInstruction: UILabel!
    //@IBOutlet weak var btn_terms: UIButton!
    @IBOutlet weak var view_pay_summary: UIView!
    @IBOutlet weak var lbl_rentalPrice: UILabel!
    @IBOutlet weak var lbl_fullProtectionPrice: UILabel!
    @IBOutlet weak var lbl_payNowPrice: UILabel!
    @IBOutlet weak var hei_fullProtectionPriceView: NSLayoutConstraint!
    @IBOutlet weak var view_fullProtectionPrice: UIView!

//    @IBOutlet weak var view_pay_summary: UIView!
//    @IBOutlet weak var view_pay_summary: UIView!
//    @IBOutlet weak var view_pay_summary: UIView!

    
    @IBOutlet weak var txt_nationality: UITextField!
    @IBOutlet weak var txt_gender: UITextField!
    @IBOutlet weak var txt_dob: UITextField!
    @IBOutlet weak var txt_firstname: UITextField!
    @IBOutlet weak var txt_lastname: UITextField!
    @IBOutlet weak var txt_city: UITextField!
    @IBOutlet weak var txt_state: UITextField!
    @IBOutlet weak var txt_pincode: UITextField!
    @IBOutlet weak var txt_address: UITextField!

    @IBOutlet weak var txt_nationality_ContactInfo: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_mobileNo: UITextField!

    // date pickers...
    @IBOutlet weak var datePicker_MainView: UIView!
    @IBOutlet weak var datePicker_View: UIDatePicker!

    
    var isOpeningHrsExpand = false
    var islocationDetailsExpand = false
    var openingHrsTableHeight = 0
    var locationDetailsViewHeight = 40

    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = [:]
    
    var selectedExtraDropDownIndex = -1
    var selectedSeatsCount = 0
    
    enum CustomDropDownType {
        case Gender
        case InfantSeat
        case ChildSeat
        case BoosterSeat
        
        case Nationality
        case Nationality_ContactInfo
    }
    var selectedDropDown:CustomDropDownType = .Gender
    
    var carSearchMainModel: CarSearchMainModel?
    var selectedCarIndex = 0
    
    var carDetailsModel: CarDetailsModel?
    var selectedPricedEquip: [PricedEquip_Model] = [PricedEquip_Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_mobileNo.keyboardType = .numberPad // For integers
        txt_mobileNo.delegate = self
        txt_gender.text = "Mr"
        
        self.locationViewHeightChanges()
        self.getISOCodeList()
        self.locationDetails()
        self.showPriceDetails()
        self.view_payOnPickup.alpha = 0
        // check user login or not...
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                self.txt_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.txt_mobileNo.text = phone
            }
        }
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        hei_extrasTableView.constant = tbl_extras.contentSize.height+10
//    }
    override func viewDidAppear(_ animated: Bool) {
        hei_extrasTableView.constant = tbl_extras.contentSize.height+10
    }

    // MARK:- Helper
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
        self.txt_nationality.text = "\(String(describing: dailCode["Country"]!))"
        self.txt_nationality_ContactInfo.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"

    }

    func locationViewHeightChanges(){
        hei_openingHoursTableView.constant = CGFloat(openingHrsTableHeight)
        hei_locationSubView.constant = CGFloat(locationDetailsViewHeight)
        hei_locationMainView.constant = CGFloat(80 + openingHrsTableHeight + locationDetailsViewHeight)
    }
    func showPriceDetails(){
        var rentalAmount = self.carDetailsModel?.carRules?.TotalCharge?.Pricebreakup?.RentalPrice ?? 0.0
        //var payNowPrice = self.carDetailsModel?.carRules?.TotalCharge?.Pay_now ?? 0.0
        var payNowPrice = self.carDetailsModel?.carRules?.TotalCharge?.Pricebreakup?.RentalPrice ?? 0.0

        if let fullProtectionObj = self.carDetailsModel?.carRules?.PricedEquip.filter({$0.EquipType == "413"}) {
            if fullProtectionObj.count > 0{
                if fullProtectionObj[0].isSelected == true {
                    //rentalAmount += fullProtectionObj[0].Amount ?? 0.0
                    payNowPrice += fullProtectionObj[0].Amount ?? 0.0
                    hei_fullProtectionPriceView.constant = 50
                    view_fullProtectionPrice.alpha = 1
                    
//                    if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                        let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                        let value =  currencyConversion["value"] as? String
//                        let multipliedValue1 = (rentalAmount) * (Double(value ?? "0.0") ?? 0.0)
//                        let multipliedValue2 = (payNowPrice) * (Double(value ?? "0.0") ?? 0.0)
//                        let multipliedValue3 = (fullProtectionObj[0].Amount ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//
//                        lbl_rentalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//                        lbl_payNowPrice.text = symbol + " " + String(format: "%.2f", multipliedValue2)
//                        lbl_fullProtectionPrice.text = symbol + " " + String(format: "%.2f", multipliedValue3)
//                    }
                    lbl_rentalPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(rentalAmount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                    lbl_payNowPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(payNowPrice) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                    lbl_fullProtectionPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(fullProtectionObj[0].Amount!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                    
                }else{
                    ///When therre is full protection obj but not selected
//                    if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                        let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                        let value =  currencyConversion["value"] as? String
//                        let multipliedValue1 = (rentalAmount) * (Double(value ?? "0.0") ?? 0.0)
//                        let multipliedValue2 = (payNowPrice) * (Double(value ?? "0.0") ?? 0.0)
//                        lbl_rentalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//                        lbl_payNowPrice.text = symbol + " " + String(format: "%.2f", multipliedValue2)
//                    }
                    
                    lbl_rentalPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(rentalAmount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                    lbl_payNowPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(payNowPrice) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                    
                    hei_fullProtectionPriceView.constant = 0
                    view_fullProtectionPrice.alpha = 0
                }
            }else{
                ///When therre is no full protection obj
//                if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                    let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                    let value =  currencyConversion["value"] as? String
//                    let multipliedValue1 = (rentalAmount) * (Double(value ?? "0.0") ?? 0.0)
//                    let multipliedValue2 = (payNowPrice) * (Double(value ?? "0.0") ?? 0.0)
//                    lbl_rentalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//                    lbl_payNowPrice.text = symbol + " " + String(format: "%.2f", multipliedValue2)
//                }
                lbl_rentalPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(rentalAmount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                lbl_payNowPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(payNowPrice) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
                hei_fullProtectionPriceView.constant = 0
                view_fullProtectionPrice.alpha = 0

            }
        }
    }
    
    func getSelectedEquip(){
        self.selectedPricedEquip.removeAll()
        if let filtered_CheckBox = self.carDetailsModel?.carRules?.PricedEquip.filter({$0.isSelected == true}), filtered_CheckBox.count > 0{
            for item in 0...(filtered_CheckBox.count - 1){
                if filtered_CheckBox[item].EquipType != "413"{
                    self.selectedPricedEquip.append(filtered_CheckBox[item])
                }
            }
        }
        if let filtered_DropDowns = self.carDetailsModel?.carRules?.PricedEquip.filter({$0.seatCount ?? 0 > 0}),filtered_DropDowns.count > 0{
            self.selectedPricedEquip.append(contentsOf: filtered_DropDowns)
        }
        if selectedPricedEquip.count > 0{
            view_payOnPickup.alpha = 1
        }else{
            view_payOnPickup.alpha = 0
        }
        tbl_payOnPickup.reloadData()
        hei_payOnPickupTableView.constant = tbl_payOnPickup.contentSize.height
    }
    
    func locationDetails(){
        if let model = carDetailsModel?.carRules?.LocationDetails?.PickUpLocation {
            lbl_pick_name.text = model.value?.Name
            lbl_pick_StreetNmbr.text = model.Address?.StreetNmbr
            lbl_pick_CityName.text = model.Address?.CityName
            lbl_pick_PostalCode.text = model.Address?.PostalCode
            lbl_pick_CountryName.text = model.Address?.CountryName
            lbl_pick_Telephone.text = model.Telephone
            lbl_pick_DateTime.text = carDetailsModel?.carRules?.PickUpDateTime
            
            lbl_pickUpInstruction.text = model.AdditionalInfo?.ParkLocation ?? ""
            
            locationViewChanges_ExpandCollapse()
        }
        if let model = carDetailsModel?.carRules?.LocationDetails?.DropLocation {
            lbl_drop_name.text = model.value?.Name
            lbl_drop_StreetNmbr.text = model.Address?.StreetNmbr
            lbl_drop_CityName.text = model.Address?.CityName
            lbl_drop_PostalCode.text = model.Address?.PostalCode
            lbl_drop_CountryName.text = model.Address?.CountryName
            lbl_drop_Telephone.text = model.Telephone
            lbl_drop_DateTime.text = carDetailsModel?.carRules?.ReturnDateTime
            
            lbl_dropOffInstruction.text = model.AdditionalInfo?.ParkLocation ?? ""

            locationViewChanges_ExpandCollapse()
        }
        
    }
    
    func locationViewChanges_ExpandCollapse(){
        if let model = carDetailsModel?.carRules?.LocationDetails?.PickUpLocation {
            if islocationDetailsExpand{
                lbl_pick_StreetNmbr.text = model.Address?.StreetNmbr
            }else{
                lbl_pick_StreetNmbr.text = carDetailsModel?.carRules?.PickUpDateTime
            }
        }
        if let model = carDetailsModel?.carRules?.LocationDetails?.DropLocation {
            if islocationDetailsExpand{
                lbl_drop_StreetNmbr.text = model.Address?.StreetNmbr
            }else{
                lbl_drop_StreetNmbr.text = carDetailsModel?.carRules?.ReturnDateTime
            }
        }
    }
    // MARK:- API
    
    func preBookingAPICall(){
        
        let user_id = ""
        // params...
        var params:[String: Any] = ["ResultToken": carDetailsModel?.carRules?.ResultToken ?? "",
                                    "token": carDetailsModel?.token ?? "" ,
                                    "token_m": carDetailsModel?.token_m ?? "" ,
                                    "token_m_key": carDetailsModel?.token_m_key ?? "",
                                    "token_key": carDetailsModel?.token_key ?? "",
                                    "op": "book_room",
                                    "promo_code_discount_val": "0.0",
                                    "promo_code": "",
                                    "pax_title": "Mr",
                                    "first_name": txt_firstname.text ?? "",
                                    "last_name": txt_lastname.text ?? "",
                                    "country": "91",
                                    "city_name": txt_city.text ?? "",
                                    "state_name": txt_state.text ?? "",
                                    "postal_code": txt_pincode.text ?? "",
                                    "address": txt_address.text ?? "",
                                    "date_of_birth": txt_dob.text ?? "",
                                    "code": "",
                                    "module_type": "test",
//                                    "total_amount_val": String.init(format: "% .2f", carDetailsModel?.carRules?.TotalCharge?.Pay_now ?? 0.0),
                                    "total_amount_val": String.init(format: "% .2f", carDetailsModel?.carRules?.TotalCharge?.EstimatedTotalAmount ?? 0.0),

                                    "convenience_fee": "0",
                                    "currency_symbol": "",
                                    "currency": "USD",
                                    "billing_country": "test",
                                    "billing_city": "test",
                                    "billing_zipcode": "test",
                                    "billing_address_1": "test",
                                    "country_code": "IN",
                                    "passenger_contact": txt_mobileNo.text ?? "",
                                    "billing_email": txt_email.text ?? "",
//                                    "add_driver": "222",
//                                    "full_prot": "413",
//                                    "gps": "13",
//                                    "Child": "1",
                                    "tc": "on",
                                    "payment_method": "PNHB1",
                                    "customer_id": user_id.getUserId()]
        if let model = carSearchMainModel {
            params["search_id"] = model.search_id
            params["booking_source"] = model.booking_source
        }
        if let extraServices = carDetailsModel?.carRules?.PricedEquip{
            for item in extraServices{
                if item.name == "Child"{
                    if item.seatCount ?? 0 > 0 {
                        params["Child"] = String(item.seatCount ?? 0)
                    }
                }else if item.name == "Infant"{
                    if item.seatCount ?? 0 > 0{
                        params["Infant"] = String(item.seatCount ?? 0)
                    }
                    
                }else if item.name == "Booster"{
                    if item.seatCount ?? 0 > 0{
                        params["Booster"] = String(item.seatCount ?? 0)
                    }
                    
                }else if item.name == "full_prot"{
                    if item.isSelected == true{
                        params["full_prot"] =  "413"
                    }
                    
                }else if item.name == "add_driver"{
                    if item.isSelected == true{
                        params["add_driver"] =  "222"
                    }
                }else if item.name == "gps"{
                    if item.isSelected == true{
                        params["gps"] =  "13"
                    }
                }else{
                    ///If Any other extras
                    if item.isSelected == true{
                        if let key = item.name{
                            if let id = item.EquipType{
                                params[key] = id
                            }
                        }
                    }
                }
            }
        }
        
        //"Child","Infant","Booster","full_prot","add_driver","gps"
        
        
        
        var paramString:[String: String] = [:]
        
        paramString["pre_book"] = VKAPIs.getJSONString(object: params)
        CommonLoader.shared.startLoader(in: view)
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: car_PreBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Car Pre Book success: \(String(describing: resultObj))")
                
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
                    print("CAr Pre Book formate : \(String(describing: resultObj))")
                }
            } else {
                print("Car Pre Book error : \(String(describing: error?.localizedDescription))")
            }
            CommonLoader.shared.stopLoader()
        }
    }

    
    // MARK:- Actions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        
        if txt_firstname.text == "" {
            self.view.makeToast(message: "Please enter first Name")
        } else if txt_lastname.text == "" {
            self.view.makeToast(message: "Please enter last Name")
        } else if txt_city.text == ""{
            self.view.makeToast(message: "Please enter city Name")
        } else if txt_state.text == "" {
            self.view.makeToast(message: "Please enter state Name")
        } else if txt_address.text == "" {
            self.view.makeToast(message: "Please enter address")
        } else if txt_pincode.text == "" {
            self.view.makeToast(message: "Please enter pin code Name")
        }else if txt_dob.text == ""  {
            self.view.makeToast(message: "Please enter Date Of Birth")
        } else {
            self.preBookingAPICall()
        }
    }

    
    @IBAction func nationalityButtonClicked(_ sender: UIButton) {
        self.selectedDropDown = .Nationality
        // getting current position...
        let parent_view = sender.superview
//        parent_view?.bounds.width =  (parent_view?.bounds.width)! + 100
//        let f = CGRect(view.convert(CGPoint(x: <#T##Double#>, y: <#T##Double#>), from: <#T##UICoordinateSpace#>)))
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
//        fieldRect.width = fieldRect.width + 100
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    @IBAction func nationalityButtonClicked_ContactInfo(_ sender: UIButton) {
        self.selectedDropDown = .Nationality_ContactInfo
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
    
    @IBAction func genderButtonClicked(_ sender: UIButton) {
        self.selectedDropDown = .Gender
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_title = self
        tbl_popView.DType = .Title
        tbl_popView.title_array = ["Mr","Ms","Mrs"]
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    @IBAction func dateOfBirthBtnClicked(_ sender: UIButton) {
        datePicker_View.maximumDate = NSDate() as Date
        datePicker_View.datePickerMode = .date
        self.datePicker_MainView.isHidden = false
    }
    @IBAction func openingHoursExpandBtnClicked(_ sender: UIButton) {
        if isOpeningHrsExpand {
            isOpeningHrsExpand = false
            openingHrsTableHeight = 0
        }else{
            isOpeningHrsExpand = true
            openingHrsTableHeight = 30 * (carDetailsModel?.carRules?.LocationDetails?.PickUpLocation?.OpeningHours.count ?? 0)
        }
        self.locationViewHeightChanges()
    }
    
    @IBAction func locationExpandBtnClicked(_ sender: UIButton) {
        if islocationDetailsExpand {
            islocationDetailsExpand = false
            locationDetailsViewHeight = 40
        }else{
            islocationDetailsExpand = true
            locationDetailsViewHeight = 140
        }
        self.locationViewHeightChanges()
        self.locationViewChanges_ExpandCollapse()
    }
    // MARK:- PickerButtons
    @IBAction func hiddenDatePicker_ButtonClicked(_ sender: UIButton) {
        self.datePicker_MainView.isHidden = true
    }
    
    @IBAction func pickerCancelAndDone_ButtonClicked(_ sender: UIButton) {
        
        // done button aciton
        txt_dob.text = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                   date: self.datePicker_View.date)
        self.datePicker_MainView.isHidden = true
    }
    

}
extension CarDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_openingHours{
        return carDetailsModel?.carRules?.LocationDetails?.PickUpLocation?.OpeningHours.count ?? 0
        }else if tableView == tbl_extras{
            return carDetailsModel?.carRules?.PricedEquip.count ?? 0
        }else if tableView == tbl_payOnPickup{
            return selectedPricedEquip.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_openingHours{
            var cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursCell") as? OpeningHoursCell
            if cell == nil {
                tableView.register(UINib(nibName: "OpeningHoursCell", bundle: nil), forCellReuseIdentifier: "OpeningHoursCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "OpeningHoursCell") as? OpeningHoursCell
            }
            let pickObj = carDetailsModel?.carRules?.LocationDetails?.PickUpLocation?.OpeningHours[indexPath.row]
            let dropObj = carDetailsModel?.carRules?.LocationDetails?.DropLocation?.OpeningHours[indexPath.row]
            
            let pick1 = (pickObj?.Day ?? "") + " : " + (pickObj?.Start ?? "")
            let pick2 = "-" + (pickObj?.End ?? "")
            
            let drop1 = (dropObj?.Day ?? "") + " : " + (dropObj?.Start ?? "")
            let drop2 = "-" + (dropObj?.End ?? "")
            
            
            cell?.lbl_pick_openingHrs.text = pick1 + pick2
            cell?.lbl_drop_openingHrs.text = drop1 + drop2
            
            return cell!
        }else if tableView == tbl_extras{
            var cell = tableView.dequeueReusableCell(withIdentifier: "ExtraCoverageCell") as? ExtraCoverageCell
            if cell == nil {
                tableView.register(UINib(nibName: "ExtraCoverageCell", bundle: nil), forCellReuseIdentifier: "ExtraCoverageCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ExtraCoverageCell") as? ExtraCoverageCell
            }
            cell?.displayData(model: (carDetailsModel?.carRules?.PricedEquip[indexPath.row])!)
            
            cell?.btn_dropDown.addTarget(self, action: #selector(extras_DropDownSeatClicked), for: .touchUpInside)
            cell?.btn_check.addTarget(self, action: #selector(extras_CheckBoxClicked), for: .touchUpInside)
            cell?.btn_dropDown.tag = indexPath.row
            cell?.btn_check.tag = indexPath.row
            
            ///Call back
            cell?.reloadMaintable = {
                self.expandMainTableView(showLoader: false)
            }

            return cell!
        }else if tableView == tbl_payOnPickup{
            var cell = tableView.dequeueReusableCell(withIdentifier: "PayOnPickUpCell") as? PayOnPickUpCell
            if cell == nil {
                tableView.register(UINib(nibName: "PayOnPickUpCell", bundle: nil), forCellReuseIdentifier: "PayOnPickUpCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PayOnPickUpCell") as? PayOnPickUpCell
            }
            cell?.displayData(model: selectedPricedEquip[indexPath.row])
            return cell!
        }
        return UITableViewCell()
    }
    
    func expandMainTableView(showLoader: Bool){
        //tbl_extras.reloadData()
        //self.hei_extrasTableView.constant = 400
        self.hei_extrasTableView.constant = tbl_extras.contentSize.height+10
        self.tbl_extras.layoutIfNeeded()
    }
    
    @objc func extras_DropDownSeatClicked(sender:UIButton){
//        let indexPath = IndexPath(row: sender.tag, section: 0)
//        var cell = tbl_extras.cellForRow(at: indexPath)
        self.selectedExtraDropDownIndex = sender.tag
        if self.carDetailsModel?.carRules?.PricedEquip[sender.tag].name == "Infant" {
            self.selectedDropDown = .InfantSeat
        }else if self.carDetailsModel?.carRules?.PricedEquip[sender.tag].name == "Child" {
            self.selectedDropDown = .ChildSeat
        }else{
            self.selectedDropDown = .BoosterSeat
        }
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_Custom = self
        tbl_popView.DType = .Custom
        tbl_popView.customArray = ["0","1","2"]
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
        
    }
    
    @objc func extras_CheckBoxClicked(sender:UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if self.carDetailsModel?.carRules?.PricedEquip[sender.tag].isSelected == true{
            self.carDetailsModel?.carRules?.PricedEquip[sender.tag].isSelected = false
        }else{
            self.carDetailsModel?.carRules?.PricedEquip[sender.tag].isSelected = true
        }
        tbl_extras.reloadRows(at: [indexPath], with: .automatic)
        self.showPriceDetails()
        getSelectedEquip()
    }
    
}
// MARK:- ISOCodeDelegate
extension CarDetailsViewController: ISOCodeDelegate {
    
    func countryISOCode(dial_code: [String : String]) {
        if selectedDropDown == .Nationality{
            countryISO_Dict = dial_code
            displayDialCode(dailCode: countryISO_Dict)
        }else{
            txt_nationality_ContactInfo.text = "\(String(describing: dial_code["Country"]!)) (\(String(describing: dial_code["DialCode"]!)))"
        }
    }
}
// MARK:- CustomDelegate
extension CarDetailsViewController: CustomDelegate, TravellerTitleDelegate {
    func travellerTitle(title: String) {
        self.txt_gender.text = title

    }
    func CustomListDropDownSelection(selected_Str: String, selectedIndex: Int) {
        print(selected_Str)
        if selectedDropDown == .Gender{
            self.txt_gender.text = selected_Str
            return
        }else if selectedDropDown == .InfantSeat{
            if selectedSeatsCount < self.carDetailsModel?.carRules?.PassengerQuantity ?? 0 {
                self.carDetailsModel?.carRules?.PricedEquip[selectedExtraDropDownIndex].seatCount = Int(selected_Str)
                self.selectedSeatsCount += Int(selected_Str) ?? 0
            }else{
                self.view.makeToast(message: "Exceeds the Passenger Count")
            }
        }else if selectedDropDown == .ChildSeat{
            if selectedSeatsCount < self.carDetailsModel?.carRules?.PassengerQuantity ?? 0 {
                self.carDetailsModel?.carRules?.PricedEquip[selectedExtraDropDownIndex].seatCount = Int(selected_Str)
                self.selectedSeatsCount += Int(selected_Str) ?? 0
            }else{
                self.view.makeToast(message: "Exceeds the Passenger Count")
            }
        }else{
            if selectedSeatsCount < self.carDetailsModel?.carRules?.PassengerQuantity ?? 0 {
                self.carDetailsModel?.carRules?.PricedEquip[selectedExtraDropDownIndex].seatCount = Int(selected_Str)
                self.selectedSeatsCount += Int(selected_Str) ?? 0
            }else{
                self.view.makeToast(message: "Exceeds the Passenger Count")
            }
        }
        //        let indexPath = IndexPath(row: selectedExtraDropDownIndex, section: 0)
        //        tbl_extras.reloadRows(at: [indexPath], with: .automatic)
        tbl_extras.reloadData()
        getSelectedEquip()
    }
    
    
    
}
extension CarDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_mobileNo {
            let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
        }else{
            return true
        }
    }
    
    func dismissKeyboardMethod() {
        
        // resigns...
//        firstName_TF.resignFirstResponder()
//        lastName_TF.resignFirstResponder()
    }
}
