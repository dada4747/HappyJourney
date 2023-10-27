//
//  TransferDetailsVC.swift
//  CheapToGo
//
//  Created by Provab1151 on 30/01/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

class TransferDetailsVC: UIViewController {
    
    @IBOutlet weak var img_package: UIImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_Descp: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var view_detailsMenu: UIView!
    @IBOutlet weak var tbl_details: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    // popup...
    @IBOutlet var view_availabilityPopUp: UIView!
    @IBOutlet weak var view_addTraveller: UIView!
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var lbl_travellerCount: UILabel!
    @IBOutlet weak var tbl_addTraveller: UITableView!
    @IBOutlet weak var tbl_tripList: UITableView!
    
    @IBOutlet weak var view_tripList: UIView!
    @IBOutlet weak var view_HContraint_Trips: NSLayoutConstraint!

    @IBOutlet weak var tbl_HContraint_AddTravellers: NSLayoutConstraint!

    // MARK:- Variables
    var transfer_dict: DTransferSearchItem?
    var additionalInfo_Array: [Any] = []
    
    var menuTab = tablesList.overview
    enum tablesList {
        case overview
        case details
        case impInfo
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view_availabilityPopUp.frame = self.view.frame
        self.view.addSubview(self.view_availabilityPopUp)
        view_availabilityPopUp.isHidden = true
        view_addTraveller.isHidden = true
        
        tbl_details.delegate = self
        tbl_details.dataSource = self
        
        tbl_addTraveller.delegate = self
        tbl_addTraveller.dataSource = self
        
        tbl_tripList.delegate = self
        tbl_tripList.dataSource = self
        
        // getting transfer info...
        //DTransferSearchModel.clearAllTransferSearch_Information()
        transferDetails_APIConnection()
        
        self.tbl_HContraint_AddTravellers.constant = 100
        self.view_HContraint_Trips.constant = 0
        self.view_tripList.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- Helpers
    func displayInformation() {
        
        self.img_package.sd_setImage(with: URL.init(string: String(format: "%@",(DTransferDetailsModel.product_img))), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        self.lbl_productName.text = DTransferDetailsModel.product_name
        self.lbl_Descp.text = ""
        self.lbl_duration.text = "Duration : \(DTransferDetailsModel.duration)"
//        self.lbl_rating.text = DTransferDetailsModel.rating
//        self.lbl_price.text = "USD \(DTransferDetailsModel.product_price )"
//        self.lbl_grandTotal.text = "USD \(DTransferDetailsModel.product_price)"
        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
            let value =  currencyConversion["value"] as? String
            let multipliedValue = (DTransferDetailsModel.product_price) * (Double(value ?? "0.0") ?? 0.0)
            self.lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
            self.lbl_grandTotal.text = symbol + " " + String(format: "%.2f", multipliedValue)
        }
    }
    
    func reloadTransferDetails_Information() {
        
        //transferList_array = DTransferSearchModel.transferCityList_Array
        additionalInfo_Array = DTransferDetailsModel.additionalInfo_Array
        tbl_details.reloadData()
    }
    
    func showTotalTravellersCount(){
        var count = 0
        for item in DTransferDetailsModel.ageBands_Array {
            count += item.count ?? 0
        }
        DispatchQueue.main.async {
            self.lbl_travellerCount.text = "Total Travellers : " + String(count)
        }
    }
    func reloadTripListHeight(){
        self.view_tripList.isHidden = false
        //view_HContraint_Trips.constant = tbl_tripList.contentSize.height + 45
        view_HContraint_Trips.constant = CGFloat(((105 * DTripsListModel.tripList.count)  + 45))

        self.view_tripList.layoutIfNeeded()
        
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonsClicked(_ sender: UIButton) {
        
        // selection tabs...
        for subView in view_detailsMenu.subviews {
            subView.alpha = 0.5
        }
        sender.alpha = 1.0
        
        // buttonActions...
        if sender.tag == 10 {
            menuTab = .overview
            //tbl_HContraint.constant = CGFloat(rooms_array.count * 105)
        }
        else if sender.tag == 11 {
            menuTab = .details
            tbl_HContraint.constant = 140
        }
        else if sender.tag == 12 {
            menuTab = .impInfo
            tbl_HContraint.constant = 190
        }
        else {}
        tbl_details.reloadData()
        
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 0.5)
    }
    
