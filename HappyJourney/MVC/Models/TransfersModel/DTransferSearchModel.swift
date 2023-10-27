//
//  DTransferSearchModel.swift
//  CheapToGo
//
//  Created by Provab1151 on 29/01/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

struct DTransferSearchModel {
    
    // static info...
    static var search_id = ""
    static var bookingSource = ""
    static var transferCityList_Array: [DTransferSearchItem] = []
    
    init() {
        
    }
    
    // clear all search information...
    static func clearAllTransferSearch_Information() {
        
        
        // remove array...
        transferCityList_Array.removeAll()
    }
    
    static func createModels(result_dict:[String: Any]) {
        
        if let searchId = result_dict["search_id"] as? Int {
            self.search_id = "\(searchId)"
        }
        if let booking_source = result_dict["booking_source"] as? String {
            self.bookingSource = booking_source
        }
        
        if let loDict = result_dict["transfer_list"] as? [String: Any] {
            
            if let transfer_dict = loDict["TransferSearchResult"] as? [String: Any] {
                
                if let transfer_list_array  = transfer_dict["TransferResults"] as? [[String: Any]] {
                    
                    for itemObj in transfer_list_array {
                        let model = DTransferSearchItem.init(details: itemObj)
                        self.transferCityList_Array.append(model)
                    }
                }
            }
        }
    }
}

struct DTransferSearchItem {
    
    var product_name: String?
    var product_code: String?
    var product_image: String?
    var destination_city: String?
    var star_rating: Int = 0
    var refund_status = false
    var duration: String?
    var reviews_count: String?
    var currency_code: String?
    var product_price: Double = 0.0
    var result_token: String?
    var Promotion:Bool? = false
    
    init(details: [String:Any]) {
        
        // default info...
        self.product_name = ""
        self.product_image = ""
        self.destination_city = ""
        self.duration = ""
        self.reviews_count = ""
        self.result_token = ""
        self.currency_code = "USD"
        
        // transfer info...
        if let productName = details["ProductName"] as? String {
            self.product_name = productName
        }
        if let productName = details["Promotion"] as? Bool {
            self.Promotion = productName
        }
        if let productCode = details["ProductCode"] as? String {
            self.product_code = productCode
        }
        if let product_img = details["ImageUrl"] as? String {
            self.product_image = product_img
        }
        if let dest_city = details["DestinationName"] as? String {
            self.destination_city = dest_city
        }
        if let rating = details["StarRating"] as? Int {
            self.star_rating = rating
        }
        if let refund = details["Cancellation_available"] as? Bool {
            self.refund_status = refund
        }
        if let dur = details["Duration"] as? String {
            self.duration = dur
        }
        if let review = details["ReviewCount"] as? String {
            self.reviews_count = review
        }
        if let priceInfo = details["Price"] as? [String: Any] {
            self.product_price = Double(String.init(describing: priceInfo["TotalDisplayFare"]!)) ?? 0.0
            
            if let currencySym = priceInfo["Currency"] as? String {
                self.currency_code = currencySym
            }
        }
        if let token = details["ResultToken"] as? String {
            self.result_token = token
        }
    }
}

