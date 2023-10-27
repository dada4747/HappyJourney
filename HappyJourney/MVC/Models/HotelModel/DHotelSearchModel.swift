//
//  DHotelSearchModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import CoreMedia

// MARK:- DHotelSearchModel
struct DHotelSearchModel {
    
    // static info...
    static var search_id = ""
    static var booking_source = ""
    static var hotelsSearch_array: [DHotelSearchItem] = []
    
    // create search items...
    static func createModels(result_dict: [String: Any]) {
        
        if let searchID = result_dict["search_id"] as? Int {
            self.search_id = "\(searchID)"
        }
        
        if let bookingSource = result_dict["booking_source"] as? String {
            self.booking_source = bookingSource
        }
        
        if let data_dict = result_dict["data"] as? [String: Any] {
            
            if let hotelList_dict = data_dict["HotelSearchResult"] as? [String: Any] {
                
                if let list_array = hotelList_dict["HotelResults"] as? [[String: Any]] {
                    for hotel_dict in list_array {
                        let searchItem = DHotelSearchItem.init(details: hotel_dict)
                        self.hotelsSearch_array.append(searchItem)
                    }
                }
            }
        }
        
        DHotelFilters.getHotelssAndPrice_fromResponse()
    }
}

// MARK:- DHotelSearchItem
struct DHotelSearchItem {
    
    // elements...
    var resultIndex: String?
    var resultToken: String?
    var wishKey: String?
    var hotel_id: String?
    var hotel_name: String?
    var hotel_code: String?
    
    var hotel_img: String?
    var hotel_address: String?
    var hotel_location: String?
    
    var hotel_rating: Int = 0
    var hotel_class: Int = 0
    var hotel_price: Float = 0.0
    var hotel_currency = "USD"
    var hotel_gst: Float = 0.0
    
    var wifi = false
    var breakfast = false
    var parking = false
    var swim = false

    var isWishlisted = false
    var wishKey_origin : String? = ""
    var hotel_info: [String: Any] = [:]
    var hotelOriginCode: String?
    init(details: [String: Any]) {
        
        self.resultIndex = ""
        self.resultToken = ""
        self.wishKey = ""
        self.hotel_id = ""
        self.hotel_name = ""
        self.hotel_code = ""
        
        self.hotel_img = ""
        self.hotel_address = ""
        self.hotel_location = ""
        self.hotelOriginCode = ""
        self.hotel_info = details
//        self.wishKey_origin = origin
        
//        self.isWishlisted = false
        
        // hotels id, code, name...
        if let result_index = details["ResultIndex"] as? Int {
            self.resultIndex = String(result_index)
        }
        if let result_token = details["ResultToken"] as? String {
            self.resultToken = result_token
        }
        
        if let hotelID = details["id"] as? String {
            self.hotel_id = hotelID
        }
        if let hotelName = details["HotelName"] as? String {
            self.hotel_name = hotelName
        }
        if let hotelCode = details["HotelCode"] as? String {
            self.hotel_code = hotelCode
        }
        
        // hotel image, address, location...
        if let hotelImg = details["HotelPicture"] as? String {
            self.hotel_img = hotelImg
        }
        if let hotelAddress = details["HotelAddress"] as? String {
            self.hotel_address = hotelAddress
        }
        if let hotelLocation = details["HotelLocation"] as? String {
            self.hotel_location = hotelLocation
        }
        if let oringinHotelCode = details["OrginalHotelCode"] as? String {
            self.hotelOriginCode = oringinHotelCode
        }
        // hotel rating, class, currency, price
        if let hotelRate = details["StarRating"] as? Int {
            self.hotel_rating = hotelRate
        }
        if let hotelClass = details["class"] as? Int {
            self.hotel_class = hotelClass
        }
        if let price_dict = details["Price"] as? [String: Any] {
            
            self.hotel_price = Float(String.init(describing: price_dict["RoomPrice"]!))!
            if let hotelCurrency = price_dict["currency"] as? String {
                self.hotel_currency = hotelCurrency
            }
            
            self.hotel_gst = Float(String.init(describing: price_dict["_GST"]!))!
            
        }
        if let wishdata = details["wishtoken"] as? String {
            self.wishKey = wishdata
        }
        self.isWishlisted = checkWishlisted()
        self.wishKey_origin = addOrigin()
        // amenities...
        if let amenities_dict = details["HotelAmenities"] as? [String] {
            if amenities_dict.contains("wifi"){
                self.wifi = true
            }
            if amenities_dict.contains("Free breakfast") || amenities_dict.contains("Breakfast available (surcharge)"){
                self.breakfast = true
            }
            if amenities_dict.contains("Free self parking") || amenities_dict.contains("Free valet parking") {
                self.parking = true
            }
            if amenities_dict.contains("Outdoor seasonal pool") || amenities_dict.contains("Outdoor pool") {
                self.swim = true
            }
//            "Indoor pool"
//            "Poolside bar"
//            "Breakfast available (surcharge)",
//            "Free self parking",
//            "Free valet parking",
//            "Outdoor pool",
//            "Pool sun loungers"
//            if amenities_dict["wifi"] as? Bool == true {
//                self.wifi = true
//            }
//            if amenities_dict["Free breakfast"] as? Bool == true {
//                self.breakfast = true
//            }
//            if amenities_dict["Free self parking"] as? Bool == true {
//                self.parking = true
//            }
//            if amenities_dict["Outdoor seasonal pool"] as? Bool == true {
//                self.swim = true
//            }
        }
    }
    func addOrigin() -> String {
        var key = ""
        DWishlistModel.wishlist_array.forEach({ item in
            if item.wishkey?.hotel_name == self.hotel_name {
                key = item.orign!
            }
        })
        return key
    }
    func checkWishlisted() -> Bool {
        if DWishlistModel.wishlist_array.contains(where: {$0.wishkey?.hotel_name == self.hotel_name}) {
            
                return true
        } else {
            return false
           //item could not be found
        }
        
    }
}
