//
//  ActivitiesDetailsVC2.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 26/08/21.
//

import UIKit

class ActivitiesDetailsVC2: UIViewController {
    @IBOutlet weak var img_package: UIImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_price: UILabel!

    @IBOutlet weak var tbl_importantInfo: UITableView!
    @IBOutlet weak var tbl_addTraveller: UITableView!
    @IBOutlet weak var view_addTraveller: UIView!
    @IBOutlet weak var lbl_travellerCount: UILabel!
    @IBOutlet weak var txt_date: UITextField!

    @IBOutlet weak var tbl_details: UITableView!
    @IBOutlet weak var tbl_overView: UITableView!
    @IBOutlet weak var btn_importantView_expand: UIButton!
    @IBOutlet weak var btn_overView_expand: UIButton!
    @IBOutlet weak var btn_details_expand: UIButton!

    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_HContraint_AddTravellers: NSLayoutConstraint!
    @IBOutlet weak var tbl_HContraint_overView: NSLayoutConstraint!
    @IBOutlet weak var tbl_HContraint_details: NSLayoutConstraint!

    @IBOutlet weak var tbl_tripList: UITableView!
    
    @IBOutlet weak var view_tripList: UIView!
    @IBOutlet weak var view_HContraint_Trips: NSLayoutConstraint!
    @IBOutlet weak var rating_view: FloatRatingView!

    var transfer_dict: DActivitySearchItem?
    var additionalInfo_Array: [Any] = []
    var isOverViewExpand = false
    var isDetailsViewExpand = false
    var isImportantInfoViewExpand = false
    
    var search_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInfo()
        activitiesDetails_APIConnection()
        
        view_addTraveller.isHidden = true
        self.tbl_HContraint_AddTravellers.constant = 0
        
        self.tbl_HContraint.constant = 250
        self.tbl_HContraint_overView.constant = 250
        self.tbl_HContraint_details.constant = 250
        
