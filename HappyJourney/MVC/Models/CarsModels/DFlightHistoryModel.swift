////
////  File.swift
////  HappyJourney
////
////  Created by Admin on 29/05/23.
////
//
//import Foundation
//
//import UIKit
//
//
//// MARK:- DHolidaySearchModel
//struct DFlightHistoryModel {
//    
//    //static info...
//    static var packageId = ""
//    
//    static var flightHistory_Array: [DFlightHistoryItem] = []
//    static var hotelHistory_Array: [DHotelHistoryItem] = []
//    static var carHistory_Array: [DCarHistoryItem] = []
//    static var activitiesHistory_Array: [DActivitiesHistoryItem] = []
//    static var holidaysHistory_Array: [DHolidaysHistoryItem] = []
//
//    
//    init() {
//    }
//    
//    // clear all search information...
//    static func clearAll_HistoryInformation() {
//        
//        // remove all array...
//        flightHistory_Array.removeAll()
//        hotelHistory_Array.removeAll()
//        carHistory_Array.removeAll()
//        activitiesHistory_Array.removeAll()
//        holidaysHistory_Array.removeAll()
//
//    }
//    
//    // funcations...
//    static func createFlightMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DFlightHistoryItem.init(details: itemObj)
//            self.flightHistory_Array.append(models)
//        }
//    }
//    
//    static func createHotelMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DHotelHistoryItem.init(details: itemObj)
//            self.hotelHistory_Array.append(models)
//        }
//    }
//    static func createCarMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DCarHistoryItem.init(details: itemObj)
//            self.carHistory_Array.append(models)
//        }
//    }
//    static func createTransferMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DTransferHistoryItem.init(details: itemObj)
//            self.transferHistory_Array.append(models)
//        }
//    }
//    static func createActivitiesMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DActivitiesHistoryItem.init(details: itemObj)
//            self.activitiesHistory_Array.append(models)
//        }
//    }
//    static func createHolidayssMyBookingsModels(result_array: [[String: Any]]) {
//        
//        clearAll_HistoryInformation()
//        
//        for itemObj in result_array {
//            let models = DHolidaysHistoryItem.init(details: itemObj)
//            self.holidaysHistory_Array.append(models)
//        }
//    }
//}
//
//// MARK:- DTransferHistoryItem
//struct DTransferHistoryItem {
//    // elements...
//    var booking_id: String?
//    var product_name: String?
//
//    var booking_status: String?
//    var bookingDate: String?
//    var currency: String?
//    var total_fare: String?
//    var booking_source: String?
//    
//    var attributes: String?
//    var address: String?
//    var carImg: String?
//    
//    init(details: [String: Any]) {
//        
//        // default info...
//        self.booking_id = ""
//        self.product_name = ""
//        self.booking_status = ""
//        self.bookingDate = ""
//        
//        self.currency = "USD"
//        self.booking_source = ""
//        
//        self.attributes = ""
//        self.address = ""
//        self.carImg = ""
//        self.total_fare = ""
//        
//        
//        // holiday details...
//        if let app_reference = details["app_reference"] as? String {
//            self.booking_id = app_reference
//        }
//        
//        if let app_reference = details["product_name"] as? String {
//            self.product_name = app_reference
//        }
//        
//        if let app_reference = details["booking_source"] as? String {
//            self.booking_source = app_reference
//        }
//    
//        if let app_reference = details["currency"] as? String {
//            self.currency = app_reference
//        }
//        
//        if let status = details["status"] as? String {
//            self.booking_status = status
//        }
//        
//        if let journey_start = details["created_datetime"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
//            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//        }
//                
//        if let amount = details["total_fare"] as? String {
//            self.total_fare = amount
//        }
//        
//        
//        
//    }
//}
//
//// MARK:- DActivitiesHistoryItem
//struct DActivitiesHistoryItem {
//    // elements...
//    var booking_id: String?
//    var product_name: String?
//
//    var booking_status: String?
//    var bookingDate: String?
//    var currency: String?
//    var total_fare: String?
//    var booking_source: String?
//    
//    var attributes: String?
//    var address: String?
//    var carImg: String?
//    
//    init(details: [String: Any]) {
//        
//        // default info...
//        self.booking_id = ""
//        self.product_name = ""
//        self.booking_status = ""
//        self.bookingDate = ""
//        
//        self.currency = "USD"
//        self.booking_source = ""
//        
//        self.attributes = ""
//        self.address = ""
//        self.carImg = ""
//        self.total_fare = ""
//        
//        
//        // holiday details...
//        if let app_reference = details["app_reference"] as? String {
//            self.booking_id = app_reference
//        }
//        
//        if let app_reference = details["product_name"] as? String {
//            self.product_name = app_reference
//        }
//        
//        if let app_reference = details["booking_source"] as? String {
//            self.booking_source = app_reference
//        }
//    
//        if let app_reference = details["currency"] as? String {
//            self.currency = app_reference
//        }
//        
//        if let status = details["status"] as? String {
//            self.booking_status = status
//        }
//        
//        if let journey_start = details["created_datetime"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
//            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//        }
//                
//        if let amount = details["total_fare"] as? String {
//            self.total_fare = amount
//        }
//        
//        
//        
//    }
//}
//
//// MARK:- DHolidaysHistoryItem
//struct DHolidaysHistoryItem {
//    var holiday_bookingObj: Holiday_bookingObj?
//    var holiday_tourObj: Holiday_tourObj?
//    
//    init(details: [String: Any]) {
//        
//        if let obj = details["booking_details"] as? [String: Any] {
//            holiday_bookingObj = Holiday_bookingObj(details: obj)
//        }
//        if let obj = details["tours_details"] as? [String: Any] {
//            holiday_tourObj = Holiday_tourObj(details: obj)
//        }
//    }
//    
//}
//struct Holiday_bookingObj {
//    // elements...
//    var booking_id: String?
//    var product_name: String?
//
//    var booking_status: String?
//    var bookingDate: String?
//    var currency: String?
//    var total_fare: String?
//    var booking_source: String?
//    
//    var attributes: String?
//    var address: String?
//    var carImg: String?
//    
//    init(details: [String: Any]) {
//        
//        // default info...
//        self.booking_id = ""
//        self.product_name = ""
//        self.booking_status = ""
//        self.bookingDate = ""
//        
//        self.currency = "USD"
//        self.booking_source = "PTBSID0000000008"
//        
//        self.attributes = ""
//        self.address = ""
//        self.carImg = ""
//        self.total_fare = ""
//        
//        
//        // holiday details...
//        if let app_reference = details["app_reference"] as? String {
//            self.booking_id = app_reference
//        }
//        
//        if let app_reference = details["product_name"] as? String {
//            self.product_name = app_reference
//        }
//        
//        if let app_reference = details["booking_source"] as? String {
//            self.booking_source = app_reference
//        }
//    
//        if let app_reference = details["currency"] as? String {
//            self.currency = app_reference
//        }
//        
//        if let status = details["status"] as? String {
//            self.booking_status = status
//        }
//        
//        if let journey_start = details["created_datetime"] as? String {
//            
//            let originDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: journey_start)
//            self.bookingDate = DateFormatter.getDateString(formate: "dd MMM yyyy", date: originDate)
//        }
//                
//        if let amount = details["basic_fare"] as? String {
//            self.total_fare = amount
//        }
//        
//        
//        
//    }
//}
//struct Holiday_tourObj {
//    var package_id: String?
//    var package_name: String?
//    var duration: String?
//    init(details: [String: Any]) {
//        
//        if let amount = details["package_id"] as? String {
//            self.package_id = amount
//        }
//        if let amount = details["package_name"] as? String {
//            self.package_name = amount
//        }
//        if let amount = details["duration"] as? String {
//            self.duration = amount
//        }
//    }
//
//}
