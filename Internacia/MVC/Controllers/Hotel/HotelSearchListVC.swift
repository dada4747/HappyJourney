//
//  HotelSearchListVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit
import AVFoundation
class HotelSearchListVC: UIViewController {

    // MARK:- Outlet
    @IBOutlet weak var tbl_hotelsList: UITableView!
    @IBOutlet weak var lbl_emptyMessage: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_hotelSearch: UIView!
    @IBOutlet weak var tf_hotelSearch: UITextField!
    @IBOutlet weak var btn_search: UIButton!
    
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_checkInDate: UILabel!
    @IBOutlet weak var lbl_checkOutDate: UILabel!
    @IBOutlet weak var lbl_numOfRooms: UILabel!
    @IBOutlet weak var lbl_guestCount: UILabel!
    
    @IBOutlet weak var img_nameFilter: UIImageView!
    @IBOutlet weak var img_starRatingFilter: UIImageView!
    @IBOutlet weak var img_priceFilter: UIImageView!
    // varibales...
    var hotelsList_array: [DHotelSearchItem] = []
    var hotelsMain_array: [DHotelSearchItem] = []
    var RoomsCount = NSMutableArray()
    var sort_number: Int = 0
    var sortByPrice = true
    var sortByRating = true
    var sortByHotelName = true
    
    var audioPlayer : AVAudioPlayer?
    var lendingPlay: AVQueuePlayer = {
        let url1 = Bundle.main.url(forResource: "landing-load", withExtension: "mp3")!
        let url2 = Bundle.main.url(forResource: "hotel-pre-load", withExtension: "mp3")!
        let item1 = AVPlayerItem(url: url1)
        let item2 = AVPlayerItem(url: url2)

        let queue = AVQueuePlayer(items: [item1, item2])
        return queue
        }()
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lendingPlay.play()
        // bottom shadow...
        view_header.viewShadow()
        DHotelSearchModel.hotelsSearch_array.removeAll()
        SwiftLoader.show(animated: true)
        DWishlistModel.gettingWishlitHotels(completion: { success, error in
            if success == true{
                //show successfully loader wishlist
            }
        }) 
        
        // table delegates...
        tbl_hotelsList.delegate = self
        tbl_hotelsList.dataSource = self
        tbl_hotelsList.rowHeight = UITableView.automaticDimension
        tbl_hotelsList.estimatedRowHeight = 140
        self.view_hotelSearch.isHidden = true
        self.tf_hotelSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        displayRoomAndGuest_Information()
        
        // get hotels list...
        gettingHotels_SearchList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helpers
    func displayRoomAndGuest_Information() {
        
        // display information...
        lbl_numOfRooms.text = "\(AddRoomModel.addRooms_array.count) Rooms"
        lbl_guestCount.text = "\(DHTravelModel.adult_count + DHTravelModel.child_count) Guests"
        lbl_checkInDate.text = DateFormatter.getDateString(formate: "EEE dd, MMM", date: DHTravelModel.checkin_date)
        lbl_checkOutDate.text = DateFormatter.getDateString(formate: "EEE dd, MMM", date: DHTravelModel.checkout_date)
        lbl_city.text = DHTravelModel.hotelCity_dict!["city"]! + " , " + DHTravelModel.hotelCity_dict!["country"]!
    }
    func playSound(sound: String) {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func displayHotelListMethod() {
        
        // reload tables...
        hotelsMain_array = DHotelFilters.applyAll_filterAndSorting(_hotels: DHotelSearchModel.hotelsSearch_array)
        hotelsList_array = hotelsMain_array
        // empty message...
        lbl_emptyMessage.isHidden = true
        btn_search.isHidden = false
        if hotelsList_array.count == 0 {
            lbl_emptyMessage.isHidden = false
            btn_search.isHidden = true
        }
        tbl_hotelsList.reloadData()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {

            let filter_array = hotelsMain_array.filter { ($0.hotel_name! as NSString).localizedCaseInsensitiveContains(textField.text ??  "")}
            hotelsList_array = filter_array
        } else {
            hotelsList_array = hotelsMain_array
        }
        tbl_hotelsList.reloadData()
    }
    
    func attributeString(fromSting: String, searchString: String) -> NSMutableAttributedString {
        
        // getting range...
        let final_from = fromSting.lowercased() as NSString
        let final_search = searchString.lowercased()
        let rangeVal = final_from.range(of: final_search)
        
        // attribute string...
        let final_arribute = NSMutableAttributedString.init(string: fromSting)
        final_arribute.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor.init(red: 32.0/255.0, green: 151.0/255.0, blue: 217.0/255.0, alpha: 1.0),
                                    range: rangeVal)
        final_arribute.addAttribute(NSAttributedString.Key.font,
                                    value: UIFont(name: "Raleway Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14.0),
                                    range: rangeVal)
        return final_arribute
    }
    
    // MARK:- ButtonActions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAndCancelButtonsClicked(_ sender: UIButton) {
        
        if sender.tag == 10 {
            self.view_hotelSearch.isHidden = false
        } else {
            
            self.tf_hotelSearch.text = ""
            hotelsList_array = hotelsMain_array
            tbl_hotelsList.reloadData()
            self.view_hotelSearch.isHidden = true
        }
    }
    
