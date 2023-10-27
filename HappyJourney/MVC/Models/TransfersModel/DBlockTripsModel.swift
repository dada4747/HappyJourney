//
//  DBlockTripsModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 03/08/21.
//

import UIKit

struct DBlockTripsModel {
    static var search_id: String? = ""
    static var token: String? = ""
    static var token_key: String? = ""
    static var total_price: Double? = 0.0
    static var convenience_fees: Double? = 0.0
    static var booking_source: String? = ""
    static var module_value: String? = ""
    static var pre_booking_params: TransferPreBookingModel?

    init() {
        
    }
    
    static func createModels(result_dict:[String: Any]) {
        if let pro_name = result_dict["search_id"] as? String {
            self.search_id = pro_name
        }
        if let pro_name = result_dict["token"] as? String {
            self.token = pro_name
        }
        if let pro_name = result_dict["token_key"] as? String {
            self.token_key = pro_name
        }
        if let pro_name = result_dict["total_price"] as? Double {
            self.total_price = pro_name
        }
        if let pro_name = result_dict["convenience_fees"] as? Double {
            self.convenience_fees = pro_name
        }
        if let pro_name = result_dict["booking_source"] as? String {
            self.booking_source = pro_name
        }
        if let pro_name = result_dict["module_value"] as? String {
            self.module_value = pro_name
        }
        if let pro_name = result_dict["pre_booking_params"] as? [String:Any] {
            self.pre_booking_params = TransferPreBookingModel(result_dict: pro_name)
        }
        
        
    }
}
struct TransferPreBookingModel {
    var ProductName: String? = ""
    var BlockTourId: String? = ""
    var grade_code: String? = ""
    var booking_date: String? = ""
    var product_code: String? = ""
    var grade_title: String? = ""
    
    var TM_LastCancellation_date: String? = ""
    var taxes: Double = 0.0
    var HotelPickup: Bool? = false
    var ProductImage: String? = ""
    var StarRating: Int? = 0
    var tour_uniq_id: String? = ""
    var hotelsList: [DHotelsListModel] = []
    var bookingQuestionsList: [BookingQuestions] = []

    var priceObj: PriceSummery?
    
    init(result_dict: [String: Any]) {
        
        if let pro_name = result_dict["ProductName"] as? String {
            self.ProductName = pro_name
        }
        if let pro_name = result_dict["product_code"] as? String {
            self.product_code = pro_name
        }
        if let pro_name = result_dict["grade_title"] as? String {
            self.grade_title = pro_name
        }
        
        if let pro_name = result_dict["BlockTourId"] as? String {
            self.BlockTourId = pro_name
        }
        if let pro_name = result_dict["grade_code"] as? String {
            self.grade_code = pro_name
        }
        if let pro_name = result_dict["booking_date"] as? String {
            self.booking_date = pro_name
        }
        if let pro_name = result_dict["TM_LastCancellation_date"] as? String {
            self.TM_LastCancellation_date = pro_name
        }
        if let pro_name = result_dict["tax_service_sum"] as? Double {
            self.taxes = pro_name
        }
        if let pro_name = result_dict["HotelPickup"] as? Bool {
            self.HotelPickup = pro_name
        }
        if let pro_name = result_dict["ProductImage"] as? String {
            self.ProductImage = pro_name
        }
        if let pro_name = result_dict["StarRating"] as? Int {
            self.StarRating = pro_name
        }
        if let pro_name = result_dict["tour_uniq_id"] as? String {
            self.tour_uniq_id = pro_name
        }
//        hotelsList.removeAll()
        if let arr = result_dict["HotelList"] as? [[String:Any]] {
            for item in arr{
                let obj = DHotelsListModel(result_dict: item)
                hotelsList.append(obj)
            }
        }
        if let pro_name = result_dict["Price"] as? [String:Any] {
            self.priceObj = PriceSummery(result_dict: pro_name)
        }
        if let arr = result_dict["BookingQuestions"] as? [[String:Any]] {
            for item in arr{
                let obj = BookingQuestions(result_dict: item)
                bookingQuestionsList.append(obj)
            }
        }
    }
    
}

struct DHotelsListModel {
    var hotel_name: String? = ""
    var hotel_id: String? = ""
    var city: String? = ""
    var address: String? = ""
    
    init(result_dict: [String: Any]) {
        
        if let pro_name = result_dict["hotel_name"] as? String {
            self.hotel_name = pro_name
        }
        if let pro_name = result_dict["hotel_id"] as? String {
            self.hotel_id = pro_name
        }
        if let pro_name = result_dict["city"] as? String {
            self.city = pro_name
        }
        if let pro_name = result_dict["address"] as? String {
            self.address = pro_name
        }
    }
}
struct PriceSummery {
    var TotalDisplayFare: Double? = 0.0
    init(result_dict: [String: Any]) {
        
        if let pro_name = result_dict["TotalDisplayFare"] as? Double {
            self.TotalDisplayFare = pro_name
        }
    }
}
struct BookingQuestions {
    var title: String? = ""
    var questionId: Int? = 0
    var message: String? = ""
    var answerEntered: String? = "Test"

    init(result_dict: [String: Any]) {
        
        if let pro_name = result_dict["title"] as? String {
            self.title = pro_name
        }
        if let pro_name = result_dict["questionId"] as? Int {
            self.questionId = pro_name
        }
        if let pro_name = result_dict["message"] as? String {
            self.message = pro_name
        }
    }
}
