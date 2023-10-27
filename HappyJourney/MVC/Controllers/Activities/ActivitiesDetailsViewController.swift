//
//  ActivitiesDetailsViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 09/08/21.
//

import UIKit

class ActivitiesDetailsViewController: UIViewController {
    
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
    var transfer_dict: DActivitySearchItem?
    var additionalInfo_Array: [Any] = []
    var search_id: Int = 0
    
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
        activitiesDetails_APIConnection()
        
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
        
        self.img_package.sd_setImage(with: URL.init(string: String(format: "%@",(DActivitiesDetailsModel.product_img))), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        self.lbl_productName.text = DActivitiesDetailsModel.product_name
        self.lbl_Descp.text = ""
        self.lbl_duration.text = "Duration : \(DActivitiesDetailsModel.duration)"
//        self.lbl_rating.text = DActivitiesDetailsModel.rating
//        self.lbl_price.text = "USD \(DActivitiesDetailsModel.product_price )"
//        self.lbl_grandTotal.text = "USD \(DActivitiesDetailsModel.product_price)"
        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
            let value =  currencyConversion["value"] as? String
            let multipliedValue = (DActivitiesDetailsModel.product_price) * (Double(value ?? "0.0") ?? 0.0)
            self.lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
            self.lbl_grandTotal.text = symbol + " " + String(format: "%.2f", multipliedValue)
        }
    }
    
    func reloadTransferDetails_Information() {
        
        //transferList_array = DTransferSearchModel.transferCityList_Array
        additionalInfo_Array = DActivitiesDetailsModel.additionalInfo_Array
        tbl_details.reloadData()
    }
    
    func showTotalTravellersCount(){
        var count = 0
        for item in DActivitiesDetailsModel.ageBands_Array {
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
        tbl_popView.availableDates_array = DActivitiesDetailsModel.datesAvailability_Array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    @IBAction func addTravellerBtnClicked(_ sender: Any) {
        let count = DActivitiesDetailsModel.ageBands_Array.count
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

extension ActivitiesDetailsViewController : TransferAvailableDatesDelegate {
    
    func TransferAvailable_Dates(selected_date: Any) {
        txt_date.text = selected_date as? String ?? ""
    }
}

extension ActivitiesDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_addTraveller {
            return DActivitiesDetailsModel.ageBands_Array.count
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
            if let model = DActivitiesDetailsModel.ageBands_Array[indexPath.row] as? AgeBandsItem{
                cell?.lbl_travellerCount.text = String(model.count ?? 0)
                if model.band_Id == 1{
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
                    let final_descript = "<div align=\"justify\">\(DActivitiesDetailsModel.overview_short_descp_text)</div>"
                    cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
                    
                } else {
                    
                    cell?.lbl_title.text = String.init(format: "%@", "Details")
                    let final_descript = "<div align=\"justify\">\(DActivitiesDetailsModel.product_descrption)</div>"
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
        DActivitiesDetailsModel.ageBands_Array[sender.tag].count! += 1
        self.tbl_addTraveller.reloadRows(at: [indexPath], with: .automatic)
        showTotalTravellersCount()
    }
    
    @objc func minusTravellerCount(sender: UIButton) {
        print("Minus...")
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        DActivitiesDetailsModel.ageBands_Array[sender.tag].count! -= 1
        self.tbl_addTraveller.reloadRows(at: [indexPath], with: .automatic)
        showTotalTravellersCount()


    }
    
    @objc func bookTrip(sender: UIButton) {
        print("book...")
        self.transfer_BlockTrip_APIConnection(index: sender.tag)
    }
}



extension ActivitiesDetailsViewController {
    
    // MARK: - Api's
    func activitiesDetails_APIConnection() -> Void {
        var apiName = Activities_Details
        apiName += "?op=get_details&booking_source=PTBSID0000000006&search_id=\(self.search_id)&result_token=\(transfer_dict?.ResultToken ?? "")&product_code=\(transfer_dict?.ProductCode ?? "")"
        CommonLoader.shared.startLoader(in: view)
        
        // calling api...
        VKAPIs.shared.getRequest(file:apiName, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Details success: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let details_dict = result_dict["data"] as? [String: Any] {
                            DActivitiesDetailsModel.createModels(result_dict: details_dict)
                            self.displayInformation()
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    print("Activities_Details formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            CommonLoader.shared.stopLoader()
            self.reloadTransferDetails_Information()
        }
    }
    
    func transfer_Tourgrade_APIConnection() -> Void {
        
//        CommonLoader.shared.startLoader(in: view)
//        // params...
//        var params: [String: Any] = ["op": "check_tourgrade",
//                                     "search_id": self.search_id,
//                                        "booking_source": "PTBSID0000000006",
//                                        "product_code": transfer_dict?.ProductCode ?? "",
//                                        "productID":"PRODUCT",
//                                        "booking_engine":"FreesaleBE",
//                                        "ResultToken": DActivitiesDetailsModel.resultToken,
//                                        "get_date": 0,
//                                        "get_month": 0,
//                                        "get_year": 0,
//                                        "Adult_Band_ID": 1,
//                                        "no_of_Adult": 0,
//                                        "Child_Band_ID": 2,
//                                        "no_of_Child": 0,
//                                        "Infant_Band_ID": 3,
//                                        "no_of_Infant": 0,
//                                        "max_count": DActivitiesDetailsModel.MaxTravellerCount
//                                       ]
//        let dateArr = txt_date.text?.split{$0 == "-"}.map(String.init)
//        if dateArr?.count == 3 {
//            params["get_date"] = Int(dateArr?[0] ?? "")
//            params["get_month"] = Int(dateArr?[1] ?? "")
//            params["get_year"] = Int(dateArr?[2] ?? "")
//        }
//
//        for item in DActivitiesDetailsModel.ageBands_Array{
//            if item.band_Id == 1{
//                params["no_of_Adult"] = item.count
//            }else if item.band_Id == 2{
//                params["no_of_Child"] = item.count
//            }else if item.band_Id == 3{
//                params["no_of_Infant"] = item.count
//            }else{
//
//            }
//        }
//
//        // calling api...
//        VKAPIs.shared.getRequestFormdata(params: params, file: Activities_Select_Tour_Guide, httpMethod: .POST)
//        { (resultObj, success, error) in
//
//            // success status...
//            if success == true {
//                print("Activities_Select_Tour_Guide response: \(String(describing: resultObj))")
//
//                if let result_dict = resultObj as? [String: Any] {
//                    if result_dict["status"] as? Bool == true {
//                        if let details_dict = result_dict["data"] as? [String: Any] {
//
//                            print(details_dict)
//                            DTripsListModel.createModels(result_dict: details_dict)
//                        }
//                    } else {
//                        if let data = result_dict["data"] as? String {
//                            self.view.makeToast(message: data)
//                        }
//                        // error message...
//                        if let message_str = result_dict["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                } else {
//                    print("Activities_Select_Tour_Guide error : \(String(describing: error?.localizedDescription))")
//                    self.view.makeToast(message: error?.localizedDescription ?? "")
//                }
//
//            }else{
//                print(error.debugDescription)
//            }
//            CommonLoader.shared.stopLoader()
//            self.tbl_tripList.reloadData()
//            self.reloadTripListHeight()
//        }
    }
    
    func transfer_BlockTrip_APIConnection(index: Int) -> Void {
        
//        CommonLoader.shared.startLoader(in: view)
//        var params: [String: Any] = ["op": "block_trip",
//                                     "search_id": self.search_id,
//                                     "booking_source": "PTBSID0000000006",
//                                     "product_code": transfer_dict?.ProductCode ?? "",
//                                     //"product_title":transfer_dict?.ProductName ?? "",
//                                     "booking_date":txt_date.text ?? "",
//                                     "additional_info": DActivitiesDetailsModel.token_Data?.AdditionalInfo,
//                                     "inclusions": DActivitiesDetailsModel.token_Data?.Inclusions,
//                                     "exclusions": DActivitiesDetailsModel.token_Data?.Exclusions,
//                                     "short_desc": DActivitiesDetailsModel.token_Data?.ShortDescription,
//                                     "voucher_req": DActivitiesDetailsModel.token_Data?.voucher_req,
//                                     "tour_uniq_id": DTripsListModel.tripList[index].TourUniqueId,
//                                     "grade_title": DTripsListModel.tripList[index].gradeTitle,
//                                     "grade_code": DTripsListModel.tripList[index].gradeCode,
//                                     //"grade_desc": DTripsListModel.tripList[index].gradeDescription,
//                                     "API_Price": DActivitiesDetailsModel.token_Data?.API_Price,
//                                     "Adult_Band_ID": 1,
//                                     "Child_Band_ID": 2,
//                                     "Infant_Band_ID": 3,
//                                     "no_of_Adult": 0,
//                                     "no_of_Child": 0,
//                                     "no_of_Infant": 0
//        ]
//        
//        for item in DActivitiesDetailsModel.ageBands_Array{
//            if item.band_Id == 1{
//                params["no_of_Adult"] = item.count
//            }else if item.band_Id == 2{
//                params["no_of_Child"] = item.count
//            }else if item.band_Id == 3{
//                params["no_of_Infant"] = item.count
//            }else{
//                
//            }
//        }
//        
//        //let paramString: [String: String] = ["block_params": VKAPIs.getJSONString(object: params)]
//        
//        // calling api...
//        
//        VKAPIs.shared.getRequestFormdata(params: params, file: Activities_Block_Trip, httpMethod: .POST)
//        { (resultObj, success, error) in
//            
//            // success status...
//            if success == true {
//                print("Activities_Block_Trip response: \(String(describing: resultObj))")
//               
//                if let result_dict = resultObj as? [String: Any] {
//                    if let block_trip = result_dict["BlockTrip"] as? [String: Any] {
//                        if block_trip["Status"] as? Bool == false{
//                            let msg = block_trip["Message"] as? String ?? ""
//                            self.view.makeToast(message: msg)
//                            CommonLoader.shared.stopLoader()
//                            return
//                    }
//                }
//                        DBlockTripsModel.createModels(result_dict: result_dict)
//                    let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesReviewViewController") as! ActivitiesReviewViewController
//
//                        self.navigationController?.pushViewController(transferDetVc, animated: true)
////                    if result_dict["status"] as? Bool == true {
////                        if let details_dict = result_dict["data"] as? [String: Any] {
////                            print(details_dict)
////                            DBlockTripsModel.createModels(result_dict: details_dict)
////
////                            let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesReviewViewController") as! ActivitiesReviewViewController
////                            self.navigationController?.pushViewController(transferDetVc, animated: true)
////                        }
////                    } else {
////                        if let data = result_dict["data"] as? String {
////                            self.view.makeToast(message: data)
////                        }
////                        // error message...
////                        if let message_str = result_dict["message"] as? String {
////                            self.view.makeToast(message: message_str)
////                        }
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
////                            self.navigationController?.popViewController(animated: true)
////                        }
////                    }
//                } else {
//                    print("Activities_Block_Trip error : \(String(describing: error?.localizedDescription))")
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

