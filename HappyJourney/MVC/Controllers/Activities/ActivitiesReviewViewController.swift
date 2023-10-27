//
//  ActivitiesReviewViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 09/08/21.
//

import UIKit

class ActivitiesReviewViewController: UIViewController {
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
    var selectedHotel_Id: String = ""
    
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
//                let multipliedValue2 = (model.priceObj?.TotalDisplayFare ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//                let multipliedValue3 = (model.taxes ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)

//                self.lbl_totalAmount.text = symbol + " " + String(format: "%.2f", multipliedValue1)
//                self.lbl_totalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue2)
//                self.lbl_taxes.text = symbol + " " + String(format: "%.2f", multipliedValue3)
//                self.lbl_grandTotalPrice.text = symbol + " " + String(format: "%.2f", multipliedValue1)

            }
        }
    }
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func genderBtnClicked(_ sender: UIButton) {
//        self.selectedDropDown = .Gender
//        // getting current position...
//        let parent_view = sender.superview
//        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
//
//        // table pop view...
//        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
//        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        tbl_popView.delegate_Custom = self
//        tbl_popView.DType = .Custom
//        tbl_popView.customArray = ["Mr","Ms","Mrs"]
//        tbl_popView.changeMainView_Frame(rect: fieldRect)
//        self.view.addSubview(tbl_popView)
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
//        self.selectedDropDown = .HotelsList
//        // getting current position...
//        let parent_view = sender.superview
//        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
//
//        // table pop view...
//        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
//        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        tbl_popView.delegate_Custom = self
//        tbl_popView.DType = .Custom
//        let filteredArr = DBlockTripsModel.pre_booking_params?.hotelsList.map {$0.hotel_name}
//        tbl_popView.customArray = filteredArr ?? []
//        tbl_popView.changeMainView_Frame(rect: fieldRect)
//        self.view.addSubview(tbl_popView)
//
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        self.preBookingAPIConnection()
    }
    
}
// MARK:- Helper
extension ActivitiesReviewViewController {
    func preBookingAPIConnection(){
        
        let user_id = ""
        // params...
        var params:[String: String] = ["BlockTourId": DBlockTripsModel.pre_booking_params?.BlockTourId ?? "",
                                    "token": DBlockTripsModel.token ?? "" ,
                                    "token_key": DBlockTripsModel.token_key ?? "",
                                    "op": "block_trip",
//                                    "promo_code_discount_val": "0.0",
//                                    "promo_code": "",
//                                    "promo_actual_value": "",
//                                    "code": "",
                                    //"module_type": DBlockTripsModel.module_value,
                                    "customer_id": user_id.getUserId(),
                                    "final_fare": String.init(format: "% .2f", DBlockTripsModel.total_price ?? 0.0),
                                    //"convenience_fee": String.init(format: "% .2f", DBlockTripsModel.convenience_fees ?? 0.0),
                                    //"convenience_fee": "0",
                                    //"currency_symbol": "$",
                                    "currency": "USD",
//                                    "billing_country": "92",
//                                    "billing_city": "bangalore",
//                                    "billing_zipcode": "560037",
//                                    "billing_address_1": "bangalore E-city",
//                                    "country_code": "IN",
                                    "ContactNo": txt_mobileNo.text ?? "",
                                    "Email": txt_email.text ?? "",
                                    //"tc": "on",
                                    "payment_method": "PNHB1",
                                    "Hotelpickupname": txt_hotel.text ?? "",
                                    "hotel_pickup_list_name": txt_hotel.text ?? "",
//                                    "passenger_type": ["1"],
//                                    "lead_passenger": ["1"],
//                                    "name_title": ["1"],
                                    "booking_source": DBlockTripsModel.booking_source ?? "",
                                    "search_id": DBlockTripsModel.search_id ?? "",
                                    "grade_title": DBlockTripsModel.pre_booking_params?.grade_title ?? "",
                                    "booking_date": DBlockTripsModel.pre_booking_params?.booking_date ?? "",
                                    "tageduser": "",
                                    "grade_code": DBlockTripsModel.pre_booking_params?.grade_code ?? "",
                                    "HotelPickupId": selectedHotel_Id,
                                    "product_code": DBlockTripsModel.pre_booking_params?.product_code ?? "",
                                    "device_type": "mobile"
        ]
        
        let passangerObj: [String: Any] = ["firstName":self.txt_firstname.text,"lastName":self.txt_lastname.text,"Title":"1","Pax_Type":"1"]
        //params["Passengers"] = [passangerObj]
        let passangerObj_str = VKAPIs.getJSONString(object: [passangerObj])
        params["Passengers"] = passangerObj_str
       
        var ageBands: [Any] = []
        for item in DActivitiesDetailsModel.ageBands_Array{
            let dict = ["bandId": String(item.band_Id ?? 0), "count": String(item.count ?? 0)]
            ageBands.append(dict)
        }
        let ageBands_str = VKAPIs.getJSONString(object: ageBands)
       // params["age_band"] = ageBands
        params["age_band"] = ageBands_str
        
        
        var bookingQuestionArr:[[String: Any]] = []
        for item in DBlockTripsModel.pre_booking_params?.bookingQuestionsList ?? [] {
            let obj: [String: Any] = ["id": item.questionId, "answer": "Test"]
            bookingQuestionArr.append(obj)
        }
        let pax_question_str = VKAPIs.getJSONString(object: bookingQuestionArr)
        params["BookingQuestions"] = pax_question_str
        
        ///in previous app
//        let pax_dict: [String: Any] = ["1":["10 August 1994"]]
//        let pax_question: [String: Any] = ["pax_question": pax_dict]
//        let pax_question_str = VKAPIs.getJSONString(object: pax_question)
//        params["BookingQuestions"] = pax_question_str

        
//        let emptyDict: [String: Any] = [:]
//        params["BookingQuestions"] = emptyDict
        
        CommonLoader.shared.startLoader(in: view)
        // calling apis...
//        VKAPIs.shared.getRequestFormdata_Copy(params: params, file: Activities_Prebooking, httpMethod: .POST)
//        { (resultObj, success, error) in
//
//            // success status...
//            if success == true {
//                print("Activities_Prebooking response: \(String(describing: resultObj))")
//
//
//                if let result = resultObj as? [String: Any] {
//                    if result["status"] as? Bool == true {
//
//                        // response date...
//                        if let data_dict = result["data"] as? [String: Any] {
//
//                            // move to payment...
////                            let pay_vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarPaymentVC") as! CarPaymentVC
////                            pay_vc.payment_url = data_dict["payment_url"] as? String
////                            self.navigationController?.pushViewController(pay_vc, animated: true)
//                        }
//                    } else {
//                        // error message...
//                        if let message_str = result["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Activities_Prebooking error : \(String(describing: error?.localizedDescription))")
//                    self.view.makeToast(message: error?.localizedDescription ?? "")
//                }
//
//            }else{
//                print(error.debugDescription)
//            }
//            CommonLoader.shared.stopLoader()
//        }
        
    }
    
    
}
// MARK:- CustomDelegate
//extension ActivitiesReviewViewController: CustomDelegate {
//
//    func CustomListDropDownSelection(selected_Str: String, selectedIndex: Int) {
//        print(selected_Str)
//        if selectedDropDown == .Gender{
//            self.txt_gender.text = selected_Str
//            return
//        }else if selectedDropDown == .HotelsList{
//            self.txt_hotel.text = selected_Str
//            self.selectedHotel_Id = DBlockTripsModel.pre_booking_params?.hotelsList[selectedIndex].hotel_id ?? ""
//            return
//        }else if selectedDropDown == .Nationality{
//            self.txt_Nationality.text = selected_Str
//            return
//        }
//    }
//}

// MARK:- ISOCodeDelegate
extension ActivitiesReviewViewController: ISOCodeDelegate {
    
    func countryISOCode(dial_code: [String : String]) {
        if selectedDropDown == .Nationality{
            countryISO_Dict = dial_code
            displayDialCode(dailCode: countryISO_Dict)
        }
    }
}

