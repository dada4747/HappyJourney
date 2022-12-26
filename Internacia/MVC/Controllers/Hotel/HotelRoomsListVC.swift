//
//  HotelRoomsListVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import MapKit

class HotelRoomsListVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var icarousel_mainView: iCarousel!
    @IBOutlet weak var page_Ctrl: UIPageControl!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var rating_view: FloatRatingView!
    
    @IBOutlet weak var lbl_roomName: UILabel!
    @IBOutlet weak var lbl_roomPrice: UILabel!
    
    @IBOutlet weak var lbl_checkIn: UILabel!
    @IBOutlet weak var lbl_checkOut: UILabel!
    @IBOutlet weak var lbl_rooms: UILabel!
    @IBOutlet weak var lbl_guests: UILabel!
    
    @IBOutlet weak var lbl_noofNights: UILabel!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    
    @IBOutlet weak var view_detailsMenu: UIView!
    @IBOutlet weak var tbl_rooms: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_grandTotal: UILabel!

    var view_facilitiesView: ToursPackageView?

    // MARK:- Variables...
    var select_hotel: DHotelSearchItem?

    var hotelDetail_model = DHotelDetailsModel()
    var media_array: [String] = []
    var rooms_array: [DHotelRoomItem] = []
    var roomSelect_index = 0
    
    var menuTab = tablesList.selectRoom
    enum tablesList {
        case selectRoom
        case details
        case viewMap
    }
    var showLess = false
    
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addFrameAddView()
        // bottom shadow...
        view_header.viewShadow()
//        view.backgroundColor = .secInteracia

        // icarousel delegates...
        icarousel_mainView.delegate = self
        icarousel_mainView.dataSource = self
        icarousel_mainView.isPagingEnabled = true
        icarousel_mainView.type = iCarouselType.linear
        
        // table delegates...
        tbl_rooms.delegate = self;
        tbl_rooms.dataSource = self;
        tbl_rooms.rowHeight = UITableView.automaticDimension;
        
        tbl_rooms.estimatedRowHeight = 4
        
        displayRoomAndGuest_Information()
        
        // API call...
        DHotelDetailsModel.roomsArray.removeAll()
        DHPreBookingModel.clearAll_Information()
        gettingHotel_Details()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addFrameAddView() {
        self.view_facilitiesView = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_facilitiesView?.isHidden = true
        self.view_facilitiesView?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_facilitiesView!)
    }
    // MARK:- Helpers
    func displayRoomAndGuest_Information() {
        
        // hotel information...
        lbl_hotelName.text = select_hotel?.hotel_name
        lbl_hotelAddress.text = select_hotel?.hotel_address
        rating_view.rating = Double((select_hotel?.hotel_rating)!)
        
        lbl_roomName.text = ""
        lbl_roomPrice.text = String(format: "%@ %.2f / per night", DCurrencyModel.currency_saved?.currency_country ?? "USD", (select_hotel!.hotel_price + select_hotel!.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_noofNights.text = "( \(DHTravelModel.noof_nights) Nights )"
        lbl_totalPrice.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", select_hotel!.hotel_price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_grandTotal.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", select_hotel!.hotel_price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        
        // display information...
        lbl_rooms.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guests.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests"
        
    }
    
    func roomPricesDisplay() {
        
        // if room not avaiables...
        if rooms_array.count == 0 {
            return
        }
        
        // price information...
        let roomModel = rooms_array[roomSelect_index]
        
        lbl_roomName.text = roomModel.room_name
//        lbl_roomPrice.text =  String(format: "%@ %.2f / per night", DCurrencyModel.currency_saved?.currency_country ?? "USD", roomModel.room_price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        lbl_totalPrice.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", roomModel.room_price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        lbl_grandTotal.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", roomModel.room_price  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
    }
    
    func displayHotelDetails() {
        
        // media image display...
        media_array = self.hotelDetail_model.media_array
        self.page_Ctrl.numberOfPages = media_array.count
        self.icarousel_mainView.reloadData()
        
        // rooms...
        rooms_array = DHotelDetailsModel.roomsArray
        tbl_rooms.reloadData()
        
        tbl_HContraint.constant = CGFloat(rooms_array.count * 105)
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
        
        // price information...
        roomPricesDisplay()
        lbl_checkIn.text = "Check-in : " + DateFormatter.getDateString(formate: "EEE dd, MMM", date: DHTravelModel.checkin_date)
        lbl_checkOut.text = "Check-out : " + DateFormatter.getDateString(formate: "EEE dd, MMM", date: DHTravelModel.checkout_date)
    }
    
    @objc func tableHeightCalculation() {
        
        tbl_HContraint.constant = tbl_rooms.contentSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }

    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
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
            menuTab = .selectRoom
            tbl_HContraint.constant = CGFloat(rooms_array.count * 105)
        }
        else if sender.tag == 11 {
            menuTab = .details
            tbl_HContraint.constant = 250
        }
        else if sender.tag == 12 {
            menuTab = .viewMap
            tbl_HContraint.constant = 300
        }
        else {}
        tbl_rooms.reloadData()
        
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
    }
    
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        
        // if room not avaiables...
        if rooms_array.count == 0 {
            self.view.makeToast(message: "Rooms not available !")
            return
        }
        
        // select room information...
        let roomModel = rooms_array[roomSelect_index]
        DHTravelModel.select_room = roomModel
        DHTravelModel.grand_total = roomModel.room_price
        
        hotelsRoomBlock_Booking()
        

    }
}

