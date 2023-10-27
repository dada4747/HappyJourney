//
//  BusDetailsVC.swift
//  Internacia
//
//  Created by Admin on 17/11/22.
//

import UIKit
import WebKit

class BusDetailsVC: UIViewController, BoardingPointsDelegate, DropingPointDelegate, del {
    func res(_sender: UITapGestureRecognizer) {
        imageTapped(_sender)
    }
    
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
    
    @IBOutlet weak var btn_upper: GradientButton!
    @IBOutlet weak var btn_lower: GradientButton!
    @IBOutlet weak var img_stairing: UIImageView!
    
    //    @IBOutlet weak var lbl_selectedSeats: UILabel!
    @IBOutlet weak var selectedAmount: UILabel!
    @IBOutlet weak var lowupView: UIView!
    @IBOutlet weak var view_seatSelection: UIView!
    @IBOutlet weak var view_top: UIView!
    var selectedBus : DBusesSearchItem?
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_selectedSeats: UILabel!
    //MARK: - New Layout Code
    var uA : [SeatDetails?] = []
    var lA : [SeatDetails?] = []
    var lower_array: [[SeatDetails?]] = []
    var upper_array: [[SeatDetails?]] = []
    
    var lowerSelectedIndices: Set<IndexPath> = []
    var upperSelectedIndices: Set<IndexPath> = []
    
    var selectedSeatsArray: [SeatDetails?] = []
    
    @IBOutlet weak var upperCollectionView: UICollectionView!
    @IBOutlet weak var lowerCollectionView: UICollectionView!
    
    @IBOutlet weak var heightConstraintLower: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintUpper: NSLayoutConstraint!
    
    var view_packageTypePop: ToursPackageView?
    
    
    var finalCost : Float = 0.0;
    
    //    var seatingList_arr : [Value] = []
    //    var bookedSeatsList_arr : [Value] = []
    var selectedDeck = "Lower"
    //    var isBusSleeper : Bool = false
    //    var isBusSeaterSleeper : Bool = false
    //    var maxRows : Int = 0
    //    var maxColl : Int = 0
    
    var selected_drop : Dropoff?
    var selected_board : Pickup?
    
    //    var isBusSleeper : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()
        addFrameAddView()
        
        gettingBusDetails()
        // Do any additional setup after loading the view.
    }
    //MARK: -
    func addCollectionView(){
        upperCollectionView.delegate = self
        upperCollectionView.dataSource = self
        upperCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        upperCollectionView.transform = CGAffineTransform(scaleX: -1, y: 1) // Mirror horizontally
        upperCollectionView.isHidden = true
        //        lowerCollectionView.backgroundColor = .lightGray
        
        
        lowerCollectionView.delegate = self
        lowerCollectionView.dataSource = self
        lowerCollectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        lowerCollectionView.transform = CGAffineTransform(scaleX: -1, y: 1) // Mirror horizontally
        //        upperCollectionView.backgroundColor = .lightGray
        
    }
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        print(selectedSeatsArray.count)
        if selectedSeatsArray.count > 5 {
            
            if selectedDeck == "Upper" {
                guard let upperIndexPath = upperCollectionView.indexPathForItem(at: sender.location(in: upperCollectionView)) else {return}
                if upperSelectedIndices.contains(upperIndexPath){
                    
                    let item = upper_array[upperIndexPath.section][upperIndexPath.item]
                    upperSelectedIndices.forEach { index in
                        uA.append(upper_array[index.section][index.item])
                    }
                    uA = uA.filter { $0?.seatIndex != item?.seatIndex }
                    upperSelectedIndices.remove(upperIndexPath)
                    
                    
                }else{
                    self.view.makeToast(message: "You cannot select more than 6 seats")
                    
                }
                upperCollectionView.reloadData()
                
            }else{
                guard let lowerIndexPath = lowerCollectionView.indexPathForItem(at: sender.location(in: lowerCollectionView)) else{return}
                
                if lowerSelectedIndices.contains(lowerIndexPath) {
                    let item = lower_array[lowerIndexPath.section][lowerIndexPath.item]
                    lowerSelectedIndices.forEach { index in
                        lA.append(lower_array[index.section][index.item])
                    }
                    lA = lA.filter { $0?.seatIndex != item?.seatIndex }
                    lowerSelectedIndices.remove(lowerIndexPath)
                    // Perform additional actions when an image is deselected
                }else{
                    self.view.makeToast(message: "You cannot select more than 6 seats")
                    
                }
                lowerCollectionView.reloadData()
            }
        }else{
            
            if selectedDeck == "Upper" {
                guard let upperIndexPath = upperCollectionView.indexPathForItem(at: sender.location(in: upperCollectionView)) else {return}
                
                if upperSelectedIndices.contains(upperIndexPath){
                    
                    let item = upper_array[upperIndexPath.section][upperIndexPath.item]
                    upperSelectedIndices.forEach { index in
                        uA.append(upper_array[index.section][index.item])
                    }
                    uA = uA.filter { $0?.seatIndex != item?.seatIndex }
                    upperSelectedIndices.remove(upperIndexPath)
                    
                    
                }else{
                    upperSelectedIndices.insert(upperIndexPath)
                    upperSelectedIndices.forEach { index in
                        
                        uA.append(upper_array[index.section][index.item])
                    }
                }
                upperCollectionView.reloadData()
                
            }else {
                guard let lowerIndexPath = lowerCollectionView.indexPathForItem(at: sender.location(in: lowerCollectionView)) else{return}
                
                if lowerSelectedIndices.contains(lowerIndexPath) {
                    let item = lower_array[lowerIndexPath.section][lowerIndexPath.item]
                    lowerSelectedIndices.forEach { index in
                        lA.append(lower_array[index.section][index.item])
                    }
                    lA = lA.filter { $0?.seatIndex != item?.seatIndex }
                    lowerSelectedIndices.remove(lowerIndexPath)
                    // Perform additional actions when an image is deselected
                } else {
                    lowerSelectedIndices.insert(lowerIndexPath)
                    lowerSelectedIndices.forEach { index in
//                        print(lower_array[index.section][index.item])
                        lA.append(lower_array[index.section][index.item])
                    }
                    
                    // Perform additional actions when an image is selected
                }
                lowerCollectionView.reloadData()
            }
            
        }
        
        selectedSeatsArray = uA + lA
        //        selectedSeatsArray.removeAll(where: {$0 == nil})
        selectedSeatsArray =  removeDuplicates(from: selectedSeatsArray)
        
