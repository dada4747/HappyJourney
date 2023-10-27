//
//  MyBookingsVC.swift
//  CheapToGo
//
//  Created by Anand S on 30/11/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

class MyBookingsVC: UIViewController, BBookingCellDelegate {
    func viewBusBooking(model: DBusHistoryItem) {
        viewBusVoucher(model: model)
    }
    
    func cancelBusBooking(model: DBusHistoryItem) {
        print(model)
//        buses_cancelBookingAPICall()
//        busCancel_APIConnection(model: model)
        buses_cancelBookingAPICall(model: model)
    }
    
    
    @IBOutlet weak var segmentController: CustomSegmentedControl3!
    @IBOutlet weak var tbl_history: UITableView!
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_cancelPopup: UIView!

    var flightArr : [DFlightHistoryItem] = []
    var hotelArr : [DHotelHistoryItem] = []
    var carArr : [DCarHistoryItem] = []
    var transferArr : [DTransferHistoryItem] = []
    var activitiesArr : [DActivitiesHistoryItem] = []
//    var holidaysArr : [DHolidaysHistoryItem] = []
        var busArr:  [DBusHistoryItem] = []


    var selectedCancelIndex = -1
    var selectedViewVuocherIndex = -1
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile) as? [String: Any] ?? [:]
    var segmentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentController.adjustSegmentWidthsForTitles()
        // Do any additional setup after loading the view.
        self.view_cancelPopup.frame = self.view.frame
        self.view.addSubview(view_cancelPopup)
        self.view_cancelPopup.alpha = 0
        
        // bottom shadow...
        view_header.viewShadow()
        flightMyBookings_APIConnection()
        addTblDelegates()
        initSegment()
    }
    func initSegment(){
//        segmentController.backgroundColor = UIColor(red: 19.0/255.0, green: 25.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentController.setTitleTextAttributes(titleTextAttributes, for:.normal)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentController.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        if #available(iOS 13.0, *) {
            segmentController.selectedSegmentTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
    }
    
    func cancelBookingAPICall(){
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        var dict =  ["app_reference":flightArr[selectedCancelIndex].booking_id,"booking_source":flightArr[selectedCancelIndex].booking_source,"transaction_origin":flightArr[selectedCancelIndex].trans_id] as? [String : Any]
        
        let jsonString = VKAPIs.getJSONString(object: dict)
        
        let params: [String: String] = ["flight_cancel": jsonString]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Cancel_FlightBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Cancel_FlightBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.flightMyBookings_APIConnection()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Cancel_FlightBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Cancel_FlightBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayFlightBookingInfo()
        }
    }
    
    func hotel_cancelBookingAPICall(){
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        var dict =  ["book_id":hotelArr[selectedCancelIndex].booking_id,"booking_source":hotelArr[selectedCancelIndex].booking_source] as? [String : String]
                
        // calling api...
        
        VKAPIs.shared.getRequestXwwwform(params: dict!, file: Cancel_HotelBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Cancel_HotelBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.hotelMyBookings_APIConnection()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Cancel_HotelBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Cancel_HotelBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayHotelBookingInfo()
        }
    }
    
    func car_cancelBookingAPICall(){
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        var dict =  ["book_id":carArr[selectedCancelIndex].booking_id,"booking_source":carArr[selectedCancelIndex].booking_source] as? [String : String]
        
        let jsonString = VKAPIs.getJSONString(object: dict)
        
        let params: [String: String] = ["car_cancel": jsonString]
        
        // calling api...
        
        VKAPIs.shared.getRequestXwwwform(params: params, file: car_CancelBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("car_CancelBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.carBookingHistoryApiCall()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("car_CancelBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("car_CancelBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayCarBookingInfo()
        }
    }
    
    func transfer_cancelBookingAPICall(){
        
        CommonLoader.shared.startLoader(in: view)
        // params...


        var dict =  ["app_reference":transferArr[selectedCancelIndex].booking_id,"booking_source":transferArr[selectedCancelIndex].booking_source] as? [String : String]
        
        let jsonString = VKAPIs.getJSONString(object: dict)
        
        let params: [String: String] = ["transfer_cancel": jsonString]
        
        // calling api...
        
        VKAPIs.shared.getRequestXwwwform(params: params, file: TRANSFER_CancelBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("TRANSFER_CancelBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.transferBookingHistoryApiCall()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("TRANSFER_CancelBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("TRANSFER_CancelBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayTransferBookingInfo()
        }
    }
    
    func activities_cancelBookingAPICall(){
        
        CommonLoader.shared.startLoader(in: view)
        // params...


        var dict =  ["app_reference":activitiesArr[selectedCancelIndex].booking_id,"booking_source":activitiesArr[selectedCancelIndex].booking_source] as? [String : String]
        
        let jsonString = VKAPIs.getJSONString(object: dict)
        
        let params: [String: String] = ["sightseeing_cancel": jsonString]
        
        // calling api...
        
        VKAPIs.shared.getRequestXwwwform(params: params, file: Activities_CancelBooking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_CancelBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.activitiesBookingHistoryApiCall()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_CancelBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Activities_CancelBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayActivitiesBookingInfo()
        }
    }
    func buses_cancelBookingAPICall(model: DBusHistoryItem){
        
        CommonLoader.shared.startLoader(in: view)
        // params...


        let dict =  ["app_reference": model.app_reference,"booking_source":model.booking_source] as? [String : String]
        
        let jsonString = VKAPIs.getJSONString(object: dict!)
        
        let params: [String: String] = ["bus_cancel": jsonString]
        
        // calling api...
        
        VKAPIs.shared.getRequestXwwwform(params: params, file: "bus/cancel_booking", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Buses_cancelBooking Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.BusesBookingHistoryApiCall()
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Buses_cancelBooking Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Buses_cancelBooking Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayBusesBookingInfo()
        }
        
    }
//    func busCancel_APIConnection(model: DBusHistoryItem){
//            CommonLoader.shared.startLoader(in: view)
//            // params...
//            let params: [String: String] = ["book_id": model.app_reference ?? "",
//                                            "booking_source": model.booking_source ?? ""]
//    //        var paramString:[String: String] = [:]
//    //        paramString["bus_cancel"] = VKAPIs.getJSONString(object: params)
//            // calling api...
//            VKAPIs.shared.getRequestFormdata(params: params, file: "bus/cancel_booking", httpMethod: .POST)
//            { (resultObj, success, error) in
//                // success status...
//                if success == true {
//                    print("Bus Cancel Booking Response: \(String(describing: resultObj))")
//
//                    if let result_dict = resultObj as? [String: Any] {
//                        if result_dict["status"] as? Bool == true {
//
//                            if let message_str = result_dict["message"] as? String {
//                                self.view.makeToast(message: message_str)
//                            }
//
//                        } else {
//                            // error message...
//                            if let message_str = result_dict["message"] as? String {
//                                self.view.makeToast(message: message_str)
//                            }
//                        }
//                    } else {
//                        print("Bus Cancel Booking Formate : \(String(describing: resultObj))")
//                    }
//                } else {
//                    print("Bus Cancel Booking Error : \(String(describing: error?.localizedDescription))")
//                    self.view.makeToast(message: error?.localizedDescription ?? "")
//                }
//
//                CommonLoader.shared.stopLoader()
//                self.displayBusesBookingInfo()
//            }
//        }
//
    
     // MARK: - Helper
    func addTblDelegates() {
        
        // table delegates...
        tbl_history.delegate = self
        tbl_history.dataSource = self
        tbl_history.rowHeight = UITableView.automaticDimension
        tbl_history.estimatedRowHeight = 140
    }
    
    func displayFlightBookingInfo() {
        
        flightArr.removeAll()
        flightArr = DFlightHistoryModel.flightHistory_Array
        tbl_history.reloadData()
    }
    func displayHotelBookingInfo() {
        
        hotelArr.removeAll()
        hotelArr = DFlightHistoryModel.hotelHistory_Array
        tbl_history.reloadData()
    }
    func displayCarBookingInfo() {
        
        carArr.removeAll()
        carArr = DFlightHistoryModel.carHistory_Array
        tbl_history.reloadData()
    }
    func displayTransferBookingInfo() {
        
        transferArr.removeAll()
        transferArr = DFlightHistoryModel.transferHistory_Array
        tbl_history.reloadData()
    }
    func displayActivitiesBookingInfo() {
        
        activitiesArr.removeAll()
        activitiesArr = DFlightHistoryModel.activitiesHistory_Array
        tbl_history.reloadData()
    }
    func displayBusesBookingInfo() {
        
        busArr.removeAll()
        busArr = DFlightHistoryModel.busHistory_Array
        tbl_history.reloadData()
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancel_NoClicked(_ sender: Any) {
        self.view_cancelPopup.alpha = 0
    }
    @IBAction func cancel_YesClicked(_ sender: Any) {
        self.view_cancelPopup.alpha = 0
        if segmentIndex == 0{
            cancelBookingAPICall()
        }else if segmentIndex == 1{
            hotel_cancelBookingAPICall()
        }else if segmentIndex == 2{
            car_cancelBookingAPICall()
        }else if segmentIndex == 3{
            transfer_cancelBookingAPICall()
        }else if segmentIndex == 4{
            activities_cancelBookingAPICall()
        }else{
//            buses_cancelBookingAPICall()
        }
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        switch segmentController.selectedSegmentIndex {
            
        case 0:
            segmentIndex = 0
            flightMyBookings_APIConnection()
            break
            
        case 1:
            segmentIndex = 1
            hotelMyBookings_APIConnection()
            break
        case 2:
            segmentIndex = 2
            carBookingHistoryApiCall()
            break
        case 3:
            segmentIndex = 3
            transferBookingHistoryApiCall()
            break
        case 4:
            segmentIndex = 4
            activitiesBookingHistoryApiCall()
            break
        case 5:
            segmentIndex = 5
            BusesBookingHistoryApiCall()

        default:
            break;
        
        }
        
    }
    
    @objc func cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    @objc func hotel_cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    @objc func car_cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    @objc func transfer_cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    
    @objc func activities_cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    @objc func buses_cancelClicked(sender:UIButton){
        selectedCancelIndex = sender.tag
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.view_cancelPopup.alpha = 1
       
    }
    @objc func flight_viewVoucherClicked(sender:UIButton){
        selectedViewVuocherIndex = sender.tag
        viewFlighVoucher(model: flightArr[selectedViewVuocherIndex])
    }
    @objc func hotel_viewVoucherClicked(sender: UIButton){
        selectedViewVuocherIndex = sender.tag
        viewHotelVoucher(model: hotelArr[selectedViewVuocherIndex])
    }
    @objc func car_viewVoucherClicked(sender: UIButton){
        selectedViewVuocherIndex = sender.tag
        viewCarVoucher(model: carArr[selectedViewVuocherIndex])
    }
    @objc func activity_viewVoucherClicked(sender: UIButton){
        if segmentIndex == 4 {
            selectedViewVuocherIndex = sender.tag
            viewActivityVoucher(model: activitiesArr[selectedViewVuocherIndex])
        }else{
            selectedViewVuocherIndex = sender.tag
            viewTransferVoucher(model: transferArr[selectedViewVuocherIndex])
        }
        
    }
    @objc func transfer_viewVoucherClicked(sender: UIButton){
        selectedViewVuocherIndex = sender.tag
        viewTransferVoucher(model: transferArr[selectedViewVuocherIndex])
    }
    @objc func bus_viewVoucherClicked(sender: UIButton){
        selectedViewVuocherIndex = sender.tag
    }


    
    
    
}


extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndex == 0{
            return flightArr.count
        }else if segmentIndex == 1{
            return hotelArr.count
        }else if segmentIndex == 2{
            return carArr.count
        }else if segmentIndex == 3{
            return transferArr.count
        }else if segmentIndex == 4{
            return activitiesArr.count
        }else{
            return busArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentIndex == 0{
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
            if cell == nil {
                tableView.register(UINib(nibName: "FBookingCell", bundle: nil), forCellReuseIdentifier: "FBookingCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FBookingCell") as? FBookingCell
            }
            
            cell?.displayFlightHistory_List(historyModel: flightArr[indexPath.row])
            cell?.btn_cancel.tag = indexPath.row
            cell?.btn_voucher.tag = indexPath.row
            cell?.btn_cancel.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
            cell?.btn_voucher.addTarget(self, action: #selector(flight_viewVoucherClicked), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!
        }else if segmentIndex == 1{
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingTVCell") as? HotelBookingTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "HotelBookingTVCell", bundle: nil), forCellReuseIdentifier: "HotelBookingTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HotelBookingTVCell") as? HotelBookingTVCell
            }
            cell?.displayHotelBooking(model: hotelArr[indexPath.row])
            cell?.btn_cancel.tag = indexPath.row
            cell?.btn_voucher.tag = indexPath.row
            cell?.btn_cancel.addTarget(self, action: #selector(hotel_cancelClicked), for: .touchUpInside)
            cell?.btn_voucher.addTarget(self, action: #selector(hotel_viewVoucherClicked), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!
        }else if segmentIndex == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CarBookingTVCell") as? CarBookingTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "CarBookingTVCell", bundle: nil), forCellReuseIdentifier: "CarBookingTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CarBookingTVCell") as? CarBookingTVCell
            }
            cell?.displayHotelBooking(model: carArr[indexPath.row])
            cell?.btn_cancel.tag = indexPath.row
            cell?.btn_voucher.tag = indexPath.row
            cell?.btn_cancel.addTarget(self, action: #selector(car_cancelClicked), for: .touchUpInside)
            cell?.btn_voucher.addTarget(self, action: #selector(car_viewVoucherClicked), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!
        }else if segmentIndex == 3{
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransferBookingTVCell") as? TransferBookingTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "TransferBookingTVCell", bundle: nil), forCellReuseIdentifier: "TransferBookingTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TransferBookingTVCell") as? TransferBookingTVCell
            }
            cell?.displayTransferBooking(model: transferArr[indexPath.row])
            cell?.btn_cancel.tag = indexPath.row
            cell?.btn_voucher.tag = indexPath.row
            cell?.btn_cancel.addTarget(self, action: #selector(transfer_cancelClicked), for: .touchUpInside)
            cell?.btn_voucher.addTarget(self, action: #selector(activity_viewVoucherClicked), for: .touchUpInside)
            cell?.selectionStyle = .none
            return cell!
        }else if segmentIndex == 4{
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransferBookingTVCell") as? TransferBookingTVCell
            if cell == nil {
                tableView.register(UINib(nibName: "TransferBookingTVCell", bundle: nil), forCellReuseIdentifier: "TransferBookingTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TransferBookingTVCell") as? TransferBookingTVCell
            }
            cell?.displayActivitiesBooking(model: activitiesArr[indexPath.row])
            cell?.btn_cancel.tag = indexPath.row
            cell?.btn_voucher.tag = indexPath.row
            cell?.btn_cancel.addTarget(self, action: #selector(activities_cancelClicked), for: .touchUpInside)
            cell?.btn_voucher.addTarget(self, action: #selector(activity_viewVoucherClicked), for: .touchUpInside)
            
            cell?.selectionStyle = .none
            return cell!
        }else{
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
            if cell == nil {
                tableView.register(UINib(nibName: "BusHistoryCell", bundle: nil), forCellReuseIdentifier: "BusHistoryCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "BusHistoryCell") as? BusHistoryCell
            }
            cell?.displayBusList(busModel: busArr[indexPath.row])
            cell?.delegate = self
            cell?.selectionStyle = .none
//            if bookingType == .Past {
//                cell?.btncancelbooking.isHidden = true
//            }

            return cell!

        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segmentIndex == 0{
            return 200
        }else if segmentIndex == 1{
            return 195
        }else if segmentIndex == 2{
            return 200
        }else{
            return UITableView.automaticDimension
        }
    }
}

extension MyBookingsVC {
    
    func flightMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
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
                        if let data_array = result_dict["flights"] as? [[String: Any]] {
                            
                            DFlightHistoryModel.createFlightMyBookingsModels(result_array: data_array)
                        }
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
            
            CommonLoader.shared.stopLoader()
            self.displayFlightBookingInfo()
        }
    }
    func hotelMyBookings_APIConnection() -> Void {
        
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Hotel_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let obj = result_dict["hotels"] as? [[String: Any]] {
//                        if let data = obj["data"] as? [String: Any] {
//                            if let data_array = data["booking_details"] as? [[String: Any]]{
                                DFlightHistoryModel.createHotelMyBookingsModels(result_array: obj)
//                            }
//                        }
                        
                        
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
            
            CommonLoader.shared.stopLoader()
            self.displayHotelBookingInfo()
        }
    }
    
    func carBookingHistoryApiCall(){
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: car_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Car Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let obj = result_dict["cars"] as? [String: Any] {
                        if let data = obj["data"] as? [String: Any] {
                            if let data_array = data["booking_details"] as? [[String: Any]]{
                                DFlightHistoryModel.createCarMyBookingsModels(result_array: data_array)
                            }
                        }
                        
                        
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Car Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Car Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayCarBookingInfo()
        }
    }
    
    func transferBookingHistoryApiCall(){
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: TRANSFER_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Transfer Booking History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let obj = result_dict["transfer"] as? [String: Any] {
                        if let data_array = obj["booking_details"] as? [[String: Any]]{
                            DFlightHistoryModel.createTransferMyBookingsModels(result_array: data_array)
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Transfer Booking History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Transfer Booking History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayTransferBookingInfo()
        }
    }
    
    func activitiesBookingHistoryApiCall(){
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Activities_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_History Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let obj = result_dict["activity"] as? [String: Any] {
                        if let data = obj["data"] as? [String: Any]{
                            if let data_array = data["booking_details"] as? [[String: Any]]{
                                DFlightHistoryModel.createActivitiesMyBookingsModels(result_array: data_array)
                            }
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_History Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Activities_History Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayActivitiesBookingInfo()
        }
    }
    
    func BusesBookingHistoryApiCall(){
        let user_id = ""
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        let params: [String: String] = ["user_id": user_id.getUserId()]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: Bus_History, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Buses_bookingHistory Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let obj = result_dict["bus"] as? [[String: Any]] {
//                        if let dataArr = obj["data"] as? [[String: Any]]{
                        
                        DFlightHistoryModel.createBusesMyBookingsModels(result_array: obj)
                        
                        
//                            if let data_array = data["booking_details"] as? [[String: Any]]{
//                                DFlightHistoryModel.createHolidayssMyBookingsModels(result_array: data_array)
//                            }
//                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Buses_bookingHistory Formate : \(String(describing: resultObj))")
                }
            } else {
                print("Buses_bookingHistory Error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
            self.displayBusesBookingInfo()
        }
    }
    func viewFlighVoucher(model: DFlightHistoryItem) {
            let url = "\(TMX_Base_URL)/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
    //    /voucher/flight/FB25-162445-939144/PTBSID0000000002/BOOKING_INPROGRESS/show_pdf
            let downloadUrl =  "https://happyjourney.life/index.php/voucher/flight/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
            navigateToVoucher(url: url,downloadUrl: downloadUrl, id: model.booking_id!)
    
        }
    func navigateToVoucher(url: String, downloadUrl: String, id: String){
            let pay_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HistoryVoucherVC") as! HistoryVoucherVC
            pay_vc.payment_url = url
            pay_vc.download_url = downloadUrl
            pay_vc.booking_id = id
            self.navigationController?.pushViewController(pay_vc, animated: true)
        }
    func viewHotelVoucher(model: DHotelHistoryItem) {
        let url  = "\(TMX_Base_URL)/voucher/hotel/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
            let downloadUrl  = "https://happyjourney.life/index.php/voucher/hotel/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
            navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
        }
    func viewCarVoucher(model: DCarHistoryItem){
        let url  = "\(TMX_Base_URL)/voucher/car/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
            let downloadUrl  = "https://happyjourney.life/index.php/voucher/car/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
            navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    func viewTransferVoucher(model: DTransferHistoryItem){
        let url  = "\(TMX_Base_URL)/voucher/transferv1/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
            let downloadUrl  = "\(TMX_Base_URL)/voucher/transferv1/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
            navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    func viewActivityVoucher(model: DActivitiesHistoryItem){
        let url  = "\(TMX_Base_URL)/voucher/sightseeing/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_voucher"
            let downloadUrl  = "\(TMX_Base_URL)/voucher/sightseeing/\(model.booking_id!)/\(model.booking_source!)/\(model.booking_status!)/show_pdf"
            navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.booking_id!)
    }
    func viewBusVoucher(model: DBusHistoryItem){
                let url  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_voucher"
                let downloadUrl  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_pdf"
                navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.ticket!)
        
    }
}
extension MyBookingsVC {
    //view vouchers
    //bus
    //        let url  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_voucher"
    //        let downloadUrl  = "\(TMX_Base_URL)/voucher/bus/\(model.app_reference!)/\(model.booking_source!)/\(model.status!)/show_pdf"
    //        navigateToVoucher(url: url, downloadUrl: downloadUrl, id: model.ticket!)
    
    
    
    
    
    
}

extension UISegmentedControl {
    
    func adjustSegmentWidthsForTitles() {
        var totalWidth: CGFloat = 0.0
        
        // Calculate the total width required for all segments based on their titles
        for i in 0..<self.numberOfSegments {
            if let title = self.titleForSegment(at: i) {
                // Calculate the width required for the current title
                let titleSize = (title as NSString).size(withAttributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0) // Adjust the font size as needed
                ])
                
                // Add some padding (optional)
                let segmentWidth = titleSize.width + 16.0 // Adjust the padding as needed
                
                // Add the width of the current segment to the total width
                totalWidth += segmentWidth
            }
        }
        
        // Adjust the width of each segment based on their calculated widths
        for i in 0..<self.numberOfSegments {
            if let title = self.titleForSegment(at: i) {
                let titleSize = (title as NSString).size(withAttributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0) // Adjust the font size as needed
                ])
                
                let segmentWidth = titleSize.width + 16.0 // Adjust the padding as needed
                
                // Calculate the relative width percentage for each segment
                let relativeWidth = segmentWidth / totalWidth
                
                // Set the width for the current segment
                self.setWidth(self.frame.width * relativeWidth, forSegmentAt: i)
            }
        }
    }
}
class CustomSegmentedControl3: UISegmentedControl {
    private let segmentInset: CGFloat = 5       //your inset amount
    var segmentImage: UIImage? = UIImage(color: .secInteraciaBlue)    //your color
    var forgroundColr: UIColor? = UIColor.white
    
    var unselectedcolr: UIColor? = UIColor.black
    override func layoutSubviews(){
        super.layoutSubviews()
//        applyLocalization()
        if #available(iOS 13.0, *) {
            
            self.setTitleTextAttributes([.foregroundColor: unselectedcolr!, .font: UIFont(name:"Aeonik-Medium",size: 16.33)!], for: .normal)
            self.setTitleTextAttributes([.foregroundColor: forgroundColr!,.font: UIFont(name:"Aeonik-Medium",size: 16.33)!], for: .selected)
            self.selectedSegmentTintColor = UIColor.red
//            setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Roboto-Medium",size: 16.33)!], for: .focused)
//            setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Roboto-Medium",size: 16.33)!], for: .selected)

            //            setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name:"Roboto-Medium",size: 16.33)!], for: .selected)
            
        } else {
            self.tintColor = UIColor.blue
        }
//        self.titleTextAttributes(for: UIControl.State.)
        layer.cornerRadius = 8
        //        layer.borderColor = UIColor.black.cgColor
        
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = 8// foregroundImageView.bounds.height/2
        }
    }
//    func applyLocalization(){
//        self.setTitle(Localization(key: "Round Trip"), forSegmentAt: 0)
//        self.setTitle(Localization(key: "One Way"), forSegmentAt: 1)
//        self.setTitle(Localization(key: "Multi City"), forSegmentAt: 2)
//    }
}

extension UIImage{
    
    //creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
