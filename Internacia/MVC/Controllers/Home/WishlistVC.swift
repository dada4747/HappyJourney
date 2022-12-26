//
//  WishlistVC.swift
//  Internacia
//
//  Created by Admin on 12/11/22.
//

import UIKit

class WishlistVC: UIViewController {
    @IBOutlet weak var tbl_hotelsList: UITableView!
    var hotelsList_array: [DWishlistItem] = []

    @IBOutlet weak var lbl_emptyMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegates()
        // Do any additional setup after loading the view.
    }
    func addDelegates(){
        tbl_hotelsList.delegate = self
        tbl_hotelsList.dataSource = self
        tbl_hotelsList.rowHeight = UITableView.automaticDimension
        tbl_hotelsList.estimatedRowHeight = 140
        SwiftLoader.show(animated: true)
        DWishlistModel.gettingWishlitHotels { success, error in
            if success == true {
                DispatchQueue.main.async {
                    self.displayHotelList()
                    SwiftLoader.hide()
                }
            }else {
                self.lbl_emptyMessage.isHidden = false
            }
        }
    }
    func displayHotelList(){
        hotelsList_array = DWishlistModel.wishlist_array
        lbl_emptyMessage.isHidden = true
//        btn_search.isHidden = false
        if hotelsList_array.count == 0 {
            lbl_emptyMessage.isHidden = false
//            btn_search.isHidden = true
        }
        tbl_hotelsList.reloadData()
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
}
extension WishlistVC: UITableViewDelegate, UITableViewDataSource, hSearchListCellDelegate {
    
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
        cell?.display_hotelsearchInformation(hModel: hotelsList_array[indexPath.row].wishkey!)
        cell?.btn_wishlist.setImage(UIImage(named: "ic_wishlist_sel"), for: .normal)
        cell?.selectionStyle = .none
        return cell!
    }
    
    // MARK:- hSearchListCellDelegate
    func hotelBooking_Action(sender: UIButton, cell: UITableViewCell) {
        
        let indexPath = tbl_hotelsList .indexPath(for: cell)
        DHTravelModel.select_hotel = hotelsList_array[(indexPath?.row)!].wishkey!

        // move to details...
        let hotelDetailObj = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelRoomsListVC") as! HotelRoomsListVC
        hotelDetailObj.select_hotel = hotelsList_array[(indexPath?.row)!].wishkey!
        DHotelSearchModel.search_id = hotelsList_array[(indexPath?.row)!].search_id!
//        DHTravelModel.checkin_date
        DHotelSearchModel.booking_source = hotelsList_array[(indexPath?.row)!].booking_source!
        self.navigationController?.pushViewController(hotelDetailObj, animated: true)
    }
    func hotelAddWishlist_Action(sender: UIButton, cell: UITableViewCell) {
        let indexPath = tbl_hotelsList .indexPath(for: cell)
        let key = hotelsList_array[(indexPath?.row)!].orign
        SwiftLoader.show(animated: true)
        DWishlistModel.removeHotelToWishlist(origin: key!) {
            self.view.makeToast(message: "Removed Successfully")
            DWishlistModel.wishlist_array.removeAll()
            DWishlistModel.gettingWishlitHotels {success,err in 
                DispatchQueue.main.async {
                    
                    self.displayHotelList()
                    SwiftLoader.hide()
                }

            }

            
        }
    }
}
extension WishlistVC {
//    func gettingWishlitHotels(){
//        SwiftLoader.show(animated: true)
//        //getting wishtlist
////        paramString["hotel_params"] = VKAPIs.getJSONString(object: params)
////        paramString["Token"] = DHPreBookingModel.preBookingItem?.token ?? ""
//     let userID = ""
//        let param: [String : String] = [
//            "module" : "hotel",
//            "user_id": userID.getUserId()]
//        VKAPIs.shared.getRequestXwwwform(params: param, file: "general/get_wishlist", httpMethod: .POST) { resultObject, success, error in
//            if success == true {
//                print("Wishlist hotel success: \(String(describing: resultObject))")
//
//                if let result = resultObject as? [String: Any] {
//                    if result["status"] as? Bool == true {
//                        if let data = result["data"] as? [[String: Any]] {
//                            // response data...
//                            print("create model ")
//                            DWishlistModel.creatWishListModels(result_dict: data)
//                        }
//                    } else {
//
//                        // error message...
//                        if let message_str = result["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                        }
//                    }
//                } else {
//                    print("Hotel Wishlist list formate : \(String(describing: resultObject))")
//                }
//            } else {
//                print("Hotel Wishlist list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//            }
//            self.displayHotelList()
//            SwiftLoader.hide()
//        }
//    }
}
