//
//  BusDetailsVC.swift
//  Internacia
//
//  Created by Admin on 17/11/22.
//

import UIKit

class BusDetailsVC: UIViewController, BoardingPointsDelegate, DropingPointDelegate {
    func selectedBoardingPoint(model: Pickup) {
        selected_board = model
        tf_bording.text = "\(model.pickupName ?? "") \(model.pickupTime ?? "")"
        lbl_Bplaceholder2.isHidden = true
    }
    func selctedDropPoint(model: Dropoff) {
        selected_drop = model
        tf_drop_point.text = "\(model.dropoffName ?? "")  \(model.dropoffTime ?? "")"
        lbl_bplaceholder2.isHidden  = true
        
    }

    @IBOutlet weak var lbl_Bplaceholder2: UILabel!
    @IBOutlet weak var lbl_bplaceholder2: UILabel!
    @IBOutlet weak var tf_bording: UITextView!
    @IBOutlet weak var tf_drop_point: UITextView!
    
    @IBOutlet weak var btn_upper: UIButton!
    @IBOutlet weak var btn_lower: UIButton!
    
    //    @IBOutlet weak var lbl_selectedSeats: UILabel!
    @IBOutlet weak var selectedAmount: UILabel!
    @IBOutlet weak var lowupView: UIView!
    @IBOutlet weak var view_seatSelection: UIView!
    @IBOutlet weak var view_top: UIView!
    var selectedBus : DBusesSearchItem?
    @IBOutlet weak var coll_seat_selction: UICollectionView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_selectedSeats: UILabel!
    var view_packageTypePop: ToursPackageView?

    var finalCost : Float = 0.0;

    var seatingList_arr : [Value] = []
    var bookedSeatsList_arr : [Value] = []
    var selectedDeck = "Lower"
    var isBusSleeper : Bool = false
    var isBusSeaterSleeper : Bool = false
    var maxRows : Int = 0
    var maxColl : Int = 0

    var selected_drop : Dropoff?
    var selected_board : Pickup?
    
    //    var isBusSleeper : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addFrameAddView()

        gettingBusDetails()
        // Do any additional setup after loading the view.
    }
    func addFrameAddView(){
        self.view_packageTypePop = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_packageTypePop?.isHidden = true
        self.view_packageTypePop?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_packageTypePop!)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func selectBoardingPoint(_ sender: Any) {
        self.view_packageTypePop?.packageType = .BoardingPoints
        self.view_packageTypePop?.boardingPointArray = DBusDetailModel.result.pickups
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.boardingDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    @IBAction func selectDropPoint(_ sender: Any) {
        self.view_packageTypePop?.packageType = .DropPoints
        self.view_packageTypePop?.dropPointArray = DBusDetailModel.result.dropoffs
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.droppingDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    
    @IBAction func lowerUpperDeckClicked(_ sender: UIButton) {
        
        if (sender.tag == 10) {
            
            selectedDeck = "Lower"
            btn_upper.setTitleColor(UIColor.black, for: .normal)
            btn_lower.setTitleColor(UIColor.white, for: .normal)
            btn_lower.backgroundColor = UIColor.secInteraciaBlue
            btn_upper.backgroundColor = UIColor.placeholder
        }
        else {
            
            selectedDeck = "Upper"
            btn_upper.setTitleColor(.white, for: .normal)
            btn_lower.setTitleColor(.black, for: .normal)
            btn_upper.backgroundColor = UIColor.secInteraciaBlue
            btn_lower.backgroundColor = UIColor.placeholder
           
        }
        DispatchQueue.main.async {
            self.coll_seat_selction.reloadData()
        }
    }
    @IBAction func continueAction(_ sender: Any) {
        let seatNumberList = bookedSeatsList_arr.map{$0.seatNo}
        var seatAttrDict : [String: Any] = [:]
        
        if seatNumberList.count == 0 {
            self.view.makeToast(message: "Please select the seat to continue")
        } else if tf_bording.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Boarding point to continue")
        } else if tf_drop_point.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Drop point to continue")
        }else{
            for i in 0..<seatNumberList.count {
                for j in 0..<seatingList_arr.count {
                    if (seatNumberList[i] == seatingList_arr[j].seatNo) {
                        var localDict : [String : Any] = [:]
                        let dict = seatingList_arr[j]
                        localDict["Fare"] = String(dict.totalFare)
                        localDict["Markup_Fare"] = String(dict.totalFare)
                        localDict["IsAcSeat"] = String(dict.seatType) == "2" ? "true" : "false"
                        localDict["SeatType"] = dict.seatType
                        localDict["seq_no"] = dict.seqNo
                        localDict["decks"] = dict.decks
                        seatAttrDict[dict.seatNo] = localDict
                    }
                }
            }
            print("seat Attrinbutes : \(seatAttrDict)")
            var dict_final_seat : [String : Any] =  [:]
            dict_final_seat["markup_price_summary"] = String(finalCost)
            dict_final_seat["total_price_summary"] =  String(finalCost)
            dict_final_seat["domain_deduction_fare"] = String(finalCost )
            dict_final_seat["default_currency"] = "INR"
            dict_final_seat["seats"] = seatAttrDict
            
            print("Final seat Array: \(dict_final_seat)")
            
            DBusResultModel.busSeatAttributDetails = dict_final_seat
            DBusResultModel.bus_Selected_Seats_list = bookedSeatsList_arr
            DBusResultModel.bus_final_total_price = finalCost
            DBusResultModel.selected_boarding = selected_board!
            DBusResultModel.selected_dropOff = selected_drop!
            DBusResultModel.selectedBus = selectedBus            
            navigateToPassendgerInfo()
        }
       
        
    }
    func navigateToPassendgerInfo(){
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusPassengerDetails") as! BusPassengerDetails
        
        navigationController?.pushViewController(vc, animated: true)

    }
    func displayInfo() {
        seatingList_arr = DBusDetailModel.result.values
        maxRows = DBusDetailModel.result.max_Rows
        maxColl = DBusDetailModel.result.max_Cols
        if(DBusDetailModel.has_seater) {
            
            self.lowupView.isHidden = true;
            isBusSleeper = false;
            
            if (DBusDetailModel.has_sleeper) {
                isBusSeaterSleeper = true;
                self.lowupView.isHidden = false;
            }
            else {
                isBusSeaterSleeper = false;
            }
        }
        else {
            isBusSleeper = true;
            self.lowupView.isHidden = false
        }
        coll_seat_selction.delegate = self
        coll_seat_selction.dataSource = self
//        coll_seat_selction.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        DispatchQueue.main.async {
            self.coll_seat_selction.reloadData()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BusDetailsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/maxColl , height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxRows * maxColl
    }

