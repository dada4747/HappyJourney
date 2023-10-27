//
//  DTransferDetailsModel.swift
//  CheapToGo
//
//  Created by Provab1151 on 31/01/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

struct DTransferDetailsModel {
    
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
        
        if let product_details = result_dict["product_details"] as? [String: Any] {
            
            if let pro_name = product_details["ProductName"] as? String {
                self.product_name = pro_name
            }
            if let token = product_details["ResultToken"] as? String {
                self.resultToken = token
            }
            if let token = product_details["ShortDescription"] as? String {
                self.ShortDescription = token
            }
            
            if let dur = product_details["Duration"] as? String {
                self.duration = dur
            }
            if let star_rating = product_details["StarRating"] as? Int {
                self.rating = star_rating
            }
            if let img_url = product_details["product_image"] as? String {
                self.product_img = img_url
            }
            if let cancel_avaliable = product_details["Cancellation_available"] as? Bool {
                self.isCancel = cancel_avaliable
            }
            if let cancel_days = product_details["Cancellation_day"] as? Int {
                self.cancellationdays = "\(cancel_days)"
            }
            if let cancel_text = product_details["Cancellation_Policy"] as? String {
                self.cancellationPolicy_text = cancel_text
            }
            if let short_descp = product_details["ShortDescription"] as? String {
                self.overview_short_descp_text = short_descp
            }
            if let descp = product_details["Description"] as? String {
                self.product_descrption = descp
            }
            if let add_info_array = product_details["AdditionalInfo"] as? [Any] {
                self.additionalInfo_Array = add_info_array
            }
            
            // customer review...
            if let loReview_array  = product_details["Product_Reviews"] as? [[String: Any]] {
                
                for itemObj in loReview_array {
                    let model = DTransDetailCustReviewItem.init(details: itemObj)
                    self.customer_Review_Array.append(model)
                }
            }
            
            // price...
            if let priceInfo = product_details["Price"] as? [String: Any] {
                self.product_price = Double(String.init(describing: priceInfo["TotalDisplayFare"]!)) ?? 0.0
                
                if let currencySym = priceInfo["Currency"] as? String {
                    self.currency_code = currencySym
                }
            }
            
            // available dates...
            if let dates_array = product_details["Calendar_available_date"] as? [Any] {
                self.datesAvailability_Array = dates_array
            }
            
            //age bands
            self.ageBands_Array.removeAll()
            if let dates_array = product_details["Product_AgeBands"] as? [[String: Any]] {
                for item in dates_array{
                    let model = AgeBandsItem.init(details: item)
                    self.ageBands_Array.append(model)
                }
            }
            
        }
        
        if let tokens = result_dict["tokens_data"] as? [String: Any] {
            self.token_Data = TokensDataModel(details: tokens)
        }
    }
}

struct DTransDetailCustReviewItem {
    
    var customer_name: String?
    var customer_image: String?
    var customer_rating: String?
    var customer_review: String?
    var published_date: String?
    
    init(details: [String: Any]) {
        
        // default info...
        customer_name = ""
        customer_image = ""
        customer_rating = ""
        customer_review = ""
        published_date = ""
        
        if let cust_name = details["UserName"] as? String {
            self.customer_name = cust_name
        }
        if let cust_img = details["UserImage"] as? String {
            self.customer_image = cust_img
        }
        if let cust_rating = details["Rating"] as? String {
            self.customer_rating = cust_rating
        }
        if let cust_review = details["Review"] as? String {
            self.customer_review = cust_review
        }
        if let date = details["Published_Date"] as? String {
            self.published_date = date
        }
    }
}
struct AgeBandsItem {
    
    var description: String?
    var count: Int?
    var band_Id: Int?
    init(details: [String: Any]) {
        description = ""
        count = 0
        band_Id = 0
        
        if let cust_name = details["description"] as? String {
            self.description = cust_name
        }
        if let cust_rating = details["bandId"] as? Int {
            self.band_Id = cust_rating
        }
        if let cust_img = details["count"] as? Int {
            ///By default 1 adult
            if band_Id == 1{
                if cust_img == 0{
                    self.count = 1
                    return
                }
            }
            self.count = cust_img
        }
    }
}
struct TokensDataModel {
    
    var AdditionalInfo: String? = ""
    var Inclusions: String? = ""
    var Exclusions: String? = ""
    var ShortDescription: String? = ""
    var voucher_req: String? = ""
    var API_Price: String? = ""
    
    init(details: [String: Any]) {
        
        if let cust_name = details["AdditionalInfo"] as? String {
            self.AdditionalInfo = cust_name
        }
        if let cust_name = details["Inclusions"] as? String {
            self.Inclusions = cust_name
        }
        if let cust_name = details["Exclusions"] as? String {
            self.Exclusions = cust_name
        }
        if let cust_name = details["ShortDescription"] as? String {
            self.ShortDescription = cust_name
        }
        if let cust_name = details["voucher_req"] as? String {
            self.voucher_req = cust_name
        }
        if let cust_name = details["API_Price"] as? String {
            self.API_Price = cust_name
        }
    }
}
