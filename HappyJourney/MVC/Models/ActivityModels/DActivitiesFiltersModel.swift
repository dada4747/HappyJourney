//
//  DActivitiesFiltersModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 06/08/21.
//

import UIKit

struct DActivitiesFiltersModel {
    static var lowest_Price: Bool? = false
    static var highest_Price: Bool? = false
    
    static var lowest_Star: Bool? = false
    static var highest_Star: Bool? = false
    
    static var lowest_Name: Bool? = false
    static var highest_Name: Bool? = false
    ///New
    static var txt_Name: String? = ""
    static var btn_Offer: Bool? = false
    init() {
        
    }
    static func resetFilters() {
        lowest_Price = false
        highest_Price = false
       
        lowest_Star = false
        highest_Star = false
        
        lowest_Name = false
        highest_Name = false
        
        txt_Name = ""
        btn_Offer = false
    }
}
