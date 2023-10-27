//
//  DHPreBookingModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// MARK:- DHPreBookingModel
struct DHPreBookingModel {
    
    // static info...
    static var hotelName = ""
    static var hotelImage = ""
    static var hotelCode = ""
    static var hotelAddress = ""
    static var roomType = ""
    static var search_id = ""
    static var cancellationDate = ""
    static var preBookingItem: DHPreBookingStore?
    
    init() {
    }
    
    // clear all information...
    static func clearAll_Information() {

        // clear final break up...
        FinalBreakupHotelModel.currency = "USD"
        FinalBreakupHotelModel.currencySymbol = "$"
        FinalBreakupHotelModel.convenienceFare = 0.0
        FinalBreakupHotelModel.discount = 0.0
        FinalBreakupHotelModel.totalTax = 0.0
        FinalBreakupHotelModel.totalFare = 0.0
    }
    
    // information adding...
    static func createRoomBlockModel(dataDict: [String: Any]) {
        
        // pre booking params...
        if let preBooking_dict = dataDict["pre_booking_params"] as? [String: Any] {
            
            if let hotel_name = preBooking_dict["HotelName"] as? String {
                self.hotelName = hotel_name
            }
            if let hotel_img = preBooking_dict["HotelImage"] as? String {
                self.hotelImage = hotel_img
            }
            if let hotel_code = preBooking_dict["HotelCode"] as? String {
                self.hotelCode = hotel_code
            }
            if let hotel_address = preBooking_dict["HotelAddress"] as? String {
                self.hotelAddress = hotel_address
            }
            if let room_type = preBooking_dict["RoomTypeName"] as? String {
                self.roomType = room_type
            }
            if let cancellationPolicy = preBooking_dict["CancellationPolicy"] as? [[String : Any]] {
                print(cancellationPolicy)
                
                if let cancellationDate = cancellationPolicy[0] as? [String: Any] {
                    if let dates = cancellationDate["FromDate"] as? String {
                        let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: dates)
                        self.cancellationDate = DateFormatter.getDateString(formate: "dd-MMM-yyyy", date: arrDate)

                    }
                }
            }
            if let search_data = dataDict["search_data"] as? [String : Any] {
//                DHTravelModel.adult_count = Int.init(search_data["adult_config"])
//                DHTravelModel.child_count = Int.init(search_data["child_config"])

            }
            
        }
        
        // total fare...
        FinalBreakupHotelModel.addHotelRoomBookingFare(fareItem: dataDict)

        // prebooking store...
        preBookingItem = DHPreBookingStore()
        
        if let token = dataDict["token"] as? String {
            preBookingItem?.token = token
        }
        if let token_key = dataDict["token_key"] as? String {
            preBookingItem?.token_key = token_key
        }
        if let booking_source = dataDict["booking_source"] as? String {
            preBookingItem?.booking_source = booking_source
        }
        if let payOptionArr = dataDict["active_payment_options"] as? [Any] {
            if payOptionArr.count != 0 {
                preBookingItem?.payment_method = payOptionArr[0] as? String ?? ""
            }
        }
    }
}

struct DHPreBookingStore {
    
    // varibales...
    var token: String?
    var token_key: String?
    var payment_method: String? //= "PNHB1"
    var booking_source: String?
    
    init() {
    }
    
}

// MARK:- FinalBreakupModel
struct FinalBreakupHotelModel {
    
    // variable
    static var currency = "USD"
    static var currencySymbol = "$"
    static var totalFare: Float = 0.0
    static var totalTax: Float = 0.0
    static var convenienceFare: Float = 0.0
    static var discount: Float = 0.0
    static var total_amount_val : Float = 0.0
    static var gst : Float = 0.0
    // information adding...
    static func addHotelRoomBookingFare(fareItem: [String: Any]) {
        
        self.convenienceFare = self.convenienceFare + Float(String.init(describing: fareItem["convenience_fees"]!))!
        self.totalTax = self.totalTax + Float(String.init(describing: fareItem["tax_service_sum"]!))!
        self.totalFare = self.totalFare + Float(String.init(describing: fareItem["total_price"]!))!
                
        
        if let currency_str = fareItem["Currency"] as? String {
            self.currency = currency_str
        }
        if let currencySym = fareItem["CurrencySymbol"] as? String {
            self.currencySymbol = currencySym
        }
        if let pre = fareItem["pre_booking_params"] as? [String : Any] {
            if let markup_price_summary = pre["markup_price_summary"] as? [String: Any] {
                self.gst = Float(String.init(describing: markup_price_summary["_GST"]!))!
            }
        }
        
    }
}

