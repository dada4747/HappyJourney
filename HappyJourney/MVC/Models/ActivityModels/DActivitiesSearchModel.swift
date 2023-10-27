//
//  DActivitiesSearchModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 06/08/21.
//

import UIKit

struct DActivitiesSearchModel {
       
    static var activitiesCityList_Array: [DActivitySearchItem] = []
    
    init() {
        
    }
    // clear all search information...
    static func clearAllSearch_Information() {
        
        
        // remove array...
        activitiesCityList_Array.removeAll()
    }
    static func createModels(result_dict:[String: Any]) {
        
        if let dict = result_dict["data"] as? [String: Any] {
            
            if let transfer_dict = dict["SSSearchResult"] as? [String: Any] {
                
                if let transfer_list_array  = transfer_dict["SightSeeingResults"] as? [[String: Any]] {
                    
                    for itemObj in transfer_list_array {
                        let model = DActivitySearchItem.init(details: itemObj)
                        self.activitiesCityList_Array.append(model)
                    }
                }
            }
        }
    }
    
}
struct DActivitySearchItem {
    var ProductName: String? = ""
    var ProductCode: String? = ""
    var ImageUrl: String? = ""
    var BookingEngineId: String? = ""
    var PromotionAmount: Double = 0.0
    var StarRating: Int? = 0
    var ReviewCount: Int? = 0
    var DestinationName: String? = ""
    var Description: String? = ""
    var Cancellation_available: Bool?  = false
    var Supplier_Code: String? = ""
    var Duration: String = ""
    var Currency: String? = "USD"
    var TotalDisplayFare: Double = 0.0
    var ResultToken: String? = ""
    var Cat_Ids: [Int] = []
    var Sub_Cat_Ids:  [Int] = []
    var Promotion: Bool? = false
    
    init(details: [String:Any]) {
        
        if let productName = details["ProductName"] as? String {
            self.ProductName = productName
        }
        if let productName = details["Promotion"] as? Bool {
            self.Promotion = productName
        }
        if let productName = details["ProductCode"] as? String {
            self.ProductCode = productName
        }
        if let productName = details["ImageUrl"] as? String {
            self.ImageUrl = productName
        }
        if let productName = details["BookingEngineId"] as? String {
            self.BookingEngineId = productName
        }
        if let productName = details["PromotionAmount"] as? Double {
            self.PromotionAmount = productName
        }
        if let productName = details["StarRating"] as? Int {
            self.StarRating = productName
        }
        if let productName = details["ReviewCount"] as? Int {
            self.ReviewCount = productName
        }
        if let productName = details["DestinationName"] as? String {
            self.DestinationName = productName
        }
        if let productName = details["Description"] as? String {
            self.Description = productName
        }
        if let productName = details["Cancellation_available"] as? Bool {
            self.Cancellation_available = productName
        }
        if let productName = details["Supplier_Code"] as? String {
            self.Supplier_Code = productName
        }
        if let productName = details["Duration"] as? String {
            self.Duration = productName
        }
        if let productName = details["ResultToken"] as? String {
            self.ResultToken = productName
        }
        ///price
        if let obj = details["Price"] as? [String:Any] {
            if let productName = obj["TotalDisplayFare"] as? Double {
                self.TotalDisplayFare = productName
            }
            if let productName = obj["Currency"] as? String {
                self.Currency = productName
            }
            
        }
        if let arr = details["Cat_Ids"] as? [Int] {
            self.Cat_Ids = arr
        }
        if let arr = details["Sub_Cat_Ids"] as? [Int] {
            self.Sub_Cat_Ids = arr
        }
        
    }
}