extension HotelRoomsListVC: iCarouselDelegate, iCarouselDataSource {
    
    // MARK:- iCarouselDelegate
    func numberOfItems(in carousel: iCarousel) -> Int {
        return media_array.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        // crate view...
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height))
        tempView.backgroundColor = UIColor.clear
        
        // add image view...
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        tempView.addSubview(imgView)
        
        // loading image...
        let urlStr = media_array[index]

        imgView.sd_setImage(with: URL.init(string: urlStr), completed: nil)

        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if option == iCarouselOption.spacing {
            return value * 1.01
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        page_Ctrl.currentPage = carousel.currentItemIndex
    }
}


extension HotelRoomsListVC : UITableViewDelegate, UITableViewDataSource, hRoomsListCellDelegate, hDescriptionCellDelegate, ShowMoreFacilitiesDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if menuTab == .selectRoom {
           return rooms_array.count
        } else if menuTab == .details {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuTab == .viewMap {
            return 300
        }else{
            return UITableView.automaticDimension

        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if menuTab == .selectRoom {
        
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomsListCell") as? HotelRoomsListCell
            if cell == nil {
                tableView.register(UINib(nibName: "HotelRoomsListCell", bundle: nil), forCellReuseIdentifier: "HotelRoomsListCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HotelRoomsListCell") as? HotelRoomsListCell
            }
            cell?.delegate = self
            cell?.displayRooms_information(rModel: rooms_array[indexPath.row])
            cell?.lbl_select.text = "Select"
            // selection colors...
            if roomSelect_index == indexPath.row {
                cell?.view_selected.backgroundColor = .secInteraciaBlue
                cell?.lbl_select.textColor = UIColor.white
                cell?.lbl_select.text = "Selected"
                cell?.img_selectImg.isHidden = false
                cell?.lblSelect_XConstrint.constant = 32
            }

            cell?.selectionStyle = .none
            return cell!
        }
        else if menuTab == .details {
            if indexPath.row == 0 {
                // cell creation...
                var cell = tableView.dequeueReusableCell(withIdentifier: "HotelDescriptionCell") as? HotelDescriptionCell
                
                if cell == nil {
                    tableView.register(UINib(nibName: "HotelDescriptionCell", bundle: nil), forCellReuseIdentifier: "HotelDescriptionCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "HotelDescriptionCell") as? HotelDescriptionCell
                }
                
                cell?.delegate = self
                cell?.lbl_description.attributedText = hotelDetail_model.description.htmlToAttributedString
                
                cell?.btn_showMore.isHidden = false
                cell?.lbl_description.textAlignment = .justified
                
                if cell?.lbl_description.attributedText?.length == 0 {
                    cell?.btn_showMore.isHidden = true
                    cell?.lbl_description.textAlignment = .center
                    cell?.lbl_description.attributedText = NSAttributedString.init(string: "Description is not available")
                }
                
                // display information...
                if showLess == false {
                    cell?.lbl_description.numberOfLines = 3
                    cell?.btn_showMore.setTitle("Show More", for: .normal)
                } else {
                    cell?.lbl_description.numberOfLines = 0
                    cell?.btn_showMore.setTitle("Show Less", for: .normal)
                }
                
                cell?.selectionStyle = .none
                return cell!
            } else {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HotelFacilitiesCell") as? HotelFacilitiesCell
                if cell == nil {
                    tableView.register(UINib(nibName: "HotelFacilitiesCell", bundle: nil), forCellReuseIdentifier: "HotelFacilitiesCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "HotelFacilitiesCell") as? HotelFacilitiesCell
                }
                
                if hotelDetail_model.amenities_array.count < 4 {
                    cell?.btn_show_more.isHidden = true
                }
                
                cell?.facility_array = Array(hotelDetail_model.amenities_array.prefix(4))
                cell?.delegate = self
                cell?.displayInfo()
                cell?.selectionStyle = .none
                return cell!
            }
        } else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "HotelMapCell") as? HotelMapCell
            if cell == nil {
                tableView.register(UINib(nibName: "HotelMapCell", bundle: nil), forCellReuseIdentifier: "HotelMapCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "HotelMapCell") as? HotelMapCell
            }
            
            // display information...
            cell?.lbl_address.text = select_hotel?.hotel_address
            
            // add annotation on map
            let point = MKPointAnnotation()
            point.coordinate = CLLocationCoordinate2DMake(Double(hotelDetail_model.latitude), Double(hotelDetail_model.longtitude))
            cell?.mapView.addAnnotation(point)
            
            // zoom
            var region = MKCoordinateRegion()
            region.center = CLLocationCoordinate2DMake(Double(hotelDetail_model.latitude), Double(hotelDetail_model.longtitude))
            region.span = MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1)
            cell?.mapView.setRegion(region, animated: true)
            cell?.selectionStyle = .none
            return cell!
            
        }
    }
    
    // MARK:- CellActions
    func roomSeletion_Action(sender: UIButton, cell: UITableViewCell) {
        
        // select index chaning...
        let indexPath = tbl_rooms.indexPath(for: cell)
        roomSelect_index = (indexPath?.row)!
        tbl_rooms.reloadData()
        
        // price infomation...
        roomPricesDisplay()
    }
    
    func cancelPolicy_Action(sender: UIButton, cell: UITableViewCell) {
        
        // select index chaning...
        let indexPath = tbl_rooms.indexPath(for: cell)
        
        var msg = rooms_array[(indexPath?.row)!].cancel_policy
        msg = msg?.replacingOccurrences(of: "<br/>", with: " ") ?? ""
        
        let alert = UIAlertController(title: "Cancellation Policy",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
   
    func showMoreButtonClicked(sender: UIButton, cell: UITableViewCell) {
        
        if showLess == false {
            showLess = true
        } else {
            showLess = false
        }
        tbl_rooms.reloadData()
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 1.0)
    }
    func showMorwFacilities() {
        //show more facilities
        self.view_facilitiesView?.packageType = .AllPackageType
        self.view_facilitiesView?.facility_array = DHotelDetailsModel.hotel_details.amenities_array
        self.view_facilitiesView?.displayInfo()
        self.view_facilitiesView?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_facilitiesView!)
    }
}

