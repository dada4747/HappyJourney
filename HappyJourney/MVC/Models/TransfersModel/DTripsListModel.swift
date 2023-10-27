//
//  DTripsListModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 03/08/21.
//

import UIKit

struct DTripsListModel {
    
    static var ageBand_token = ""
    static var booking_source = ""
    static var tripList:[TripList] = []
    
    init() {
        
    }
    
    static func createModels(result_dict:[String: Any]) {
        
        if let pro_name = result_dict["ageBand_token"] as? String {
            self.ageBand_token = pro_name
        }
        if let pro_name = result_dict["booking_source"] as? String {
            self.booking_source = pro_name
        }
        tripList.removeAll()
        ///Transfers
        if let pro_name = result_dict["tourgrade_list"] as? [String:Any] {
            if let arr = pro_name["Trip_list"] as? [[String: Any]] {
                for item in arr{
                    let obj = TripList.init(result_dict: item)
                    self.tripList.append(obj)
                }
            }
        }else{
            ///Activities
            if let arr = result_dict["Trip_list"] as? [[String: Any]] {
                for item in arr{
                    let obj = TripList.init(result_dict: item)
                    self.tripList.append(obj)
                }
            }
        }
    }
}
struct TripList {
    var gradeTitle = ""
    var gradeDescription = ""
    var gradeCode = ""
    var bookingDate = ""
    var TotalPax = 0
    var TotalDisplayFare = 0.0
    var TourUniqueId = ""
    
    init(result_dict: [String: Any]) {
        
        if let pro_name = result_dict["gradeTitle"] as? String {
            self.gradeTitle = pro_name
        }
        if let pro_name = result_dict["gradeDescription"] as? String {
            self.gradeDescription = pro_name
        }
        if let pro_name = result_dict["gradeCode"] as? String {
            self.gradeCode = pro_name
        }
        if let pro_name = result_dict["bookingDate"] as? String {
            self.bookingDate = pro_name
        }
        if let pro_name = result_dict["TotalPax"] as? Int {
            self.TotalPax = pro_name
        }
        if let pro_name = result_dict["TourUniqueId"] as? String {
            self.TourUniqueId = pro_name
        }
        if let pro_name = result_dict["Price"] as? [String:Any] {
            if let pro = pro_name["TotalDisplayFare"] as? Double {
                self.TotalDisplayFare = pro
            }
        }
    }
    
}