    @IBAction func hotelFiltersButtonClicked(_ sender: UIButton) {
        
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels information not available.")
            return
        }
        
        // move to filters screen...
        let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelFiltersVC") as! HotelFiltersVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    @IBAction func listfilterButtonAction(_ sender: Any) {
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels information not available.")
            return
        }
        
        // move to filters screen...
        let filterObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelFiltersVC") as! HotelFiltersVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    @IBAction func filterNameAction(_ sender: Any) {
                
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels list not available. Please try again")
            return
        }
        
        if sortByHotelName {
            // sort by A to Z...
            sortByHotelName = false
            sort_number = 5
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_nameFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByHotelName = true
            sort_number = 4
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_nameFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        
        DHotelFilters.sort_number = sort_number
        hotelsFiltersApply_removeIntimation()
    }
    @IBAction func filterRatingAction(_ sender: Any) {
        print("filter rating")
        
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels list not available. Please try again")
            return
        }
        
        if sortByRating {
            // sort by A to Z...
            sortByRating = false
            sort_number = 3
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_starRatingFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByRating = true
            sort_number = 2
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_starRatingFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        
        DHotelFilters.sort_number = sort_number
        //applyHotelSorting()
        hotelsFiltersApply_removeIntimation()
    }
    
    @IBAction func filterPriceAction(_ sender: Any) {
    print("filter price")
        
        
        // if data not available...
        if DHotelSearchModel.hotelsSearch_array.count == 0 {
            self.view.makeToast(message: "Hotels list not available. Please try again")
            return
        }
        
        if sortByPrice {
            // sort by A to Z...
            sortByPrice = false
            sort_number = 1
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_priceFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByPrice = true
            sort_number = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_priceFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        
        DHotelFilters.sort_number = sort_number
        //applyHotelSorting()
        hotelsFiltersApply_removeIntimation()
    }
    
}

extension HotelSearchListVC: hotelFiltersDelegate {
    
    // MARK:- hotelFiltersDelegate
    func hotelsFiltersApply_removeIntimation() {
        
        // display hotels...
        displayHotelListMethod()
        
        // scrolling table...
        let indexPath = IndexPath.init(row: 0, section: 0)
        if hotelsList_array.count != 0 {
            tbl_hotelsList.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
}

extension HotelSearchListVC: UITableViewDelegate, UITableViewDataSource, hSearchListCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsList_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HSearchListCell") as? HSearchListCell
        if cell == nil {
            tableView.register(UINib(nibName: "HSearchListCell", bundle: nil), forCellReuseIdentifier: "HSearchListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HSearchListCell") as? HSearchListCell
        }
        cell?.delegate = self
        cell?.display_hotelsearchInformation(hModel: hotelsList_array[indexPath.row])
        
        // search color...
        cell?.lbl_hotelName.attributedText = self.attributeString(fromSting: hotelsList_array[indexPath.row].hotel_name ?? "",
                                                                  searchString: self.tf_hotelSearch.text ?? "")
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK:- hSearchListCellDelegate
    func hotelBooking_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_hotelsList .indexPath(for: cell)
        DHTravelModel.select_hotel = hotelsList_array[(indexPath?.row)!]
        
        // move to details...
        let hotelDetailObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelRoomsListVC") as! HotelRoomsListVC
        hotelDetailObj.select_hotel = hotelsList_array[(indexPath?.row)!]
        self.navigationController?.pushViewController(hotelDetailObj, animated: true)
    }
    func hotelAddWishlist_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_hotelsList.indexPath(for: cell)
        DHTravelModel.select_hotel = hotelsList_array[(indexPath?.row)!]
        
        if DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].isWishlisted == true {
            DWishlistModel.removeHotelToWishlist(origin: DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].wishKey_origin!) {
                DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].isWishlisted = false
                self.displayHotelListMethod()

            }