//        print(selectedSeatsArray.count)
        
        selectedSeatsArray.forEach { item in
            
//            print("\(item?.seatIndex)/\(item?.seatName)")
        }
        if (selectedSeatsArray.count != 0) {
            
            // calculating cost
            let costArr : [Float]  = selectedSeatsArray.map{$0!.seatFare}
            
            finalCost = 0.00;
            for i in 0..<costArr.count  {
                let seatCostStr = costArr[i]
                finalCost = finalCost + seatCostStr
            }
            
            lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (finalCost * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
            
            let seatNumbers = selectedSeatsArray.map{String($0!.seatIndex) + "(\($0!.seatName ))"}
            lbl_selectedSeats.text = seatNumbers.joined(separator: ", ")
            
        } else {
            lbl_price.text = "0.0"
            lbl_selectedSeats.text = ""
        }
        DBusResultModel.bus_Selected_Seats_list = selectedSeatsArray
        
        
        
        
    }
    func removeDuplicates(from array: [SeatDetails?]) -> [SeatDetails?] {
        var uniqueObjects: [SeatDetails] = []
        var seenNames: Set<Int> = []
        
        for object in array {
            if !seenNames.contains(object!.seatIndex) {
                seenNames.insert(object!.seatIndex)
                uniqueObjects.append(object!)
            }
        }
        
        return uniqueObjects
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    //MARK: -
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
        print(DBusDetailModel.pickups)
        self.view_packageTypePop?.packageType = .BoardingPoints
        self.view_packageTypePop?.boardingPointArray = DBusDetailModel.pickups
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.boardingDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    @IBAction func selectDropPoint(_ sender: Any) {
        self.view_packageTypePop?.packageType = .DropPoints
        self.view_packageTypePop?.dropPointArray = DBusDetailModel.dropoffs
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
            btn_lower.startColor = .primInteraciaPink
            btn_lower.endColor = .secInteraciaBlue
            btn_upper.startColor = .placeholder
            btn_upper.endColor = .placeholder
//            btn_lower.backgroundColor = UIColor.secInteraciaBlue
//            btn_upper.backgroundColor = UIColor.placeholder
            //            seatArray2D = lower_array
            upperCollectionView.isHidden = true
            lowerCollectionView.isHidden = false
            img_stairing.isHidden = false
            DispatchQueue.main.async {
                self.lowerCollectionView.reloadData()
            }
        }
        else {
            
            selectedDeck = "Upper"
            btn_upper.setTitleColor(.white, for: .normal)
            btn_lower.setTitleColor(.black, for: .normal)
            btn_upper.startColor = .primInteraciaPink
            btn_upper.endColor = .secInteraciaBlue
            btn_lower.startColor = .placeholder
            btn_lower.endColor = .placeholder


            //            seatArray2D = upper_array
            upperCollectionView.isHidden = false
            lowerCollectionView.isHidden = true
            img_stairing.isHidden = true
            DispatchQueue.main.async {
                self.upperCollectionView.reloadData()
            }
        }
        
        
    }
    @IBAction func continueAction(_ sender: Any) {
        let seatNumberList = selectedSeatsArray.map{$0?.seatName}
        var seatAttrDict : [String: Any] = [:]
        
        if seatNumberList.count == 0 {
            self.view.makeToast(message: "Please select the seat to continue")
        } else if tf_bording.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Boarding point to continue")
        } else if tf_drop_point.text.isEmpty == true {
            self.view.makeToast(message: "Please select the Drop point to continue")
        }else{
            for i in 0..<seatNumberList.count {
                for j in 0..<selectedSeatsArray.count {
                    if (seatNumberList[i] == selectedSeatsArray[j]?.seatName) {
                        var localDict : [String : Any] = [:]
                        let dict = selectedSeatsArray[j]
                        localDict["decks"] = dict?.isUpper == true ? "Upper" : "Lower"
                        localDict["Fare"] = String(dict!.seatFare)
                        localDict["IsAcSeat"] = String(dict!.seatType) == "2" ? "true" : "false"
                        localDict["Markup_Fare"] = String(dict!.seatFare)
                        localDict["SeatType"] = String(dict!.seatType)
                        localDict["seq_no"] = "0"
                        
                        seatAttrDict[String(dict!.seatIndex)] = localDict
                    }
                }
            }
//            print("seat Attrinbutes : \(seatAttrDict)")
            var dict_final_seat : [String : Any] =  [:]
            dict_final_seat["markup_price_summary"] = String(finalCost)
            dict_final_seat["total_price_summary"] =  String(finalCost)
            dict_final_seat["domain_deduction_fare"] = String(finalCost )
            dict_final_seat["default_currency"] = "INR"
            dict_final_seat["seats"] = seatAttrDict
            
//            print("Final seat Array: \(dict_final_seat)")
            
            DBusResultModel.busSeatAttributDetails = dict_final_seat
            //                    DBusResultModel.bus_Selected_Seats_list = bookedSeatsList_arr
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
        lower_array = DBusDetailModel.result.lower_array
        upper_array = DBusDetailModel.result.upper_array

        
        upper_array.count <= 1 ? (btn_upper.isHidden = true) : (btn_upper.isHidden = false)

        lowerCollectionView.reloadData()
        asdfg()
        
    }
    func asdfg(){
        // Update placeholder constraint
//        print(lowerCollectionView.frame.size.height)
        
        print(lower_array.count)
        print(upper_array.count)
                if lower_array.count != 0 {
                    self.heightConstraintLower.constant = CGFloat(40 * lower_array[1].count)
        //            self.heightConstraintUpper.constant = CGFloat(60 * upper_array[1].count)
        //
                }
        print(heightConstraintLower.constant)
                lowerCollectionView.reloadData()
                upperCollectionView.reloadData()
    }
}