    @objc func tableHeightCalculation() {
        
        tbl_HContraint.constant = tbl_details.contentSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        
        view_availabilityPopUp.isHidden = false
        
//        let sendqueryObj = HolidaysStoryBoard.instantiateViewController(withIdentifier: "HolidayEnquiryVC") as! HolidayEnquiryVC
//        self.navigationController?.pushViewController(sendqueryObj, animated: true)
    }
    @IBAction func dateSelectionBtnClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview
        var fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        fieldRect.size.width = fieldRect.size.width - fieldRect.size.width/2
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate_dates = self
        tbl_popView.DType = .AvailableDates
        tbl_popView.availableDates_array = DTransferDetailsModel.datesAvailability_Array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    @IBAction func addTravellerBtnClicked(_ sender: Any) {
        let count = DTransferDetailsModel.ageBands_Array.count
        view_addTraveller.isHidden = false
        showTotalTravellersCount()
        self.tbl_HContraint_AddTravellers.constant = CGFloat((count * 44) + 46)
        tbl_addTraveller.reloadData()

    }
    
    @IBAction func doneTravellerBtnClicked(_ sender: Any) {
        view_addTraveller.isHidden = true
    }
    
    @IBAction func checkAvailabilityBtnClicked(_ sender: Any) {
        
        view_availabilityPopUp.isHidden = true
        self.transfer_Tourgrade_APIConnection()
        
    }
    @IBAction func dismissPopUpBtnClicked(_ sender: Any) {
        view_availabilityPopUp.isHidden = true
    }
    
}

extension TransferDetailsVC : TransferAvailableDatesDelegate {
    