        self.view_HContraint_Trips.constant = 0
        self.view_tripList.isHidden = true
    }
    func displayInfo(){
        let model = transfer_dict
        self.img_package.sd_setImage(with: URL.init(string: String(format: "%@",(model?.ImageUrl)!)), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        self.lbl_productName.text = model?.ProductName
        //self.lbl_Descp.text = ""
        self.lbl_duration.text = "Duration : \(model?.Duration ?? "")"
//        self.lbl_rating.text = DTransferDetailsModel.rating
        rating_view.rating = Double((model!.StarRating!))
        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model!.TotalDisplayFare)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
    }
    @objc func tableHeightCalculation() {
        
        tbl_HContraint.constant = tbl_importantInfo.contentSize.height + 100

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }
    @objc func heightCalculation_Overview(){
        tbl_HContraint_overView.constant = tbl_overView.contentSize.height + 100
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func heightCalculation_Details(){
        tbl_HContraint_details.constant = tbl_details.contentSize.height + 100
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func displayInformation() {
        
        self.img_package.sd_setImage(with: URL.init(string: String(format: "%@",(DActivitiesDetailsModel.product_img))), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        self.lbl_productName.text = DActivitiesDetailsModel.product_name
        //self.lbl_Descp.text = ""
        self.lbl_duration.text = "Duration : \(DActivitiesDetailsModel.duration)"
//        self.lbl_rating.text = DActivitiesDetailsModel.rating
        rating_view.rating = Double((DActivitiesDetailsModel.rating))
        
        
//        self.lbl_price.text = "USD \(DActivitiesDetailsModel.product_price )"
//        self.lbl_grandTotal.text = "USD \(DActivitiesDetailsModel.product_price)"
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue = (DActivitiesDetailsModel.product_price) * (Double(value ?? "0.0") ?? 0.0)
//            self.lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//            //self.lbl_grandTotal.text = symbol + " " + String(format: "%.2f", multipliedValue)
//        }
        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(DActivitiesDetailsModel.product_price)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
    }
    
    func reloadTransferDetails_Information() {
        
        //transferList_array = DTransferSearchModel.transferCityList_Array
        additionalInfo_Array = DActivitiesDetailsModel.additionalInfo_Array
        self.tbl_importantInfo.reloadData()
        self.tbl_overView.reloadData()
        self.tbl_details.reloadData()
        
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
        view_HContraint_Trips.constant = tbl_tripList.contentSize.height + 55
//        view_HContraint_Trips.constant = CGFloat(((105 * DTripsListModel.tripList.count)  + 45))

//        self.view_tripList.layoutIfNeeded()
        self.view_tripList.layoutIfNeeded()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        tbl_tripList.reloadData()
                DispatchQueue.main.async {
                    self.tbl_tripList.reloadData()
//                    self.tbl_tripList.layoutIfNeeded()
                }


    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        self.tbl_HContraint_AddTravellers.constant = 0
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
    @IBAction func importantInfo_moreBtnClicked(_ sender: Any) {
        //self.tbl_overView.reloadData()
        isImportantInfoViewExpand = !isImportantInfoViewExpand
        if isImportantInfoViewExpand {
            UIView.animate(withDuration: 0.5) {
                self.btn_importantView_expand.transform = CGAffineTransform(rotationAngle: .pi/2)
            }
            self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 0.5)
        }else{
            UIView.animate(withDuration: 0.5) {
                self.btn_importantView_expand.transform = CGAffineTransform.identity
            }
            self.tbl_HContraint.constant = 250
        }

    }
    
    @IBAction func overView_moreBtnClicked(_ sender: Any) {
        //self.tbl_overView.reloadData()
        isOverViewExpand = !isOverViewExpand
        if isOverViewExpand {
            UIView.animate(withDuration: 0.5) {
                self.btn_overView_expand.transform = CGAffineTransform(rotationAngle: .pi/2)
            }
            self.perform(#selector(heightCalculation_Overview), with: nil, afterDelay: 0.5)
        }else{
            UIView.animate(withDuration: 0.5) {
                self.btn_overView_expand.transform = CGAffineTransform.identity
            }
            self.tbl_HContraint_overView.constant = 250
        }

    }
    @IBAction func betails_moreBtnClicked(_ sender: Any) {
        //self.tbl_overView.reloadData()
        isDetailsViewExpand = !isDetailsViewExpand
        if isDetailsViewExpand {
            UIView.animate(withDuration: 0.5) {
                self.btn_details_expand.transform = CGAffineTransform(rotationAngle: .pi/2)
            }
            self.perform(#selector(heightCalculation_Details), with: nil, afterDelay: 0.5)
        }else{
            UIView.animate(withDuration: 0.5) {
                self.btn_details_expand.transform = CGAffineTransform.identity
            }
            self.tbl_HContraint_details.constant = 250
        }

    }
    @IBAction func checkAvailabilityBtnClicked(_ sender: Any) {
        if txt_date.text == "" {
            self.view.makeToast(message: "Please select date")
            return
        }
        self.transfer_Tourgrade_APIConnection()
        
    }
}

extension ActivitiesDetailsVC2 : TransferAvailableDatesDelegate {
    
    func TransferAvailable_Dates(selected_date: Any) {
        txt_date.text = selected_date as? String ?? ""
    }
}
extension ActivitiesDetailsVC2 {
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
        
        CommonLoader.shared.startLoader(in: view)
        // params...
        var params: [String: String] = ["op": "check_tourgrade",
                                        "search_id": String.init(self.search_id),
                                        "booking_source": "PTBSID0000000006",
                                        "product_code": transfer_dict?.ProductCode ?? "",
                                        "productID":"PRODUCT",
                                        "booking_engine":"FreesaleBE",
                                        "ResultToken": DActivitiesDetailsModel.resultToken,
                                        "get_date": String.init(0),
                                        "get_month": String.init(0),
                                        "get_year": String.init(0),
                                        "Adult_Band_ID": String.init(1),
                                        "no_of_Adult": String.init(0),
                                        "Child_Band_ID": String.init(2),
                                        "no_of_Child": String.init(0),
                                        "Infant_Band_ID": String.init(3),
                                        "no_of_Infant": String.init(0),
                                        "max_count": String(DActivitiesDetailsModel.MaxTravellerCount)
                                       ]
        let dateArr = txt_date.text?.split{$0 == "-"}.map(String.init)
        if dateArr?.count == 3 {
            params["get_date"] = dateArr?[0] ?? ""
            params["get_month"] = dateArr?[1] ?? ""
            params["get_year"] = dateArr?[2] ?? ""
        }
        
        for item in DActivitiesDetailsModel.ageBands_Array{
            if item.band_Id == 1{
                params["no_of_Adult"] = String.init(item.count ?? 0)
            }else if item.band_Id == 2{
                params["no_of_Child"] = String.init(item.count!)
            }else if item.band_Id == 3{
                params["no_of_Infant"] = String.init(item.count!)
            }else{
                
            }
        }
                
        // calling api...
        VKAPIs.shared.getRequestFormdata(params: params, file: Activities_Select_Tour_Guide, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Select_Tour_Guide response: \(String(describing: resultObj))")
                
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    print("Activities_Select_Tour_Guide error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                
            }else{
                print(error.debugDescription)
            }
            CommonLoader.shared.stopLoader()
//            DispatchQueue.main.async {
////                self.tbl_tripList.reloadData()
////                tableView.reloadData()
//                self.reloadTripListHeight()
//
//            }
            self.reloadTripListHeight()
            self.reloadTripListHeight()

        }
    }
    
    func transfer_BlockTrip_APIConnection(index: Int) -> Void {
        
        CommonLoader.shared.startLoader(in: view)
        var params: [String: String] = ["op": "block_trip",
                                        "search_id": String.init(self.search_id),
                                     "booking_source": "PTBSID0000000006",
                                     "product_code": transfer_dict?.ProductCode ?? "",
                                     //"product_title":transfer_dict?.ProductName ?? "",
                                     "booking_date":txt_date.text ?? "",
                                        "additional_info": String.init((DActivitiesDetailsModel.token_Data?.AdditionalInfo)!),
                                        "inclusions": String.init((DActivitiesDetailsModel.token_Data?.Inclusions)!),
                                        "exclusions": String.init((DActivitiesDetailsModel.token_Data?.Exclusions)!),
                                        "short_desc": String.init((DActivitiesDetailsModel.token_Data?.ShortDescription)!),
                                        "voucher_req": String.init((DActivitiesDetailsModel.token_Data?.voucher_req)!),
                                     "tour_uniq_id": DTripsListModel.tripList[index].TourUniqueId,
                                     "grade_title": DTripsListModel.tripList[index].gradeTitle,
                                     "grade_code": DTripsListModel.tripList[index].gradeCode,
                                     //"grade_desc": DTripsListModel.tripList[index].gradeDescription,
                                        "API_Price": String.init((DActivitiesDetailsModel.token_Data?.API_Price)!),
                                        "Adult_Band_ID": String.init(1),
                                        "Child_Band_ID": String.init(2),
                                        "Infant_Band_ID": String.init(3),
                                        "no_of_Adult": String.init(0),
                                        "no_of_Child": String.init(0),
                                        "no_of_Infant": String.init(0)
        ]
        
        for item in DActivitiesDetailsModel.ageBands_Array{
            if item.band_Id == 1{
                params["no_of_Adult"] = String.init(item.count!)
            }else if item.band_Id == 2{
                params["no_of_Child"] = String.init(item.count!)
            }else if item.band_Id == 3{
                params["no_of_Infant"] = String.init(item.count!)
            }else{
                
            }
        }
        
        //let paramString: [String: String] = ["block_params": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        
        VKAPIs.shared.getRequestFormdata(params: params, file: Activities_Block_Trip, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Block_Trip response: \(String(describing: resultObj))")
               
                if let result_dict = resultObj as? [String: Any] {
                    if let block_trip = result_dict["BlockTrip"] as? [String: Any] {
                        if block_trip["Status"] as? Bool == false{
                            let msg = block_trip["Message"] as? String ?? ""
                            self.view.makeToast(message: msg)
                            CommonLoader.shared.stopLoader()
                            return
                    }
                }
                        DBlockTripsModel.createModels(result_dict: result_dict)
                    //let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesReviewViewController") as! ActivitiesReviewViewController
                    let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesReviewVC2") as! ActivitiesReviewVC2

                        self.navigationController?.pushViewController(transferDetVc, animated: true)
//                    if result_dict["status"] as? Bool == true {
//                        if let details_dict = result_dict["data"] as? [String: Any] {
//                            print(details_dict)
//                            DBlockTripsModel.createModels(result_dict: details_dict)
//
//                            let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesReviewViewController") as! ActivitiesReviewViewController
//                            self.navigationController?.pushViewController(transferDetVc, animated: true)
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
                } else {
                    print("Activities_Block_Trip error : \(String(describing: error?.localizedDescription))")
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                
            }else{
                print(error.debugDescription)
            }
            CommonLoader.shared.stopLoader()
        }
    }
    
}

extension ActivitiesDetailsVC2 : UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_importantInfo {
            return additionalInfo_Array.count
        }else if tableView == tbl_addTraveller{
            return DActivitiesDetailsModel.ageBands_Array.count
        }else if tableView == tbl_tripList{
            return DTripsListModel.tripList.count
        }else if tableView == tbl_overView || tableView == tbl_details{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_addTraveller {
            return 44.0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_importantInfo {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell") as? AdditionalInfoCell
            if cell == nil {
                tableView.register(UINib(nibName: "AdditionalInfoCell", bundle: nil), forCellReuseIdentifier: "AdditionalInfoCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfoCell") as? AdditionalInfoCell
            }
            cell?.lbl_infoText.text = additionalInfo_Array[indexPath.row] as? String ?? ""
            
            cell?.selectionStyle = .none
            return cell!
            
        }else if tableView == tbl_addTraveller{
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
            
        }else if tableView == tbl_overView || tableView == tbl_details{
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
            if cell == nil {
                tableView.register(UINib(nibName: "TransferItineraryCell", bundle: nil), forCellReuseIdentifier: "TransferItineraryCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
            }
            if tableView == tbl_overView{
                //cell?.lbl_title.text = String.init(format: "%@", "Overview")
                let final_descript = "<div align=\"justify\">\(DActivitiesDetailsModel.product_descrption)</div>"
                cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
            }else{
                //cell?.lbl_title.text = String.init(format: "%@", "Details")
                let final_descript = "<div align=\"justify\">\(DActivitiesDetailsModel.overview_short_descp_text)</div>"
                cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
            }
            cell?.lbl_description.textColor = .darkGray
            cell?.view_title_HContraint.constant = 0
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
        }else{
            return UITableViewCell()
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
        if DActivitiesDetailsModel.ageBands_Array[sender.tag].count ?? 0 > 0{
            let indexPath = IndexPath(row: sender.tag, section: 0)
            DActivitiesDetailsModel.ageBands_Array[sender.tag].count! -= 1
            self.tbl_addTraveller.reloadRows(at: [indexPath], with: .automatic)
            showTotalTravellersCount()
        }

    }

    @objc func bookTrip(sender: UIButton) {
        print("book...")
        self.transfer_BlockTrip_APIConnection(index: sender.tag)
    }
}