//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 22/4
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//           return 20
//       }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollectionViewCell", for: indexPath as IndexPath) as! SeatCollectionViewCell
        let array = seatingList_arr.filter { ($0.col == Int(indexPath.item % maxColl)) && ($0.row == Int(indexPath.item / maxColl)) }
        let result = array.filter { $0.decks == selectedDeck }
        
        // available seats
        if(isBusSleeper) {
            cell.seat_image.image = UIImage(named: "ic_available_sleep.png")
        }
        else {
            cell.seat_image.image = UIImage(named: "ic_available.png")
        }
        
        if(result.count == 0)
        {
            cell.seat_image.image = UIImage(named: "")
        }
        else
        {
            let SeatNo = result[0].seatNo
            if(SeatNo == "") {
            
                // no seat available
                cell.seat_image.isHidden = true//image = UIImage(named: "")
            }
            else {
                let isSeatAvailable = String(result[0].status)
                let isSeaterType = String(result[0].seatType)
                if(isBusSleeper) {
                    cell.seat_image.image = UIImage(named: "ic_available_sleep.png")
                }
                else {
                    if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                        cell.seat_image.image = UIImage(named: "ic_available.png")
                    }
                    else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                        cell.seat_image.image = UIImage(named: "ic_available_sleep.png")
                    }
                    else {
                        cell.seat_image.image = UIImage(named: "ic_available.png")
                    }
                }
                if(result.count == 0)
                {
                    cell.seat_image.isHidden = true//.image = UIImage(named: "")
                }

                if(!(isSeatAvailable == "1")) {  // Seats Available...
                    
                    // already booked by some one
                    if(isBusSleeper) {
                    
                        // booked seats...
                        if (isSeatAvailable == "0") {
                            cell.seat_image.image = UIImage(named: "ic_blocked_sleep.png")
                        }
                        // reserved for gents...
                        else if (isSeatAvailable == "2") {
                            cell.seat_image.image = UIImage(named: "ic_res_male_sleep.png")
                        }
                        // booked by gents...
                        else if (isSeatAvailable == "-2") {
                            cell.seat_image.image = UIImage(named: "ic_booked_male_sleep.png")
                        }
                        
                        // reserved for ladies...
                        else if (isSeatAvailable == "3") {
                            cell.seat_image.image = UIImage(named: "ic_res_female_sleep.png")
                        }
                        // booked by ladies
                        else if (isSeatAvailable == "-3") {
                            cell.seat_image.image = UIImage(named: "ic_book_female_sleep.png")
                        }
                        else {
                            cell.seat_image.image = UIImage(named: "ic_blocked_sleep.png")
                        }
                    }
                    else {
                        // booked seats...
                        if (isSeatAvailable == "0") {
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_blocked.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_blocked_sleep.png")
                            }
                            else {
                                cell.seat_image.image = UIImage(named: "ic_blocked.png")
                            }
                        }
                        // reserved for gents...
                        else if (isSeatAvailable == "2") {
                            
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_res_male.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_res_male_sleep.png")
                            }
                            else {
                                cell.seat_image.image = UIImage(named: "ic_res_male.png")
                            }
                        }
                        // booked by gents...
                        else if ((isSeatAvailable == "-2")) {
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_male_booked.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_booked_male_sleep.png")
                            }
                            else {
                                cell.seat_image.image = UIImage(named: "ic_male_booked.png")
                            }
                        }
                        // reserved for ladies...
                        else if (isSeatAvailable == "3") {
                            
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_res_female.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_res_female_sleep.png")
                            }
                            else {
                                cell.seat_image.image = UIImage(named: "ic_res_female.png")
                            }
                        }
                        // booked by ladies
                        else if ((isSeatAvailable == "-3")) {
                            
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_booked_female.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_book_female_sleep.png")
                            }
                            else {
                                cell.seat_image.image = UIImage(named: "ic_booked_female.png")
                            }
                        }
                        else {
                            cell.seat_image.image = UIImage(named: "ic_blocked.png")
                        }
                    }
                }
                else {
                    let array1 = bookedSeatsList_arr.filter { ($0.col == Int(indexPath.item % maxColl)) && ($0.row == Int(indexPath.item / maxColl)) }
                    let result1 = array1.filter { $0.decks == selectedDeck }

                    
                    if(result1.count != 0) {
                        // ur selected seat
                        if(isBusSleeper) {
                            cell.seat_image.image = UIImage(named: "ic_selected_sleep.png")
                        }
                        else {
                            if (isBusSeaterSleeper && (isSeaterType == "1")) { // seater & semi-sleeper...
                                cell.seat_image.image = UIImage(named: "ic_selected.png")
                            }
                            else if (isBusSeaterSleeper && (isSeaterType == "2")) { // sleeper...
                                cell.seat_image.image = UIImage(named: "ic_selected_sleep.png")
                            }
                            else {
                                 cell.seat_image.image = UIImage(named: "ic_selected.png")
                            }
                        }
                    }
                }
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let result1 = bookedSeatsList_arr.filter{$0.col == Int(indexPath.item % maxColl) && $0.row == Int(indexPath.item / maxColl) }
        let result2 = result1.filter{$0.decks == selectedDeck}

        let result3 = seatingList_arr.filter{$0.col == Int(indexPath.item % maxColl) && $0.row == Int(indexPath.item / maxColl) }
        let result = result3.filter{$0.decks == selectedDeck}

        if result2.count != 0 {
            let isSeatAvailable : String = "\(result[0].status)"
            if !(isSeatAvailable == "1") {
//                return
            }
            let col1 : String = "\(result[0].col)"
            let row1 : String = "\(result[0].row)"
            var isAlreadySelected1 : Bool = false
            for i in 0..<bookedSeatsList_arr.count {
                let selectedCol = "\(bookedSeatsList_arr[i].col)"
                let selectedRow = "\(bookedSeatsList_arr[i].row)"
                if ((selectedCol == col1) && (selectedRow == row1)) {
                    bookedSeatsList_arr.remove(at: i)
                    isAlreadySelected1 = true;
                }            }
        }
        else{
            if (result.count != 0) {
                let isSeatAvailable : String = "\(result[0].status)"

                if !(isSeatAvailable == "0") {
                    if (isSeatAvailable == "1") {

                        if (bookedSeatsList_arr.count < 6) {
                            bookedSeatsList_arr.append(result[0])
                        }
                        else {
                            self.view.makeToast(message: "select only 6")
                        }
                    }
                }
            }
        }
        coll_seat_selction.reloadData()
        if (bookedSeatsList_arr.count != 0) {

            // calculating cost
            let costArr : [Float]  = bookedSeatsList_arr.map{$0.totalFare}

            finalCost = 0.00;
            for i in 0..<costArr.count  {
                let seatCostStr = costArr[i]
                finalCost = finalCost + seatCostStr
            }
            lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", finalCost * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
            let seatNumbers = bookedSeatsList_arr.map{$0.seatNo}
            lbl_selectedSeats.text = seatNumbers.joined(separator: ",")
        }

    }
    
}
extension BusDetailsVC {
    func gettingBusDetails(){
        SwiftLoader.show(animated: true)
//        bus_details
        
        let params : [String : String] = ["route_schedule_id": selectedBus?.RouteScheduleId ?? "", "journey_date": selectedBus?.DeptTime ?? "", "route_code": selectedBus?.RouteCode ?? "", "search_id": DBusSearchModel.search_id , "ResultToken": selectedBus?.ResultToken ?? "",  "booking_source": DBusSearchModel.booking_source
        ]
        let paramString: [String: String] = ["bus_details": VKAPIs.getJSONString(object: params)]
        
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: "bus/bus_details_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            DBusDetailModel.createModel(details: data_dict)

                        }
                    } else {
                        self.view.makeToast(message: result["message"] as! String)
                        self.navigationController?.popViewController(animated: true)
                        // error message...
//                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Bus details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus details error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            // getting rooms list...
            
            self.displayInfo()
            SwiftLoader.hide()
        }

    }
   
    
}
