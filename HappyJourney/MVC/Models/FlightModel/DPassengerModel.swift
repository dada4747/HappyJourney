//
//  DPassengerModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

struct DPassengerModel {
    
    // static list...
    static var adultArray: [DPassengerItem] = []
    static var childArray: [DPassengerItem] = []
    static var infantArray: [DPassengerItem] = []
    static var email_id = ""
    static var mobile_no = ""
    static var country_code:[String: String] = [:]
}

// MARK:- DPassengerItem
struct DPassengerItem {
    
    // variables...
    var person_id: String?
    var gender_value: String?
    var title_value: String?
    var person_type: String = "Adult"
    var isSelected = false
    
    var title_name: String?
    var first_name: String?
    var last_name: String?
    
    var email_id: String?
    var dateOf_birth: String?
    var ff_number: String?
    
    var passport_no: String?
    var passport_expiry: String?
    var issued_country: String?
    var issued_country_code: String?
    
    init() {
    }
}




