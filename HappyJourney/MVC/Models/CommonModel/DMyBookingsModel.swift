//
//  DMyBookingsModel.swift
//  CheapToGo
//
//  Created by Anand S on 30/11/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit


// MARK:- DHolidaySearchModel
struct DFlightHistoryModel {
    
    //static info...
    static var packageId = ""
    
    static var flightHistory_Array: [DFlightHistoryItem] = []
    static var hotelHistory_Array: [DHotelHistoryItem] = []
    static var carHistory_Array: [DCarHistoryItem] = []
    static var transferHistory_Array: [DTransferHistoryItem] = []
    static var activitiesHistory_Array: [DActivitiesHistoryItem] = []
    static var busHistory_Array: [DBusHistoryItem] = []

    
    init() {
    }
    
    // clear all search information...
    static func clearAll_HistoryInformation() {
        
        // remove all array...
        flightHistory_Array.removeAll()
        hotelHistory_Array.removeAll()
        carHistory_Array.removeAll()
        transferHistory_Array.removeAll()
        activitiesHistory_Array.removeAll()
        busHistory_Array.removeAll()

    }
    
    // funcations...
    static func createFlightMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DFlightHistoryItem.init(details: itemObj)
            self.flightHistory_Array.append(models)
        }
    }
    
    static func createHotelMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DHotelHistoryItem.init(details: itemObj)
            self.hotelHistory_Array.append(models)
        }
    }
    static func createCarMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DCarHistoryItem.init(details: itemObj)
            self.carHistory_Array.append(models)
        }
    }
    static func createTransferMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DTransferHistoryItem.init(details: itemObj)
            self.transferHistory_Array.append(models)
        }
    }
    static func createActivitiesMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DActivitiesHistoryItem.init(details: itemObj)
            self.activitiesHistory_Array.append(models)
        }
    }
    static func createBusesMyBookingsModels(result_array: [[String: Any]]) {
        
        clearAll_HistoryInformation()
        
        for itemObj in result_array {
            let models = DBusHistoryItem.init(details: itemObj)
            self.busHistory_Array.append(models)
        }
    }
}

// MARK:- DFlightHistoryItem
struct DFlightHistoryItem {
    
    // elements...
    var booking_id: String?
    var depart_city: String?
    var depart_time: String?
    var arrival_city: String?
    var arrival_time: String?
    var tripType: String?
    var booking_status: String?
    var journeyDate: String?
    var bookingDate: String?

    var currency_code: String?
    var currency_symbol: String?

    var flight_price: Float = 0.0
    
    var booking_source: String?
    var trans_id: String?
    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.depart_city = ""
        self.arrival_city = ""
        self.tripType = ""
        self.currency_code = "USD"
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
        if let app_reference = details["trans_id"] as? String {
            self.trans_id = app_reference
        }
        if let app_reference = details["currency"] as? String {
            self.currency_code = app_reference
        }
        if let app_reference = details["CurrencySymbol"] as? String {
            self.currency_symbol = app_reference
        }
        if let journey_from = details["journey_from"] as? String {
            self.depart_city = journey_from
        }
        if let journey_to = details["journey_to"] as? String {
            self.arrival_city = journey_to
        }
        if let trip_type = details["trip_type"] as? String {
            self.tripType = trip_type
        }
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        if let journey_start = details["journey_start"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.journeyDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
            
            self.depart_time = DateFormatter.getDateString(formate: "HH:mm", date: originDate)
        }
        
        if let journey_end = details["journey_end"] as? String {
             
             let arrivalDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_end)
             self.journeyDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrivalDate)
            
            self.arrival_time = DateFormatter.getDateString(formate: "HH:mm", date: arrivalDate)
         }
        
        self.flight_price = Float(String.init(describing: details["total_fare"]!)) ?? 0.0
    }
    
}


// MARK:- DFlightHistoryItem
struct DHotelHistoryItem {
    
    // elements...
    var booking_id: String?
    var hotel_name: String?
    var hotel_check_in: String?
    var hotel_check_out: String?
    
    var booking_status: String?
    var bookingDate: String?
    var currency: String?
    var total_fare: Float = 0.0
    var booking_source: String?
    
    var attributes: String?
    var address: String?
    var hotelImg: String?

    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.hotel_name = ""
        self.hotel_check_in = ""
        self.hotel_check_out = ""
        self.booking_status = ""
        self.bookingDate = ""
        
        self.currency = "USD"
        self.booking_source = ""
        
        self.attributes = ""
        self.address = ""
        self.hotelImg = ""
        
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        if let app_reference = details["hotel_name"] as? String {
            self.hotel_name = app_reference
        }
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
    
        if let app_reference = details["currency"] as? String {
            self.currency = app_reference
        }
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        if let journey_start = details["hotel_check_in"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_start)
            self.hotel_check_in = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        if let journey_end = details["hotel_check_out"] as? String {
            
            let arrivalDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_end)
            self.hotel_check_out = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrivalDate)
        }
        if let amount = details["total_fare"] as? Float {
            self.total_fare = amount
        }
        
        if let att = details["attributes"] as? String{
            self.attributes = att
            let attributesData: [String: Any] = att.parseJSONString ?? [:]
            self.address = attributesData["HotelAddress"] as? String
            self.hotelImg = attributesData["HotelImage"] as? String
        }
        
    }
    
}

// MARK: - DCarHistoryItem
struct DCarHistoryItem {
    // elements...
    var booking_id: String?
    var car_name: String?
    var car_from_Date: String?
    var car_from_Time: String?
    
    var car_to_Date: String?
    var car_to_Time: String?

    var pickup_Loc: String?
    var drop_Loc: String?

