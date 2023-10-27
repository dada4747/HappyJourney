//
//  TransfersReviewViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 03/08/21.
//

import UIKit

class TransfersReviewViewController: UIViewController {
    enum CustomDropDownType {
        case Gender
        case HotelsList
        case Nationality
    }
    var selectedDropDown:CustomDropDownType = .Gender
    
    @IBOutlet weak var txt_gender: UITextField!
    @IBOutlet weak var txt_Nationality: UITextField!
    @IBOutlet weak var txt_hotel: UITextField!
    
    @IBOutlet weak var txt_mobileNo: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_firstname: UITextField!
    @IBOutlet weak var txt_lastname: UITextField!

    @IBOutlet weak var img_product: UIImageView!
    @IBOutlet weak var lbl_productTitle: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_travellerPickup: UILabel!
    @IBOutlet weak var lbl_totalTravelers: UILabel!
    @IBOutlet weak var lbl_totalPax: UILabel!
    @IBOutlet weak var lbl_totalAmount: UILabel!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    @IBOutlet weak var lbl_freeCancellationDate: UILabel!
    @IBOutlet weak var lbl_taxes: UILabel!
    @IBOutlet weak var lbl_grandTotalPrice: UILabel!

    
    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        getISOCodeList()
        disPlayData()
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
//        self.txt_Nationality.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"
        self.txt_Nationality.text = (String(describing: dailCode["DialCode"]!))
    }
    
    func disPlayData(){
        if let model = DBlockTripsModel.pre_booking_params{
            self.img_product.sd_setImage(with: URL.init(string: String(format: "%@",(DTransferDetailsModel.product_img))), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))

            self.lbl_productTitle.text = model.ProductName
            self.lbl_rating.text = String(model.StarRating ?? 0)
            if model.HotelPickup == true{
                self.lbl_travellerPickup.text = "Traveler pickup is offered"
            }else{
                self.lbl_travellerPickup.text = "Traveler pickup is not offered"
            }
            self.lbl_totalTravelers.text = "Total Travelers: 1"
            ///bottom
            self.lbl_totalPax.text = "1"
            self.lbl_freeCancellationDate.text = model.TM_LastCancellation_date
            
//            self.lbl_totalAmount.text = "$ " + String(DBlockTripsModel.total_price ?? 0.0)
//            self.lbl_totalPrice.text = "$ " + String(model.priceObj?.TotalDisplayFare ?? 0.0)
//            self.lbl_taxes.text = "$ " + String(model.taxes ?? 0.0)
//            self.lbl_grandTotalPrice.text = "$ " + String(DBlockTripsModel.total_price ?? 0.0)

            if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
                let symbol = currencyConversion["currency_symbol"] as? String ?? ""
                let value =  currencyConversion["value"] as? String
                let multipliedValue1 = (DBlockTripsModel.total_price ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
                let multipliedValue2 = (model.priceObj?.TotalDisplayFare ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
                let multipliedValue3 = (model.taxes ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)

                self.lbl_totalAmount.text = symbol + " " + String(format: "%.2f", multipliedValue1)
                self.lbl_totalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue2)
                self.lbl_taxes.text = symbol + " " + String(format: "%.2f", multipliedValue3)
                self.lbl_grandTotalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue1)

            }
        }
    }
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderBtnClicked(_ sender: UIButton) {
        self.selectedDropDown = .Gender
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_Custom = self
        tbl_popView.DType = .Custom
        tbl_popView.customArray = ["Mr","Ms","Mrs"]
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    @IBAction func countryCodeBtnClicked(_ sender: UIButton) {
        self.selectedDropDown = .Nationality
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
    
    @IBAction func hotelListBtnClicked(_ sender: UIButton) {
        self.selectedDropDown = .HotelsList
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
        
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.preBookingAPIConnection()
    }
    
}
// MARK:- Helper
extension TransfersReviewViewController {
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
                                    "convenience_fee": "0",
                                    "currency_symbol": "$",
                                    "currency": "USD",
                                    "billing_country": "92",
                                    "billing_city": "bangalore",
                                    "billing_zipcode": "560037",
                                    "billing_address_1": "bangalore E-city",
                                    "country_code": "IN",
                                    "passenger_contact": txt_mobileNo.text,
                                    "billing_email": txt_email.text,
                                    "tc": "on",
                                    "payment_method": "PNHB1",
                                    "hotel_pickup_list_name": txt_hotel.text,
                                    "passenger_type": ["1"],
                                    "lead_passenger": ["1"],
                                    "name_title": ["1"],
                                    "first_name": [txt_firstname.text],
                                    "last_name": [txt_lastname.text],
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
        SwiftLoader.show(animated: true)
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
        }
        
    }
    
    
}
// MARK:- CustomDelegate
extension TransfersReviewViewController: CustomDelegate {
    func CustomListDropDownSelection(selected_Str: String, selectedIndex: Int) {
        print(selected_Str)
        if selectedDropDown == .Gender{
            self.txt_gender.text = selected_Str
            return
        }else if selectedDropDown == .HotelsList{
            self.txt_hotel.text = selected_Str
            return
        }else if selectedDropDown == .Nationality{
            self.txt_Nationality.text = selected_Str
            return
        }
    }
}

// MARK:- ISOCodeDelegate
extension TransfersReviewViewController: ISOCodeDelegate {
    
    func countryISOCode(dial_code: [String : String]) {
        if selectedDropDown == .Nationality{
            countryISO_Dict = dial_code
            displayDialCode(dailCode: countryISO_Dict)
        }
    }
}