extension BusDetailsVC {
    
    func gettingBusDetails(){
        CommonLoader.shared.startLoader(in: view)
        //        bus_details
        DBusDetailModel.clearModel()
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
                self.navigationController?.popViewController(animated: true)

            }
            
            // getting rooms list...
            
            self.displayInfo()
            CommonLoader.shared.stopLoader()
        }
    }
}

extension BusDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{ //UICollectionViewDelegateFlowLayout {
    
    //            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    ////                print(lower_array[1].count)
    ////                print(upper_array[1].count)
    //
    ////                print(lower_array[indexPath.section].count)
    //
    ////                print(Int(self.collectionView.bounds.size.width))
    ////                print(Int(self.collectionView.bounds.size.width)/(lowerRows + 4))
    //                return CGSize(width: 40 , height: Int(self.self.lowerCollectionView.frame.size.height) / (lower_array[1].count ))
    //            }
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == upperCollectionView {
            return upper_array.count
        }else{
            return lower_array.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upperCollectionView {
            return upper_array[section].count
        }else {
            return lower_array[section].count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        cell.del = self
        let k = indexPath.section //
        let l = indexPath.item
        if collectionView == upperCollectionView {
            let seat = upper_array[k][l]
            
//            print(seat)
            // MARK: - Upper Deck
            if seat != nil {
                if (seat?.seatType != 1) || (seat?.seatType != 3) || (seat?.seatType != 5) {
                    if (seat?.width == 1){
                        if (seat?.seatStatus != true) {
                            cell.imageView.image = UIImage(named: "sleeper_booked_w1_h2.png")
                        }else {
                            if (seat?.isLadiesSeat == true) {
                                cell.imageView.image = UIImage(named: "sleeper_ladies_w1_h2.png")
                            }else {
                                cell.imageView.image = UIImage(named: "sleeper_w1_h2.png")
                            }
                        }
                    } else {
                        if seat?.seatStatus != true {
                            cell.imageView.image = UIImage(named: "sleeper_booked_w2_h1.png")
                        }else {
                            if seat?.isLadiesSeat == true {
                                cell.imageView.image = UIImage(named: "sleeper_ladies_w2_h1.png")
                            }else{
                                cell.imageView.image = UIImage(named: "sleeper_w2_h1.png")
                            }
                        }
                    }
                }
            } else {
                cell.imageView.image = UIImage(named: "")
            }
            if selectedSeatsArray.contains(where: {$0?.seatIndex == seat?.seatIndex })
            {
                if seat?.seatStatus == true {
                    if (seat?.seatType != 1) || (seat?.seatType != 3) || (seat?.seatType != 5) {
                        if (seat?.width == 1){
                            cell.imageView.image = UIImage(named: "sleeper_seat_select.png")
                        } else {
                            cell.imageView.image = UIImage(named: "sleeper_seat_select_w2_h1.png")
                        }
                    }else {
                    }
                }else{
                    
                }
            }else {
            }
            
            if seat == nil || (seat?.seatStatus != true){
                cell.isUserInteractionEnabled = false
            }else{
                cell.isUserInteractionEnabled = true
                
            }
        }else {
            // MARK: - lower Deck
            
            let seat = lower_array[k][l]
            if seat != nil {
                if (seat?.seatType != 4){
                    if (seat?.seatType == 1) || (seat?.seatType == 3) {
                        //                        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
                        //                        cell.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        //                        cell.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        if (seat?.seatStatus != true) {
                            cell.imageView.image = UIImage(named: "seat_booked.png")
                        }else {
                            if seat?.isLadiesSeat == true {
                                cell.imageView.image = UIImage(named: "seat_ladies.png")
                            }else {
                                cell.imageView.image = UIImage(named: "seat.png")
                            }
                        }
                    }else{
                        //                        cell.imageView.translatesAutoresizingMaskIntoConstraints = false
                        //                        cell.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
                        //                        cell.imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
                        if seat?.width ==  1 {
                            if seat?.seatStatus != true {
                                cell.imageView.image = UIImage(named: "sleeper_booked_w1_h2.png")
                            }else{
                                if seat?.isLadiesSeat == true {
                                    cell.imageView.image = UIImage(named: "sleeper_ladies_w1_h2.png")
                                }else {
                                    cell.imageView.image = UIImage(named: "sleeper_w1_h2.png")
                                }
                            }
                        } else {
                            if seat?.seatStatus != true {
                                cell.imageView.image = UIImage(named: "sleeper_booked_w2_h1.png")
                            }else{
                                if seat?.isLadiesSeat == true {
                                    cell.imageView.image = UIImage(named: "sleeper_ladies_w2_h1.png")
                                }else {
                                    cell.imageView.image = UIImage(named: "sleeper_w2_h1.png")
                                }
                            }
                        }
                    }
                }
            }else{
                cell.imageView.image = UIImage(named: "")
            }
            if selectedSeatsArray.contains(where: {$0?.seatIndex == seat?.seatIndex })
            {
                if (seat?.seatType != 1) || (seat?.seatType != 3) || (seat?.seatType != 5) {
                    if (seat?.seatType == 1) || (seat?.seatType == 3) {
                        //                    if  seat?.width ==  1 {
                        cell.imageView.image = UIImage(named: "seat_select.png")
                        
                    }else{
                        cell.imageView.image = UIImage(named: "sleeper_seat_select.png")
                        
                    }
                }
            }else {
            }
            if (seat == nil) || (seat?.seatStatus != true) {
                cell.isUserInteractionEnabled = false
            }else{
                cell.isUserInteractionEnabled = true
                
            }
        }
        
        
        
        
        return cell
    }
    func rotateImage(image: UIImage, degrees: CGFloat) -> UIImage {
        let radians = degrees * .pi / 180.0
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.rotate(by: radians)
        
        image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}









//MARK: -
protocol del {
    func res(_sender: UITapGestureRecognizer)
}
class ImageCollectionViewCell: UICollectionViewCell {
    //    var collectionView: UICollectionView!
    let imageView: UIImageView
    var del : del!
    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)
        imageView.frame = contentView.bounds // Adjust the image view's frame to match the cell's bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode =    .scaleAspectFill //.scaleAspectFit //.scaleToFill //
        addSubview(imageView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.transform = .identity
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        // Empty implementation
        //        print(sender.view?.tag)
        del.res(_sender: sender)
    }
}

//MARK: -