extension HotelRoomsListVC {
    
    // MARK:- API's
    func gettingHotel_Details() {
        
        SwiftLoader.show(animated: true)
        // params...
        let params: [String: String] = ["ResultIndex": (select_hotel?.resultToken)!, //(select_hotel?.resultIndex)!
                                        "TraceId": (select_hotel?.resultToken)!,
                                        "HotelCode": (select_hotel?.hotel_code)!,
                                        "booking_source": DHotelSearchModel.booking_source,
                                        "op": "get_details",
                                        "search_id": DHotelSearchModel.search_id]
        print("params: \(params)")
        
        let paramString: [String: String] = ["hotel_details": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Details, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel details success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            self.hotelDetail_model = DHotelDetailsModel.createModel(dateInfo: data_dict)
                        }
                    } else {
                        
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Hotel details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel details error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            // getting rooms list...
            self.gettingHotel_RoomsList(roomParams: params)
        }
    }
    
    func gettingHotel_RoomsList(roomParams: [String: String]) {
        
        // params...
        var params = roomParams
        params["op"] = "get_room_details"
        print("params: \(params)")
        
        let paramString: [String: String] = ["room_list": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Room_List, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel rooms list success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            if let room_array = data_dict["data"] as? [[String: Any]] {
                                DHotelDetailsModel.createRoomModels(dataInfo: room_array)
                            }
                        }
                    } else {
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Hotel rooms list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel rooms list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayHotelDetails()
            SwiftLoader.hide()
        }
    }
    
    func hotelsRoomBlock_Booking() {
        
        SwiftLoader.show(animated: true)
        var image_url = ""
        if hotelDetail_model.media_array.count != 0 {
            image_url = hotelDetail_model.media_array[0]
        }
        let  final_url = VKAPIs.getJSONString(object: image_url)
        print(final_url)
        print(select_hotel?.hotel_code ?? "")
        // params...
        let params: [String: String] = ["HotelName": hotelDetail_model.hotelName,
                                        "HotelCode":"\( select_hotel?.hotel_code ?? "")",
                                        "HotelImage": final_url,
                                        "HotelAddress": hotelDetail_model.address,
                                        "StarRating": hotelDetail_model.hotelRating,
                                        "search_id": DHotelSearchModel.search_id,
                                        "ResultIndex": (select_hotel?.resultToken)!, //(select_hotel?.resultIndex)!
                                        "TraceId": hotelDetail_model.traceId,
                                        "CancellationPolicy":String(DHotelDetailsModel.roomsArray[roomSelect_index].cancel_policy ?? ""),
                                        "Roomuniqueid":String( DHotelDetailsModel.roomsArray[roomSelect_index].room_id ?? "")
        ]
        print("params: \(params)")
        
        let paramString: [String: String] = ["details": VKAPIs.getJSONString(object: params),
                                             "token" : DHTravelModel.select_room.room_token!,
                                             "TokenId": DHTravelModel.select_room.room_token_key!]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Room_Block, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Room block success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // move to Passengers screen...
                        let passengObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelGuestInfoVC") as! HotelGuestInfoVC
//                        passengObj.selectedRoomIndex =
                        self.navigationController?.pushViewController(passengObj, animated: true)
                        
                        // response date...
                        if let data_dict = result["data"] as? [String: Any] {
                            DHPreBookingModel.clearAll_Information()
                            DHPreBookingModel.createRoomBlockModel(dataDict: data_dict)
                        }
                    } else {
                        
                        // error message...
                        self.sessionExpairAlert(result_dict: result)
                    }
                } else {
                    print("Room block formate : \(String(describing: resultObj))")
                }
            } else {
                print("Room block error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            
            SwiftLoader.hide()
        }
    }
    
    func sessionExpairAlert(result_dict:  [String: Any]) {
        
        // error message...
        var final_msg = ""
        if let message_str = result_dict["message"] as? String {
            final_msg = message_str
        }
        
        // error code...
        var final_error = 0
        if let error_code = result_dict["error"] as? Int {
            final_error = error_code
        }
        
        if final_error == 400002 {
            
            // success action...
            let alertContorller = UIAlertController.init(title: "Alert!", message: final_msg, preferredStyle: .alert)
            let actionOk = UIAlertAction.init(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
                self.navigationController?.popToRootViewController(animated: true)
            })
            alertContorller.addAction(actionOk)
            self.present(alertContorller, animated: true, completion: nil)
        } else {
            self.view.makeToast(message: final_msg)
        }
    }

}

