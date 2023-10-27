//
//  CarFiltersModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 19/07/21.
//

import UIKit

//struct CarFiltersModel {
//    var suppliersArray: [Car_SuppliersModel] = [Car_SuppliersModel]()
//
//    init(dict: [String: Any]) {
//
//    }
//
//}
//struct Car_PriceRangeModel {
//
//}

struct Car_FiltersModel {
    var name: String?
    var isSelected: Bool?
    init(dict: [String: Any]) {
        if let obj = dict["name"] as? String{
            name = obj
        }
        if let obj = dict["isSelected"] as? Bool{
            isSelected = obj
        }
    }
    
}