//            removeHotelToWishlist(origin: DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].wishKey_origin!) {
//                DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].isWishlisted = false
//            }
            
        }else {
            let wishKey = hotelsList_array[(indexPath?.row)!].wishKey
            
            addHotelToWishlist(wishKey: wishKey!, completion: {
                DHotelSearchModel.hotelsSearch_array[(indexPath?.row)!].isWishlisted = true
            })
        }
    }
}

extension HotelSearchListVC {
    
    // MARK:- API's
    func addHotelToWishlist(wishKey: String, completion: @escaping () ->()) {
        SwiftLoader.show(animated: true)
        let userId = ""
        let param: [String : String] = [
            "module" : "hotel",
            "user_id" : userId.getUserId(),
            "search_id" : DHotelSearchModel.search_id,
            "expiry_date" : DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date),
            "wish_data" : wishKey]
        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/add_wishlist", httpMethod: .POST) { resultObject, success, error in
            if success == true {
                print("Add Wishlist success: \(String(describing: resultObject))")
                if let result = resultObject as? [String : Any] {
                    if result["status"] as? Bool == true {
                        completion()
                        self.view.makeToast(message: "Added To Wishlist")
                    }else{
                    }
                }else {
                    print("Add Wishlist list formate : \(String(describing: resultObject))")

                }
            }else {
                print("Add Wishlist list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayHotelListMethod()
            SwiftLoader.hide()
        }
    }
//    func removeHotelToWishlist(origin: String, completion: @escaping () ->()) {
//        SwiftLoader.show(animated: true)
//        let userId = ""
//        let param: [String : String] = [
//            "module" : "hotel",
//            "user_id" : userId.getUserId(),
//            "origin" : origin]
//        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/remove_wishlist", httpMethod: .POST) { resultObject, success, error in
//            if success == true {
//                print("Add Wishlist success: \(String(describing: resultObject))")
//                if let result = resultObject as? [String : Any] {
//                    if result["status"] as? Bool == true {
//                        completion()
//                        self.view.makeToast(message: "Removed from Wishlist")
//                    }else{
//                    }
//                }else {
//                    print("Add Wishlist list formate : \(String(describing: resultObject))")
//
//                }
//            }else {
//                print("Add Wishlist list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//            }
//            self.displayHotelListMethod()
//            SwiftLoader.hide()
//        }
//    }
    func gettingHotels_SearchList() {
        
        SwiftLoader.show(animated: true)
        
        // getting room details...
        var room_array: [Any] = []
        for i in 0..<AddRoomModel.addRooms_array.count {
            let model = AddRoomModel.addRooms_array[i]
            var room : [String: Any] = ["NoOfAdults": model.adult_count]
            room["NoOfChild"] = model.child_count
            room["childAge_\(i + 1)"] = []
            if model.child_count == 1 {
                room["childAge_\(i + 1)"] = ["\(model.child_age1)"]
            } else if model.child_count == 2 {
                room["childAge_\(i + 1)"] = ["\(model.child_age1)", "\(model.child_age2)"]
            } else {}
            room_array.append(room)
            
        }
//        for model in AddRoomModel.addRooms_array {
//
//            // room details...
//            var room: [String: Any] = ["NoOfAdults": "\(model.adult_count)"]
//            room["NoOfChild"] = "\(model.child_count)"
//            room["ChildAge_1"] = []
//            if model.child_count == 1 {
//                room["childAge_1"] = [model.child_age1]
//            }
//            else if model.child_count == 2 {
//                room["childAge_2"] = [model.child_age1, model.child_age2]
//            }
//            else {}
//            room_array.append(room)
//        }
        print(String(DHTravelModel.noof_nights))
        
        // params...
        let params: [String: Any] = ["CheckInDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkin_date),
                                     "CheckOutDate": DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date),
                                     "RoomGuests": room_array,
                                     "CityId": DHTravelModel.hotelCity_dict!["id"]!,
                                     "NoOfRooms": "\(AddRoomModel.addRooms_array.count)",
                                     "NoOfNights": "\(DHTravelModel.noof_nights)"]
        print("params: \(params)")
        
        let paramString: [String: String] = ["hotel_search": VKAPIs.getJSONString(object: params)]
        
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel search list success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        self.lendingPlay.pause()
                        self.playSound(sound: "hotel-post-load")

                        // response data...
                        DHotelSearchModel.createModels(result_dict: result)
                    } else {
                        self.lendingPlay.pause()
                        self.playSound(sound: "all-empty-result")
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Hotel search list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayHotelListMethod()
            SwiftLoader.hide()
        }
    }
}
