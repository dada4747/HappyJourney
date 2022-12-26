//
//  BusPassengerDetails.swift
//  Internacia
//
//  Created by Admin on 18/11/22.
//

import UIKit
import OrderedCollections
//import OrderedCollections

struct PassengerInfo {
    static var passenger_type :[Int : String] = [:]
    static var nameTitle :[Int : String] = [:]
    static var firstName :[Int : String] = [:]
    static var age : [Int : String] = [:]
    static var email: String = ""
    static var mobileNumber : String = ""
//    var w : [String] = []
    
}
class BusPassengerDetails: UIViewController, PromoCodeDelegate, ISOCodeDelegate, AddTravellerCellDelegate, TravellerTitleCellDelegate {

    func categorySelected(sender: UIButton, cell: UITableViewCell) {
    }
    
    func typeSelected(sender: UIButton, cell: UITableViewCell) {
        let indexPath =  tbl_traveller.indexPath(for: cell)
        selectedIndexPath = indexPath
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.customIndex = indexPath
        tbl_popView.delegate_titleCell = self
        tbl_popView.DType = .TitleCell
        tbl_popView.title_array = ["Mr", "Ms", "Mrs", "Miss", "Master" ]
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    func travellerTitleForcell(title: String, indexPath: IndexPath) {
        let cell = tbl_traveller.cellForRow(at: indexPath) as? AddTravellerCell
        cell!.tf_NameTitle.text = title
        selectedIndexPath = indexPath
        PassengerInfo.nameTitle[indexPath.row] = title
        if title == "Mr" || title == "Master" || title == "" {
            PassengerInfo.passenger_type[indexPath.row] = "Male"
        } else {
            PassengerInfo.passenger_type[indexPath.row] = "Female"
        }
        tbl_traveller.reloadData()
    }
    
    func firstNameTextField(sender: UITextField, cell: UITableViewCell) {
        let indexPath =  tbl_traveller.indexPath(for: cell)
        PassengerInfo.firstName[indexPath!.row] = sender.text!

    }
    
    func lastNameTextField(sender: UITextField, cell: UITableViewCell) {
        let indexPath =  tbl_traveller.indexPath(for: cell)
        
        PassengerInfo.age[indexPath!.row] = sender.text

    }
    
    func countryISOCode(dial_code: [String : String]) {
        tf_isoCode.text = "\(String(describing: dial_code["Country"]!)) (\(String(describing: dial_code["DialCode"]!)))"
        displayDialCode(dailCode: dial_code)
    }
    
    func selectedPromoCode(promoCode: DCommonTopOfferItems) {
        selectedPromo = promoCode
        txt_promo.text = selectedPromo?.promoCode
    }
    

    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var tf_isoCode: UITextField!
    @IBOutlet weak var tf_mobileNumber: UITextField!
    
    @IBOutlet weak var btn_applyPromo: GradientButton!
    @IBOutlet weak var btn_selectPromo: UIButton!
    @IBOutlet weak var btn_cancelPromo: CRButton!
    @IBOutlet weak var txt_promo: UITextField!

    @IBOutlet weak var lbl_seatsNo: UILabel!
    @IBOutlet weak var lbl_boardingPoint: UILabel!
    @IBOutlet weak var lbl_dropingPoint: UILabel!

    @IBOutlet weak var tbl_traveller: UITableView!
    @IBOutlet weak var tbl_travHight: NSLayoutConstraint!

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_totalSeats: UILabel!
    @IBOutlet weak var lbl_convenienceFees: UILabel!
    
    @IBOutlet weak var lbl_total_fare: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_gst: UILabel!
    @IBOutlet weak var lbl_baseFare: UILabel!
    var view_PromoCodeView: ToursPackageView?
    var selectedPromo: DCommonTopOfferItems?
    var countryISO_Dict: [String: String] = [:]
    var countries_array: [[String: String]] = []
    var selectedIndexPath : IndexPath?
//    var bookedSeatsList_arr : = []
//    var final_cost : Float?
    override func viewDidLoad() {
        super.viewDidLoad()
        apiBooking()
        displayInfo()
        addDelegate()
        getISOCodeList()
        showUserDefaults()
        addFrameAddView()
        for i in 0..<DBusResultModel.bus_Selected_Seats_list.count {
            PassengerInfo.nameTitle[i] = "Mr"
            PassengerInfo.passenger_type[i] = "Male"
        }

        // Do any additional setup after loading the view.
    }
    func addFrameAddView(){
        self.view_PromoCodeView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_PromoCodeView?.isHidden = true
        self.view_PromoCodeView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_PromoCodeView!)
    }
    func displayInfo() {
        let seatNumbers = DBusResultModel.bus_Selected_Seats_list.map{$0.seatNo}
        lbl_seatsNo.text = seatNumbers.joined(separator: ",")

//        lbl_seatsNo.text = D
        lbl_boardingPoint.text = DBusResultModel.selected_boarding.pickupName
        lbl_dropingPoint.text = DBusResultModel.selected_dropOff.dropoffName
        lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", ((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) - DBusResultModel.bus_discount) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_totalSeats.text =  "Total Seats \(DBusResultModel.bus_Selected_Seats_list.count)"
        lbl_convenienceFees.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", (DBusResultModel.convenienceFee) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_discount.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD",  ( DBusResultModel.bus_discount) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_gst.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", (DBusResultModel.gst) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_baseFare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", (DBusResultModel.bus_final_total_price ) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_total_fare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", ((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) - DBusResultModel.bus_discount) *  (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
    }
    func showUserDefaults(){
        let userProfile = UserDefaults.standard.object(forKey: TMXUser_Profile)
        if userProfile is [String: Any] {
            
            // after login...
            if let email_id = (userProfile as! [String: Any])["email_id"] as? String {
                self.tf_email.text = email_id
            }
            
            if let phone = (userProfile as! [String: Any])["phone"] as? String {
                self.tf_mobileNumber.text = phone
            }
        }

    }
    func addDelegate(){
        tbl_traveller.delegate = self
        tbl_traveller.dataSource = self
        tbl_traveller.rowHeight = UITableView.automaticDimension
        tbl_traveller.estimatedRowHeight = 100
        setTableHeight()
    }
    func setTableHeight(){
        tbl_travHight.constant =  CGFloat((DBusResultModel.bus_Selected_Seats_list.count) * 100)//CGFloat((DBlockTripsModel.pre_booking_params?.bookingQuestionsList.count)! * 200)//
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
        
    }
    @objc func tableHeightCalculation() {
        tbl_travHight.constant = tbl_traveller.contentSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
        tbl_traveller.reloadData()
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
        
        self.tf_isoCode.text = "\(String(describing: dailCode["Country"]!)) (\(String(describing: dailCode["DialCode"]!)))"
    }
    @IBAction func selectCountryCode(_ sender: Any) {
        
    }
    @IBAction func selectPromoCodeAction(_ sender: Any) {
        let result = DCommonModel.topOffer_Array.filter{ $0.module == "bus"}
        if result.count == 0 {
            self.view.makeToast(message: "Promo Code Not available")
        } else {
            self.view_PromoCodeView?.packageType = .PromoCodes
            self.view_PromoCodeView?.promoCodeArray = result //DCommonModel.topOffer_Array.filter{ $0.module == "hotel"}
            self.view_PromoCodeView?.displayInfo()
            self.view_PromoCodeView?.promoCodeDelegate = self
            self.view_PromoCodeView?.isHidden = false
            UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_PromoCodeView!)

        }
    
    }
    @IBAction func btnCancelPromoAction(_ sender: Any) {
        self.btn_selectPromo.isHidden = false
        DBusResultModel.bus_discount  = 0.0

        txt_promo.text = nil
        btn_cancelPromo.isHidden = true
        btn_applyPromo.setTitle("APPLY", for: .normal)
        
        
//        self.displayBookingPriceInfo()

    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        DBusResultModel.bus_discount = 0.0
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func promoBtnClicked(_ sender: Any) {
        aplyPromo()
    }
    func removePromo() {
        DBusResultModel.bus_discount  = 0.0
        self.btn_applyPromo.setTitle("APPLY", for: .normal)
        self.btn_cancelPromo.isHidden = true
        self.btn_selectPromo.isHidden = false
        self.txt_promo.text = nil
        self.view.makeToast(message: "Promo Code Not Valid")
//        self.displayBookingPriceInfo()
        displayInfo()
    }
    func appliedPromo() {
        self.btn_applyPromo.setTitle("APPLIED", for: .normal)
        self.btn_cancelPromo.isHidden = false
        self.btn_selectPromo.isHidden = true
        self.view.makeToast(message: "Promo Code Applied Successfully")
        displayInfo()
//        self.displayBookingPriceInfo()
    }
    
    func aplyPromo(){
        if (txt_promo.text?.isEmpty == true) {
            self.view.makeToast(message: "Please select promo code")
        } else {
            SwiftLoader.show(animated: true)

            let userId = ""
            let params: [String: Any] = ["promo_code":txt_promo.text ?? "","module":"bus","total_amount_val": DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee , "user_id":userId.getUserId(),"email": tf_email.text ?? "","convenience_fee": 0.0,"currency": DCurrencyModel.currency_saved?.currency_country ?? "INR"]
            let paramString: [String: String] = ["get_promo": VKAPIs.getJSONString(object: params)]

            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/mobile_promocode", httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Promo code success responce: \(String(describing: resultObj))")

                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {

                            // response data...
                            let value = Float(result["discount_value"] as! String)
                            if  DBusResultModel.bus_final_total_price <= (self.selectedPromo?.minimum_amount)! || (value! > DBusResultModel.bus_final_total_price) {
//                                FinalBreakupHotelModel.total_amount_val = 0.0//FinalBreakupHotelModel.totalFare
                                self.removePromo()

                            }else {
                                DBusResultModel.bus_discount  = Float(result["discount_value"] as! String)!
//                                DBusResultModel.bus_final_total_price = Float(result["total_amount_val"] as! String)!
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
                SwiftLoader.hide()

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
    @IBAction func continueActionButton(){
        
        self.view.isUserInteractionEnabled = false
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""

        if PassengerInfo.firstName.count < DBusResultModel.bus_Selected_Seats_list.count {
            messageStr = "Please select name of all traveller"
        }else if PassengerInfo.age.count < DBusResultModel.bus_Selected_Seats_list.count{
            messageStr = "Please select age of all traveller"
        }else if (tf_email.text?.count == 0 || tf_email.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter email id"
        }
        else if !(tf_email.text?.isValidEmailAddress())! {
            messageStr = "Please enter valid email"
        }
        else if (tf_isoCode.text?.count == 0 || tf_isoCode.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please select ISD code"
        } else if (tf_mobileNumber.text?.count == 0 || tf_mobileNumber.text?.trimmingCharacters(in: whitespace).count == 0) {
            messageStr = "Please enter mobile number"
        } else if (!(tf_mobileNumber.text?.isValidPhone())!){
            messageStr = "Please enter mobile number"
        } else{}
        if messageStr.count != 0 {
            self.view.makeToast(message: messageStr)
        }
        else {
            PassengerInfo.email = tf_email.text!
            // mobile numbers...
            let mobileNo = String(format: "%@ %@", countryISO_Dict["DialCode"]!, tf_mobileNumber.text!)
            PassengerInfo.mobileNumber = mobileNo
            preApiParams()
        }
        self.view.isUserInteractionEnabled = true


    }
    func preApiParams(){

        let user_id = ""
        let params: [String: Any] = [
            "resulttoken" : DBusDetailModel.result_token ?? "", "alternate_contact" : "", "billing_email" : PassengerInfo.email, "booking_source" : DBusSearchModel.booking_source, "contact_name" : PassengerInfo.firstName.map{$0.1}, "age": PassengerInfo.age.map{$0.1}, "gender" : PassengerInfo.passenger_type.map{$0.1}, "op" : "book_bus", "passenger_contact" : tf_mobileNumber.text ?? "", "pax_title" : PassengerInfo.nameTitle.map{$0.1}, "payment_method" : "PNHB1", "search_id" : DBusDetailModel.search_id ?? "", "tc" : "on", "token" : VKAPIs.getJSONString(object: createToken()), "payment_type" : "EBS", "customer_id" : user_id.getUserId(), "promo_code" : selectedPromo?.promoCode ?? "", "promo_code_discount_val" : String(DBusResultModel.bus_discount )
        ]
//        let req = ["resulttoken": DBusDetailModel.result_token ?? "","age":PassengerInfo.age.map{$0.1},"alternate_contact":"","billing_email": PassengerInfo.email,"booking_source":DBusSearchModel.booking_source,"contact_name":PassengerInfo.firstName.map{$0.1},"gender":PassengerInfo.passenger_type.map{$0.1},"op":"book_bus","passenger_contact":tf_mobileNumber.text ?? "","pax_title":PassengerInfo.nameTitle.map{$0.1},"payment_method":"PNHB1","search_id":DBusDetailModel.search_id ?? "","tc":"on","token":"{\"RouteScheduleId\":\"\(DBusResultModel.selectedBus?.RouteScheduleId! ?? "")\",\"JourneyDate\":\"\(DBusResultModel.selectedBus?.DeptTime ?? "")\",\"PickUpID\":\"\(DBusResultModel.selected_boarding.pickupCode ?? "")\",\"DropID\":\"\(DBusResultModel.selected_dropOff.dropoffCode ?? "")\",\"DepartureTime\":\"\(DBusResultModel.selectedBus?.DepartureTime! ?? "")\",\"ArrivalTime\":\"\(DBusResultModel.selectedBus?.ArrivalTime ?? "")\",\"departure_from\":\"\(DBusResultModel.selectedBus?.From ?? "")\",\"arrival_to\":\"\(DBusResultModel.selectedBus?.To ?? "")\",\"Form_id\":\"\(DBTravelModel.destinationCity["id"] ?? "")\",\"To_id\":\"\(DBTravelModel.sourceCity["id"] ?? "")\",\"boarding_from\":\"\(DBusResultModel.selected_boarding.pickupName ?? ""), Address : \(DBusResultModel.selected_boarding.address ?? ""), Landmark : \(DBusResultModel.selected_boarding.landmark ?? ""), Phone : \(DBusResultModel.selected_boarding.contact ?? "")\",\"dropping_to\":\"\(DBusResultModel.selected_dropOff.dropoffName ?? "")\",\"bus_type\":\"\(DBusResultModel.selectedBus?.BusTypeName ?? "" )\",\"operator\":\"\(DBusResultModel.selectedBus?.CompanyName ?? "")\",\"CommAmount\":\"\(String(DBusResultModel.selectedBus?.CommAmount ?? 0.0) as CVarArg)\",\"CancPolicy\":\(VKAPIs.getJSONString(object: DBusDetailModel.result.canc)),\"seat_attr\":\(VKAPIs.getJSONString(object: DBusResultModel.busSeatAttributDetails))","payment_type":"EBS","customer_id":"".getUserId(),"promo_code":selectedPromo?.promoCode ?? "","promo_code_discount_val": String(DBusResultModel.bus_discount)] as [String : Any]
//
        
        
        var paramString: [String: String] = [:]
        paramString["confirm_book"] =  VKAPIs.getJSONString(object: params)
        paramString["wallet_bal"] = "off"
        navigateToReview(params: paramString)
        
    }

    func createToken() -> [String: Any] {

//        var dictionary: OrderedDictionary<String, Any> = [:]
//            dictionary["one"] = 1
//            dictionary["two"] = 2
//            dictionary["three"] = nil
//        print(dictionary)
//
        let dict: [String : Any] = [
            "RouteScheduleId" : DBusResultModel.selectedBus?.RouteScheduleId! ?? "",
            "JourneyDate" : DBusResultModel.selectedBus?.DeptTime ?? "",
            "PickUpID" : DBusResultModel.selected_boarding.pickupCode ?? "",
            "DropID" : DBusResultModel.selected_dropOff.dropoffCode ?? "",
            "DepartureTime" : DBusResultModel.selectedBus?.DepartureTime! ?? "",
            "ArrivalTime" : DBusResultModel.selectedBus?.ArrivalTime ?? "",
            "departure_from" : DBusResultModel.selectedBus?.From ?? "",
            "arrival_to" : DBusResultModel.selectedBus?.To ?? "",
            "Form_id" : DBTravelModel.destinationCity["id"] ?? "",
            "To_id" : DBTravelModel.sourceCity["id"] ?? "",
            "boarding_from" : "\(DBusResultModel.selected_boarding.pickupName ?? ""), Address : \(DBusResultModel.selected_boarding.address ?? ""), Landmark : \(DBusResultModel.selected_boarding.landmark ?? ""), Phone : \(DBusResultModel.selected_boarding.contact ?? "")",
            "dropping_to" : DBusResultModel.selected_dropOff.dropoffName ?? "",
            "bus_type" : DBusResultModel.selectedBus?.BusTypeName ?? "" ,
            "operator" : DBusResultModel.selectedBus?.CompanyName ?? "",
            "CommAmount" : String(DBusResultModel.selectedBus?.CommAmount ?? 0.0) as CVarArg,
            "CancPolicy" : DBusDetailModel.result.canc,
            "seat_attr" : DBusResultModel.busSeatAttributDetails
        ]

//        let _ : Dictionary<String, Any> = dict

        
        //        print(s)
        
//        var diction = [String: Any]()
//        dict.forEach{
//            diction[$0.0] = $0.1 as! Any?
//        }
//        print(diction)
        
        print(dict)
        
//        let dd : [String : Any] = dict as [String:Any]
//        let string = keyv(object: dict)
//        print(string)
        return dict
    }
    
    func keyv(object: Any) -> String {
        // if object is already string...
        if object is String {
            return object as! String
        }
        do {
            // convert object into data...
            let jsonData = try JSONSerialization.data(withJSONObject: object as! NSDictionary, options: .prettyPrinted)
            // getting jsonString...
            let stringObj = String(data: jsonData, encoding: .utf8)
            return stringObj!
        } catch let error as NSError {
            print("Json object to string failed : \(error.localizedDescription)")
        }
        return ""
    }
    
    func navigateToReview(params: [String: String]){
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusReviewVC") as! BusReviewVC
        vc.paramString = params
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension BusPassengerDetails : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return DBusResultModel.bus_Selected_Seats_list.count// DTransferDetailsModel.ageBands_Array[0].count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddTravellerCell") as? AddTravellerCell
            if cell == nil {
                tableView.register(UINib.init(nibName: "AddTravellerCell", bundle: nil), forCellReuseIdentifier: "AddTravellerCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "AddTravellerCell") as? AddTravellerCell
            }
            cell?.setNeedsLayout()
            cell?.layoutIfNeeded()
            cell?.selectionStyle = .none
            cell?.delegate = self
        
            cell?.tf_firstName.tag = indexPath.row
//        if indexPath == selectedIndexPath {
//            cell.tf_NameTitle =
//        }
        return cell!

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
}
extension BusPassengerDetails {
    func apiBooking(){

        let seats = DBusResultModel.bus_Selected_Seats_list.map{$0.seatNo}
            SwiftLoader.show(animated: true)
            
    //        bus_details
        let params : [String : Any] = [
            "route_schedule_id": DBusResultModel.selectedBus?.RouteScheduleId! ?? "",
            "journey_date": DBusResultModel.selectedBus?.DeptTime ?? "",
            "pickup_id":DBusResultModel.selected_boarding.pickupCode ?? "",
            "ResultToken":DBusDetailModel.result_token ?? "",
            "drop_id":DBusResultModel.selected_dropOff.dropoffCode ?? "",
            "seat": seats ,
            "booking_source": DBusSearchModel.booking_source,
            "token": DBusDetailModel.token ?? ""]
        
            var paramString: [String: String] = ["booking": VKAPIs.getJSONString(object: params)]
            paramString["search_id"] = DBusDetailModel.search_id ?? ""
            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "bus/booking", httpMethod: .POST)
            { (resultObj, success, error) in
                
                // success status...
                if success == true {
                    print("Booking details success: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        
                        if let conv = result["convenience_fees"] as? Float {
                            DBusResultModel.convenienceFee = conv
                        }
                        if let gst = result["gst_value"] as? Float {
                            DBusResultModel.gst = gst
                        }
                        
                        
                    } else {
                        print("Booking details formate : \(String(describing: resultObj))")
                    }
                } else {
                    print("Booking details error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                    self.navigationController?.popViewController(animated: true)
                }
                
                // getting rooms list...
                
                self.displayInfo()
                SwiftLoader.hide()
            }

        
    }
}
