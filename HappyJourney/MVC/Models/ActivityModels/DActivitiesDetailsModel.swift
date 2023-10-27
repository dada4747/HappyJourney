//
//  DActivitiesDetailsModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 09/08/21.
//

import UIKit

struct DActivitiesDetailsModel {
    
    // static info...
    static var product_name = ""
    static var duration = ""
    static var product_price: Double = 0.0
    static var rating = 0
    static var product_img = ""
    static var isCancel: Bool = false
    static var cancellationdays = ""
    static var cancellationPolicy_text = ""
    static var overview_short_descp_text = ""
    static var product_descrption = ""
    static var currency_code = "USD"
    static var resultToken = ""
    static var ShortDescription = ""
    static var MaxTravellerCount = 0
    
    static var customer_Review_Array: [DTransDetailCustReviewItem] = []
    static var additionalInfo_Array: [Any] = []
    static var ageBands_Array: [AgeBandsItem] = []
    static var datesAvailability_Array: [Any] = []
    
    static var token_Data: TokensDataModel?
    
    
    init() {
        
    }
    
    // clear all search information...
    static func clearAllTransferSearch_Information() {
        
        
        // remove array...
        //transferCityList_Array.removeAll()
    }
    
    static func createModels(result_dict:[String: Any]) {
        
            
            if let pro_name = result_dict["ProductName"] as? String {
                self.product_name = pro_name
            }
            if let token = result_dict["ResultToken"] as? String {
                self.resultToken = token
            }
            if let token = result_dict["ShortDescription"] as? String {
                self.ShortDescription = token
            }
        if let token = result_dict["MaxTravellerCount"] as? Int {
            self.MaxTravellerCount = token
        }
            
            
            
            
            if let dur = result_dict["Duration"] as? String {
                self.duration = dur
            }
            if let star_rating = result_dict["StarRating"] as? Int {
                self.rating = star_rating
            }
            if let img_url = result_dict["product_image"] as? String {
                self.product_img = img_url
            }
            if let cancel_avaliable = result_dict["Cancellation_available"] as? Bool {
                self.isCancel = cancel_avaliable
            }
            if let cancel_days = result_dict["Cancellation_day"] as? Int {
                self.cancellationdays = "\(cancel_days)"
            }
            if let cancel_text = result_dict["Cancellation_Policy"] as? String {
                self.cancellationPolicy_text = cancel_text
            }
            if let short_descp = result_dict["ShortDescription"] as? String {
                self.overview_short_descp_text = short_descp
            }
            if let descp = result_dict["Description"] as? String {
                self.product_descrption = descp
            }
            if let add_info_array = result_dict["AdditionalInfo"] as? [Any] {
                self.additionalInfo_Array = add_info_array
            }
            
            // customer review...
            if let loReview_array  = result_dict["Product_Reviews"] as? [[String: Any]] {
                
                for itemObj in loReview_array {
                    let model = DTransDetailCustReviewItem.init(details: itemObj)
                    self.customer_Review_Array.append(model)
                }
            }
            
            // price...
            if let priceInfo = result_dict["Price"] as? [String: Any] {
                self.product_price = Double(String.init(describing: priceInfo["TotalDisplayFare"]!)) ?? 0.0
                
                if let currencySym = priceInfo["Currency"] as? String {
                    self.currency_code = currencySym
                }
            }
            
            // available dates...
            if let dates_array = result_dict["Calendar_available_date"] as? [Any] {
                self.datesAvailability_Array = dates_array
            }
            //age bands
            self.ageBands_Array.removeAll()
            if let dates_array = result_dict["Product_AgeBands"] as? [[String: Any]] {
                for item in dates_array{
                    let model = AgeBandsItem.init(details: item)
                    self.ageBands_Array.append(model)
                }
            }
            
        
        
        if let tokens = result_dict["tokens_data"] as? [String: Any] {
            self.token_Data = TokensDataModel(details: tokens)
        }
    }
}
