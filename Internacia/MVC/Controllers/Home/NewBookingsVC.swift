//
//  NewBookingsVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

class NewBookingsVC: UIViewController, BBookingCellDelegate {
    func viewBusBooking(model: DBusHistoryItem) {
        let url  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_voucher"
        let downloadUrl  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_pdf"
        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.ticket!)
    }
    
    func cancelBusBooking(model: DBusHistoryItem) {
        busCancel_APIConnection(model: model)
    }
    
    var index : Int = 0
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tbl_history: UITableView!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var messageview: UIView!
    var profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    var flightArr : [DFlightHistoryItem] = []
    var hotelArr : [DHotelHistoryItem] = []
    var busArr:  [DBusHistoryItem] = []
    var from : String?
    var bookingType = MyBookings.Upcomming
    enum MyBookings {
        case Upcomming
        case Past
        case Cancelled
    }
    @IBOutlet weak var interfaceSegmented: CustomSegmentedControl!{
           didSet{
               interfaceSegmented.setButtonTitles(buttonTitles: ["Flights","Hotels","Buses"])
               interfaceSegmented.selectorViewColor = .secInteraciaBlue
               interfaceSegmented.selectorTextColor = .secInteraciaBlue
           }
       }
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
       override func viewDidLoad() {
           super.viewDidLoad()
           if profile_dict != nil {
               messageview.isHidden = true
           } else {
               messageview.isHidden = false
           }
           if from == "menu" {
               btnBack.isHidden = false
           } else {
               btnBack.isHidden = true
           }
           
           interfaceSegmented.delegate = self
           flightMyBookings_APIConnection()
           addTblDelegates()
           segmentController.layer.cornerRadius = 0.0
           segmentController.layer.borderWidth = 0
           segmentController.layer.borderColor = UIColor.clear.cgColor
           segmentController.layer.masksToBounds = true
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
    func addTblDelegates() {
        
        // table delegates...
        tbl_history.delegate = self
        tbl_history.dataSource = self
        tbl_history.rowHeight = UITableView.automaticDimension
        tbl_history.estimatedRowHeight = 200
    }
    func displayFlightBookingInfo() {
        flightArr.removeAll()
        if bookingType == .Upcomming{
            flightArr = DFlightBookingHistoryModel.past_flight_bookings
        }else if bookingType == . Past {
            flightArr = DFlightBookingHistoryModel.upcoming_flight_bookings
        }else if bookingType == .Cancelled {
            flightArr = DFlightBookingHistoryModel.cancelled_flight_bookings
        }
        tbl_history.reloadData()
    }
    
    func displayHotelBookingInfo() {
        hotelArr.removeAll()
        if bookingType == .Upcomming {
            hotelArr = DHotelBookingHistoryModel.upcoming_hotel_bookings
        }else if bookingType == . Past {
            hotelArr = DHotelBookingHistoryModel.past_hotel_bookings
        }else if bookingType == .Cancelled {
            hotelArr = DHotelBookingHistoryModel.cancelled_hotel_bookings
        }
        tbl_history.reloadData()
    }
    func displayBusBookingInfo(){
        busArr.removeAll()
        if bookingType == .Upcomming {
            busArr = DBusBookingHistoryModel.upcomming_bus_bookings
        }else if bookingType == . Past {
            busArr = DBusBookingHistoryModel.past_bus_bookings
        }else if bookingType == .Cancelled {
            busArr = DBusBookingHistoryModel.cancelled_bus_bookings
        }
        tbl_history.reloadData()
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        if index == 0 {
            flightArr.removeAll()
            if segmentController.selectedSegmentIndex == 0  {
                flightArr = DFlightBookingHistoryModel.past_flight_bookings
                            bookingType = MyBookings.Upcomming

            } else if segmentController.selectedSegmentIndex == 1  {
                flightArr = DFlightBookingHistoryModel.upcoming_flight_bookings
                            bookingType = MyBookings.Past

            } else if segmentController.selectedSegmentIndex == 2  {
                flightArr = DFlightBookingHistoryModel.cancelled_flight_bookings
                            bookingType = MyBookings.Cancelled

            }else{}
            
            tbl_history.reloadData()

        } else if index == 1 {
            
            hotelArr.removeAll()
            if segmentController.selectedSegmentIndex == 0 {
                hotelArr = DHotelBookingHistoryModel.upcoming_hotel_bookings
                bookingType = MyBookings.Upcomming
            } else if segmentController.selectedSegmentIndex == 1 {
                hotelArr = DHotelBookingHistoryModel.past_hotel_bookings
                bookingType = MyBookings.Past
            } else if segmentController.selectedSegmentIndex == 2 {
                hotelArr = DHotelBookingHistoryModel.cancelled_hotel_bookings
                bookingType = MyBookings.Cancelled
            } else{}

            tbl_history.reloadData()
        } else if index == 2 {
            
            busArr.removeAll()
            if segmentController.selectedSegmentIndex == 0 {
                busArr = DBusBookingHistoryModel.upcomming_bus_bookings
                bookingType = MyBookings.Upcomming
            } else if segmentController.selectedSegmentIndex == 1 {
                busArr = DBusBookingHistoryModel.past_bus_bookings
                bookingType = MyBookings.Past
            } else if segmentController.selectedSegmentIndex == 2 {
                busArr = DBusBookingHistoryModel.cancelled_bus_bookings
                bookingType = MyBookings.Cancelled
            } else{}

            tbl_history.reloadData()
        }
         
    }

}