    func TransferAvailable_Dates(selected_date: Any) {
        txt_date.text = selected_date as? String ?? ""
    }
}

extension TransferDetailsVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_addTraveller {
            return DTransferDetailsModel.ageBands_Array.count
        }else if tableView == tbl_tripList{
            return DTripsListModel.tripList.count
        }else {
            if menuTab == .overview {
               return 1
            } else if menuTab == .details {
                return 1
            } else {
                return additionalInfo_Array.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_addTraveller {
            return 44.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_addTraveller {
            // cell creation....
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransferAgeBandsCell") as? TransferAgeBandsCell
            if cell == nil {
                tableView.register(UINib.init(nibName: "TransferAgeBandsCell", bundle: nil), forCellReuseIdentifier: "TransferAgeBandsCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TransferAgeBandsCell") as? TransferAgeBandsCell
            }
            if let model = DTransferDetailsModel.ageBands_Array[indexPath.row] as? AgeBandsItem{
                cell?.lbl_travellerCount.text = String(model.count ?? 0)
                if model.band_Id == 1 {
                    cell?.lbl_travellerType.text = ((model.description ?? "") + " (Age 12 to 95)")
                }else if model.band_Id == 2{
                    cell?.lbl_travellerType.text = ((model.description ?? "") + " (Age 5 to 11)")
                }else{
                    cell?.lbl_travellerType.text = ((model.description ?? "") + " (Age 0 to 4)")
                }
            }
            cell?.btn_plus.addTarget(self, action:#selector(addTravellerCount), for: .touchUpInside)
            cell?.btn_minus.addTarget(self, action: #selector(minusTravellerCount), for: .touchUpInside)
            cell?.btn_plus.tag = indexPath.row
            cell?.btn_minus.tag = indexPath.row

            cell?.selectionStyle = .none
            return cell!
            
        }else if tableView == tbl_tripList{
            var cell = tableView.dequeueReusableCell(withIdentifier: "TripListTVCell") as? TripListTVCell
            if cell == nil {
                tableView.register(UINib.init(nibName: "TripListTVCell", bundle: nil), forCellReuseIdentifier: "TripListTVCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TripListTVCell") as? TripListTVCell
            }
            
            cell?.displayData1(model: DTripsListModel.tripList[indexPath.row])
            cell?.btn_book.addTarget(self, action:#selector(bookTrip), for: .touchUpInside)
            cell?.btn_book.tag = indexPath.row
            return cell!
        }else {
            
            if menuTab == .overview || menuTab == .details {
            
                // cell creation...
                var cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
                if cell == nil {
                    tableView.register(UINib(nibName: "TransferItineraryCell", bundle: nil), forCellReuseIdentifier: "TransferItineraryCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
                }
                
                if menuTab == .overview {
                    
                    cell?.lbl_title.text = String.init(format: "%@", "Overview")
                    let final_descript = "<div align=\"justify\">\(DTransferDetailsModel.overview_short_descp_text)</div>"
                    cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
                    
                } else {
                    
                    cell?.lbl_title.text = String.init(format: "%@", "Details")
                    let final_descript = "<div align=\"justify\">\(DTransferDetailsModel.product_descrption)</div>"
                    cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
                }

                cell?.selectionStyle = .none
                return cell!
            }
            else {
                /*
                // cell creation...
                var cell = tableView.dequeueReusableCell(withIdentifier: "TransferCustomerReviewCell") as? TransferCustomerReviewCell
                if cell == nil {
                    tableView.register(UINib(nibName: "TransferCustomerReviewCell", bundle: nil), forCellReuseIdentifier: "TransferCustomerReviewCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "TransferCustomerReviewCell") as? TransferCustomerReviewCell
                }
                
                // display information...
                //cell?.displayGallery(array_imgs: gallery_array)
                
                cell?.selectionStyle = .none
                return cell!
                */
                
                // cell creation...
                var cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell") as? AdditionalInfoCell
                if cell == nil {
                    tableView.register(UINib(nibName: "AdditionalInfoCell", bundle: nil), forCellReuseIdentifier: "AdditionalInfoCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell") as? AdditionalInfoCell
                }
                cell?.lbl_infoText.text = additionalInfo_Array[indexPath.row] as? String ?? ""
                
                cell?.selectionStyle = .none
                return cell!
            }
        }
    }
    
    @objc func addTravellerCount(sender: UIButton) {
        print("Add...")
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        DTransferDetailsModel.ageBands_Array[sender.tag].count! += 1
        self.tbl_addTraveller.reloadRows(at: [indexPath], with: .automatic)
        showTotalTravellersCount()
    }
    
    @objc func minusTravellerCount(sender: UIButton) {
        print("Minus...")
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        DTransferDetailsModel.ageBands_Array[sender.tag].count! -= 1
        self.tbl_addTraveller.reloadRows(at: [indexPath], with: .automatic)
        showTotalTravellersCount()


    }
    
    @objc func bookTrip(sender: UIButton) {
        print("book...")
        self.transfer_BlockTrip_APIConnection(index: sender.tag)
    }
}



extension TransferDetailsVC {
    
    // MARK: - Api's
    func transferDetails_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["op": "get_details",
                                        "search_id": DTransferSearchModel.search_id,
                                        "booking_source": DTransferSearchModel.bookingSource,
                                        "product_code": transfer_dict?.product_code ?? "",
                                        "result_token": transfer_dict?.result_token ?? ""]
        
        let paramString: [String: String] = ["transfer_details": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: TRANSFER_Details, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Search Transfer response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let details_dict = result_dict["data"] as? [String: Any] {
                            DTransferDetailsModel.createModels(result_dict: details_dict)
                            self.displayInformation()
                        }
                    } else {
                        if let data = result_dict["data"] as? String {
                            self.view.makeToast(message: data)
                        }
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    print("Search Transfer error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                SwiftLoader.hide()
                self.reloadTransferDetails_Information()
            }
        }
    }
    
    func transfer_Tourgrade_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
//            {"productID":"PRODUCT","product_code":"106330P149","ResultToken":"0539f9dd089224150ad4c12e76a85150*_*35*_*nvSinyR22W5LMsMq","search_id":"86022","booking_engine":"FreesaleBE","booking_date":"2021-08-10","op":"check_tourgrade","booking_source":"PTBSID0000000008","ageBands":[{"bandId":1,"count":1}]}
        
        var ageBands: [Any] = []
        
        for item in DTransferDetailsModel.ageBands_Array{
            let dict = ["bandId": item.band_Id, "count": item.count]
            ageBands.append(dict)
        }
        
        let params: [String: Any] = ["op": "check_tourgrade",
                                     "search_id": DTransferSearchModel.search_id,
                                     "booking_source": DTransferSearchModel.bookingSource,
                                     "product_code": transfer_dict?.product_code ?? "",
                                     "productID":"PRODUCT",
                                     "booking_engine":"FreesaleBE",
                                     "booking_date":txt_date.text ?? "",
                                     "ageBands": ageBands,
                                     "ResultToken": DTransferDetailsModel.resultToken]
        
        let paramString: [String: String] = ["select_tourgrade": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: TRANSFER_Select_Tour_Guide, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Search Transfer response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let details_dict = result_dict["data"] as? [String: Any] {
                            
                            print(details_dict)
                            DTripsListModel.createModels(result_dict: details_dict)
                        }
                    } else {
                        if let data = result_dict["data"] as? String {
                            self.view.makeToast(message: data)
                        }
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
            } else {
                print("Search Transfer error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                SwiftLoader.hide()
                self.tbl_tripList.reloadData()
                self.reloadTripListHeight()

            }
        }
    }
    
    func transfer_BlockTrip_APIConnection(index: Int) -> Void {
        
        SwiftLoader.show(animated: true)
        // params...
//            {"booking_source":"PTBSID0000000008","search_id":"228","product_code":"5079BLRPPL","product_title":"Bangalore Bengaluru Kempegowda International Airport Plaza Premium Lounge","age_band":"W3siYmFuZElkIjoxLCJjb3VudCI6MX0seyJiYW5kSWQiOjIsImNvdW50IjowfSx7ImJhbmRJZCI6MywiY291bnQiOjB9XQ==","op":"block_trip","booking_date":"2019-03-28","additional_info":"WyJDb25maXJtYXRpb24gd2lsbCBiZSByZWNlaXZlZCBhdCB0aW1lIG9mIGJvb2tpbmciLCJMb3VuZ2UgaXMgb3BlbiAyNCBob3VycyBhIGRheSJd","inclusions":"WyJVc2Ugb2Ygc2hvd2VyIGZhY2lsaXRpZXMgKHNlbGVjdCBsb3VuZ2UgbG9jYXRpb25zIG9ubHkpIiwiRm9vZCBhbmQgYmV2ZXJhZ2UiLCJOb24tYWxjb2hvbGljIGRyaW5rcyIsIkNvbWZvcnRhYmxlIHNlYXRpbmcgYXJlYSIsIldpLUZpIGNvbm5lY3Rpb25zIiwiSW50ZXJuYXRpb25hbCBUViBjaGFubmVscywgbmV3c3BhcGVycyBhbmQgbWFnYXppbmVzIiwiRmxpZ2h0IGluZm9ybWF0aW9uIl0=","exclusions":"WyJHcmF0dWl0aWVzIChvcHRpb25hbCkiLCJTcGEgc2VydmljZXMiXQ==","short_desc":"IlJlbGF4IGluIHRoZSBjb21mb3J0IG9mIGEgUGxhemEgUHJlbWl1bSBMb3VuZ2UgYmVmb3JlIHlvdXIgZGVwYXJ0aW5nIGZsaWdodCBmcm9tIEJlbmdhbHVydSBLZW1wZWdvd2RhIEludGVybmF0aW9uYWwgQWlycG9ydC4gTG9jYXRlZCBpbiB0aGUgZG9tZXN0aWMgYW5kIGludGVybmF0aW9uYWwgZGVwYXJ0dXJlIHRlcm1pbmFscywgZWFjaCBzcHJhd2xpbmcgbG91bmdlIG9mZmVycyAyNC1ob3VyIGFtZW5pdGllcyBhbWlkIGEgdHJhbnF1aWwgc2V0dGluZyBvZiBsdXNoIGdyZWVuZXJ5IHdpdGggdGltYmVyIGludGVyaW9ycyBhbmQgZ2xhc3MgY2VpbGluZ3MuIEVuam95IHRoZSBjb252ZW5pZW5jZSBvZiBjb21wbGltZW50YXJ5IGZvb2QgYW5kIGJldmVyYWdlcywgY29tZm9ydGFibGUgc2VhdGluZyBhbmQgc2hvd2VycyB0byBmcmVzaGVuIHVwLiBZb3UgaGF2ZSBhY2Nlc3MgdG8gaGlnaC1zcGVlZCB3aXJlbGVzcyBpbnRlcm5ldCBhcyB3ZWxsIGFzIHNwYSBzZXJ2aWNlcyBhdmFpbGFibGUgZm9yIHB1cmNoYXNlLiBUaHJlZSBwYXNzIG9wdGlvbnMgZ2l2ZSB5b3UgZmxleGliaWxpdHkgZm9yIHRoZSBsZW5ndGggb2YgdGltZSB5b3UgbmVlZCBhdCB0aGUgbG91bmdlLiI=","voucher_req":"bnVsbA==","tour_uniq_id":"ee3afced1802aaf404f593c14503e05d*_*44*_*lZOn2tVJrEYsc6Gs","grade_title":"3 Hour Stay - Domestic","grade_code":"3HRDOM","grade_desc":"Three-hour stay at the Plaza Premium Lounge (Domestic Departures), Bengaluru Kempegowda International Airport"}
        
        
        let params: [String: Any] = ["op": "block_trip",
                                     "search_id": DTransferSearchModel.search_id,
                                     "booking_source": DTransferSearchModel.bookingSource,
                                     "product_code": transfer_dict?.product_code ?? "",
                                     "product_title":transfer_dict?.product_name ?? "",
                                     "age_band":DTripsListModel.ageBand_token,
                                     "booking_date":txt_date.text ?? "",
                                     "additional_info": DTransferDetailsModel.token_Data?.AdditionalInfo,
                                     "inclusions": DTransferDetailsModel.token_Data?.Inclusions,
                                     "exclusions": DTransferDetailsModel.token_Data?.Exclusions,
                                     "short_desc": DTransferDetailsModel.token_Data?.ShortDescription,
                                     "voucher_req": DTransferDetailsModel.token_Data?.voucher_req,
                                     "tour_uniq_id": DTripsListModel.tripList[index].TourUniqueId,
                                     "grade_title": DTripsListModel.tripList[index].gradeTitle,
                                     "grade_code": DTripsListModel.tripList[index].gradeCode,
                                     "grade_desc": DTripsListModel.tripList[index].gradeDescription
        ]
        
        let paramString: [String: String] = ["block_params": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: TRANSFER_Block_Trip, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("TRANSFER_Block_Trip response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let details_dict = result_dict["data"] as? [String: Any] {
                            print(details_dict)
                            DBlockTripsModel.createModels(result_dict: details_dict)
                            
                            let transferDetVc = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransfersReviewViewController") as! TransfersReviewViewController
                            self.navigationController?.pushViewController(transferDetVc, animated: true)
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("TRANSFER_Block_Trip error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                SwiftLoader.hide()
                
            }else{
                print("TRANSFER_Block_Trip error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
                SwiftLoader.hide()
                
            }
        }
    }
}