    var booking_status: String?
    var bookingDate: String?
    var currency: String?
    var total_fare: String?
    var booking_source: String?
    
    var attributes: String?
    var address: String?
    var carImg: String?
    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.car_name = ""
        self.car_from_Date = ""
        self.car_from_Time = ""
        
        self.car_to_Date = ""
        self.car_to_Time = ""
        
        self.booking_status = ""
        self.bookingDate = ""
        
        self.currency = "USD"
        self.booking_source = ""
        
        self.attributes = ""
        self.address = ""
        self.carImg = ""
        self.total_fare = ""
        
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        
        if let app_reference = details["hotel_name"] as? String {
            self.car_name = app_reference
        }
        
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
    
        if let app_reference = details["currency"] as? String {
            self.currency = app_reference
        }
        
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        if let journey_start = details["car_from_date"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_start)
            self.car_from_Date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
        
        if let journey_start = details["pickup_time"] as? String {
            self.car_from_Time = journey_start
        }
        
        if let journey_end = details["car_to_date"] as? String {
            
            let arrivalDate = DateFormatter.getDate(formate: "yyyy-MM-dd", date: journey_end)
            self.car_to_Date = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrivalDate)
        }
        
        
        if let journey_end = details["drop_time"] as? String {
            self.car_to_Time = journey_end
        }
        
        
        if let amount = details["total_fare"] as? String {
            self.total_fare = amount
        }
        if let amount = details["car_pickup_lcation"] as? String {
            self.pickup_Loc = amount
        }
        if let amount = details["car_drop_location"] as? String {
            self.drop_Loc = amount
        }
        
        
        
        
    }
}
// MARK:- DTransferHistoryItem
struct DTransferHistoryItem {
    // elements...
    var booking_id: String?
    var product_name: String?

    var booking_status: String?
    var bookingDate: String?
    var currency: String?
    var total_fare: String?
    var booking_source: String?
    
    var attributes: String?
    var address: String?
    var carImg: String?
    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.product_name = ""
        self.booking_status = ""
        self.bookingDate = ""
        
        self.currency = "USD"
        self.booking_source = ""
        
        self.attributes = ""
        self.address = ""
        self.carImg = ""
        self.total_fare = ""
        
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        
        if let app_reference = details["product_name"] as? String {
            self.product_name = app_reference
        }
        
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
    
        if let app_reference = details["currency"] as? String {
            self.currency = app_reference
        }
        
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
                
        if let amount = details["total_fare"] as? String {
            self.total_fare = amount
        }
        
        
        
    }
}

// MARK:- DActivitiesHistoryItem
struct DActivitiesHistoryItem {
    // elements...
    var booking_id: String?
    var product_name: String?

    var booking_status: String?
    var bookingDate: String?
    var currency: String?
    var total_fare: String?
    var booking_source: String?
    
    var attributes: String?
    var address: String?
    var carImg: String?
    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.product_name = ""
        self.booking_status = ""
        self.bookingDate = ""
        
        self.currency = "USD"
        self.booking_source = ""
        
        self.attributes = ""
        self.address = ""
        self.carImg = ""
        self.total_fare = ""
        
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        
        if let app_reference = details["product_name"] as? String {
            self.product_name = app_reference
        }
        
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
    
        if let app_reference = details["currency"] as? String {
            self.currency = app_reference
        }
        
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
                
        if let amount = details["total_fare"] as? String {
            self.total_fare = amount
        }
        
        
        
    }
}

// MARK:- DHolidaysHistoryItem
struct DHolidaysHistoryItem {
    var holiday_bookingObj: Holiday_bookingObj?
    var holiday_tourObj: Holiday_tourObj?
    
    init(details: [String: Any]) {
        
        if let obj = details["booking_details"] as? [String: Any] {
            holiday_bookingObj = Holiday_bookingObj(details: obj)
        }
        if let obj = details["tours_details"] as? [String: Any] {
            holiday_tourObj = Holiday_tourObj(details: obj)
        }
    }
    
}
struct Holiday_bookingObj {
    // elements...
    var booking_id: String?
    var product_name: String?

    var booking_status: String?
    var bookingDate: String?
    var currency: String?
    var total_fare: String?
    var booking_source: String?
    
    var attributes: String?
    var address: String?
    var carImg: String?
    
    init(details: [String: Any]) {
        
        // default info...
        self.booking_id = ""
        self.product_name = ""
        self.booking_status = ""
        self.bookingDate = ""
        
        self.currency = "USD"
        self.booking_source = "PTBSID0000000008"
        
        self.attributes = ""
        self.address = ""
        self.carImg = ""
        self.total_fare = ""
        
        
        // holiday details...
        if let app_reference = details["app_reference"] as? String {
            self.booking_id = app_reference
        }
        
        if let app_reference = details["product_name"] as? String {
            self.product_name = app_reference
        }
        
        if let app_reference = details["booking_source"] as? String {
            self.booking_source = app_reference
        }
    
        if let app_reference = details["currency"] as? String {
            self.currency = app_reference
        }
        
        if let status = details["status"] as? String {
            self.booking_status = status
        }
        
        if let journey_start = details["created_datetime"] as? String {
            
            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
        }
                
        if let amount = details["basic_fare"] as? String {
            self.total_fare = amount
        }
        
        
        
    }
}
struct Holiday_tourObj {
    var package_id: String?
    var package_name: String?
    var duration: String?
    init(details: [String: Any]) {
        
        if let amount = details["package_id"] as? String {
            self.package_id = amount
        }
        if let amount = details["package_name"] as? String {
            self.package_name = amount
        }
        if let amount = details["duration"] as? String {
            self.duration = amount
        }
    }

}