extension NewBookingsVC : CustomSegmentedControlDelegate {
    func change(to index: Int) {
//        print(index)
        self.index = index
        switch index {
            
        case 0:
            flightMyBookings_APIConnection()
        case 1:
            hotelMyBookings_APIConnection()

        case 2:
            busMyBookings_APIConnection()

            
        default:
            break;
        }
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


extension NewBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if index == 0 {
            return 183
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index == 1 {
            return hotelArr.count
        } else if index == 0 {
            return flightArr.count
        } else {
            return busArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if index == 1 {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HBookingCell") as? HBookingCell
            if cell == nil {
                tableView.register(UINib(nibName: "HBookingCell", bundle: nil), forCellReuseIdentifier: "HBookingCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HBookingCell") as? HBookingCell
            }
            // display information...
            cell?.displayHotelBooking(model: hotelArr[indexPath.row])
            
            cell?.delegate = self
            cell?.selectionStyle = .none
            if bookingType == .Past {
                cell?.btn_cancelBooking.isHidden = true
            }

            return cell!
            
        }else if index == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
            if cell == nil {
                tableView.register(UINib(nibName: "FBookingCell", bundle: nil), forCellReuseIdentifier: "FBookingCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
            }

            cell?.displayFlightHistory_List(historyModel: flightArr[indexPath.row])
            cell?.delegate = self
            cell?.selectionStyle = .none
            if bookingType == .Past {
                cell?.btn_cancelBooking.isHidden = true
            }

            return cell!
        } else {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
            if cell == nil {
                tableView.register(UINib(nibName: "BusHistoryCell", bundle: nil), forCellReuseIdentifier: "BusHistoryCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
            }
            cell?.displayBusList(busModel: busArr[indexPath.row])
            cell?.delegate = self
            cell?.selectionStyle = .none
            if bookingType == .Past {
                cell?.btncancelbooking.isHidden = true
            }

            return cell!
        }
    }
}


//MARK:- Delegates
extension NewBookingsVC: HBookingCellDelegate, FBookingCellDelegate {
    func viewTransferVoucher(model: DTransferHistoryItem) {
        
    }
    
    func cancelVoucher(model: DTransferHistoryItem) {
        
    }
    
    func navigateToVoucher(url: String, downloadUrl: String, id: String){
        let pay_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HistoryVoucherVC") as! HistoryVoucherVC
        pay_vc.payment_url = url
        pay_vc.download_url = downloadUrl
        pay_vc.booking_id = id
        self.navigationController?.pushViewController(pay_vc, animated: true)
    }
    func viewFlighVoucher(model: DFlightHistoryItem) {
        let url = "\(TMX_Base_URL)/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
        let downloadUrl =  "\(TMX_Base_URL)/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
        navigateToVoucher(url: url,downloadUrl: downloadUrl, id: model.booking_id!)
        
    }
    func viewHotelVoucher(model: DHotelHistoryItem) {
        let url  = "\(TMX_Base_URL)/voucher/hotel/\(model.app_reference!)/\(model.bookingSource!)/\(model.status!)/show_voucher"
        let downloadUrl  = "\(TMX_Base_URL)/voucher/hotel/\(model.app_reference!)/\(model.bookingSource!)/\(model.status!)/show_pdf"
        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    func viewTransferVoucher(model: DBusHistoryItem) {
//        let url  = "\(TMX_Base_URL)/voucher/transferv1/\(model.app_reference!)/\(model.booking_source ?? "")/\(model.status!)/show_voucher"
//        let downloadUrl = "\(TMX_Base_URL)/voucher/transferv1/\(model.app_reference!)/\(model.booking_source ?? "")/\(model.status!)/show_pdf"
//        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    
    func cancelBookings(){
        
    }
    
    func cancelFlightBooking(model: DFlightHistoryItem) {
        let showAlert = UIAlertController.init(title: "Alert!", message: String.init(format: "Do you want cancel the booking"), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            // delete passenger...
            self.flightCancelApi(model: model)
        })
        showAlert.addAction(okAction)
        showAlert.addAction(UIAlertAction.init(title:  "No", style: .cancel, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    
    func cancelBooking(model: DHotelHistoryItem) {
        let showAlert = UIAlertController.init(title: "Alert!", message: String.init(format: "Do you want cancel the booking"), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            // delete passenger...
            self.hotelCancel_APIConnection(model: model)
        })
        showAlert.addAction(okAction)
        showAlert.addAction(UIAlertAction.init(title:  "No", style: .cancel, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    
    
    func cancelVoucher(model: DBusHistoryItem) {
        let showAlert = UIAlertController.init(title: "Alert!",
                                                 message: String.init(format: "Do you want cancel the booking"),
                                                 preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Yes", style: .default, handler: { (action:UIAlertAction) in
            
            // delete passenger...
            self.busCancel_APIConnection(model: model)
        })
        showAlert.addAction(okAction)
        showAlert.addAction(UIAlertAction.init(title:  "No", style: .cancel, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
    }
    
}

//MARK:- Api calls
extension NewBookingsVC {
    
    func flightMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Flight_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Flight Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        DFlightBookingHistoryModel.createFlightHistoryModels(result_array: result_dict)
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Flight Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayFlightBookingInfo()
        }
    }
    
    func hotelMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Hotel_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
//                    if result_dict["status"] as? Bool == true {
                    DHotelBookingHistoryModel.createHotelHistoryModels(result_array: result_dict)
//                        if let hotel_dict = result_dict["hotels"] as? [String: Any] {
//                            if let data_dict = hotel_dict["data"] as? [String: Any] {
//                                if let data_array = data_dict["booking_details"] as? [[String: Any]] {
//                                    DBookingHistoryModel.createHotelMyBookingsModels(result_array: data_array)
//                                }
//                            }
//                        }
//                    } else {
//                        // error message...
//                        if let message_str = result_dict["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
                } else {
                    print("Hotel Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayHotelBookingInfo()
        }
    }
    func busMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        SwiftLoader.show(animated: true)
        
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Bus_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
//                    if result_dict["status"] as? Bool == true {
                    DBusBookingHistoryModel.createBusHistoryModels(result_array: result_dict)
//                        if let hotel_dict = result_dict["hotels"] as? [String: Any] {
//                            if let data_dict = hotel_dict["data"] as? [String: Any] {
//                                if let data_array = data_dict["booking_details"] as? [[String: Any]] {
//                                    DBookingHistoryModel.createHotelMyBookingsModels(result_array: data_array)
//                                }
//                            }
//                        }
//                    } else {
//                        // error message...
//                        if let message_str = result_dict["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
                } else {
                    print("Bus Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.displayBusBookingInfo()
        }
    }
    //MARK:- Cancellations
    func flightCancelApi(model: DFlightHistoryItem){
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["app_reference": model.booking_id ?? "",
                                        "booking_source": model.booking_source ?? "","transaction_origin": model.origin ?? ""]
        var paramString:[String: String] = [:]
        paramString["flight_cancel"] = VKAPIs.getJSONString(object: params)
        // calling api...
        VKAPIs.shared.getRequestFormdata(params: paramString, file: "flight/cancel_booking", httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Flight Cancel Booking Response: \(String(describing: resultObj))")

                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {

                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }

                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Flight Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Flight Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }

            SwiftLoader.hide()
            self.flightMyBookings_APIConnection()
        }
    }
    
    func hotelCancel_APIConnection(model: DHotelHistoryItem){
//        let user_id = ""
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["book_id": model.app_reference ?? "",
                                        "booking_source": model.bookingSource ?? ""]
        // calling api...
        VKAPIs.shared.getRequestFormdata(params: params, file: "hotel/cancel_booking_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Hotel Cancel Booking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
            self.hotelMyBookings_APIConnection()
        }
    }
    func busCancel_APIConnection(model: DBusHistoryItem){
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["book_id": model.app_reference ?? "",
                                        "booking_source": model.booking_source ?? ""]
//        var paramString:[String: String] = [:]
//        paramString["bus_cancel"] = VKAPIs.getJSONString(object: params)
        // calling api...
        VKAPIs.shared.getRequestFormdata(params: params, file: "bus/cancel_booking_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            // success status...
            if success == true {
                print("Bus Cancel Booking Response: \(String(describing: resultObj))")

                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {

                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }

                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Bus Cancel Booking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus Cancel Booking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }

            SwiftLoader.hide()
            self.flightMyBookings_APIConnection()
        }
    }
}








protocol CustomSegmentedControlDelegate: class {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    
    var textColor:UIColor = .black
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red
    
    weak var delegate:CustomSegmentedControlDelegate?
    
    public private(set) var selectedIndex : Int = 0
    
    convenience init(frame:CGRect,buttonTitle:[String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }
    
    func setButtonTitles(buttonTitles:[String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }
    
    func setIndex(index:Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}


//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }
    
    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 3))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }
    
    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    
}
