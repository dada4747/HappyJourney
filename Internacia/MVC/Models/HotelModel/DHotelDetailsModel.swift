//
//  DHotelDetailsModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// MARK:- DHotelDetailsModel
struct DHotelDetailsModel {
    
    // variables...
    var hotelName = ""
    var hotelCode = ""
    var hotelRating = ""
    var address = ""
    var policy = ""
    var description = ""
    var traceId = ""
    var amenities_array: [String] = []
    var media_array: [String] = []
    var latitude: Float = 0.0
    var longtitude: Float = 0.0
    var checkin: Date?
    var checkout: Date?
    static var hotel_details = DHotelDetailsModel()
    static var roomsArray: [DHotelRoomItem] = []
    
    // generate models...
    static func createModel(dateInfo: [String: Any]) -> DHotelDetailsModel {
        
        var model = DHotelDetailsModel()
        
        if let hotelInfoResult = dateInfo["HotelInfoResult"] as? [String: Any] {
            
            if let trace_id = hotelInfoResult["TraceId"] as? String {
                model.traceId = trace_id
            }
            if let hoteldetails_dict = hotelInfoResult["HotelDetails"] as? [String: Any] {
                
                // address...
                if let address_str = hoteldetails_dict["Address"] as? String {
                    model.address = address_str
                }
                if let policy_str = hoteldetails_dict["policy"] as? String {
                    model.policy = policy_str
                }
                if let description_str = hoteldetails_dict["Description"] as? String {
                    model.description = description_str
                }
                
                if let rating = hoteldetails_dict["StarRating"] as? Int {
                    model.hotelRating = String(rating)
                }
                if let checkin = hoteldetails_dict["checkin"] as? String {
                    let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: checkin)

                    model.checkin = originDate
                    DHTravelModel.checkin_date = originDate
                }
                if let checkout = hoteldetails_dict["checkout"] as? String {
                    let originDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: checkout)
                    model.checkout = originDate
                    DHTravelModel.checkout_date = originDate
                }
                if let hotel_name = hoteldetails_dict["HotelName"] as? String {
                    model.hotelName = hotel_name
                }
                
                if let hotel_code = hoteldetails_dict["HotelCode"] as? String {
                    model.hotelCode = hotel_code
                }
                
                // array...
                if let amenities = hoteldetails_dict["HotelFacilities"] as? [String] {
                    model.amenities_array = amenities
                }
                if let media_imgs = hoteldetails_dict["Images"] as? [String] {
                    model.media_array = media_imgs
                }
                
                // location...
                if let lat = hoteldetails_dict["Latitude"] as? String {
                    model.latitude = Float(lat) ?? 0.0
                }
                
                if let long = hoteldetails_dict["Longitude"] as? String {
                    model.longtitude = Float(long) ?? 0.0
                }
            }
            
            hotel_details = model
        }
        return model
    }
    
    // room list getting...
    static func createRoomModels(dataInfo: [[String: Any]]) {
        for room_info in dataInfo {
            if let roomData = room_info["room_data"] as? [String: Any] {
                let model = DHotelRoomItem.init(info: roomData)
                roomsArray.append(model)
            }
        }
    }
}


// MARK:- DHotelRoomItem
struct DHotelRoomItem {
    
    // variables...
    var room_id: String?
    var room_name: String?
    var rate_key: String?
    var group_code: String?
    var room_code: String?
    
    var room_token: String?
    var room_token_key: String?
    
    
    var currency = "USD"
    var room_price: Float = 0.0
    var tax_price: Float = 0.0
    var cancel_free: String?
    var cancel_policy: String?
    
    var is_refundable = false
    var amenities_array: [String] = []
    var room_info: [String: Any] = [:]
    var lastCancellationDate: String? = ""
    // Initialization...
    init(info: [String: Any]) {
        
        self.room_id = ""
        self.room_name = ""
        self.rate_key = ""
        self.group_code = ""
        self.room_code = ""
        
        self.cancel_free = ""
        self.cancel_policy = ""
        
        self.room_token = ""
        self.room_token_key = ""
        
        // room info...
        room_info = info
        if let roomId = info["RoomUniqueId"] as? String {
            room_id = roomId
        }
        if let roomName = info["RoomTypeName"] as? String {
            room_name = roomName
        }
        if let rateKey = info["Rate_key"] as? String {
            rate_key = rateKey
        }
        if let groupCode = info["group_code"] as? String {
            group_code = groupCode
        }
        if let roomCode = info["room_code"] as? String {
            room_code = roomCode
        }
        
        if info["RoomPrice"]  != nil {
            
            // price...
            room_price = Float(String.init(describing: info["RoomPrice"]!))!
        }
        
        if let roomCurrency = info["Currency"] as? String {
            currency = roomCurrency
        }

        // cancellation...
        
        if let cancelPolicy = info["CancellationPolicy"] as? String {
            cancel_policy = cancelPolicy
        }
        
        if let cancel_dict = info["cancellation"] as? [String: Any] {
            
            if let cancelFree = cancel_dict["free"] as? String {
                cancel_free = cancelFree
            }
            if let cancelPolicy = cancel_dict["policy"] as? String {
                cancel_policy = cancelPolicy
            }
        }
        
        // amenities...
        if let amenitArray = info["Amenities"] as? [String] {
            amenities_array = amenitArray
        }
        
        // token...
        if let token_dict = info["custom"] as? [String: Any] {
            if let token = token_dict["token"] as? String {
                self.room_token = token
            }
            
            if let token_key = token_dict["token_key"] as? String {
                self.room_token_key = token_key
            }
        }
        if let refund = info["LastCancellationDate"] as? String {
            if refund.isEmpty == true {
                self.is_refundable = false
            }else {
                self.is_refundable = true
                let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: refund)
                self.lastCancellationDate = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: arrDate)

            }
//            is_refundable = refund == "" ? false : true
            
        }
    }
}



