//
//  ActivitiesTypeModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 26/08/21.
//

import UIKit

struct ActivitiesTypeModel {
    var category_id:Int? = 0
    var category_name: String? = ""
    var isSelected: Bool? = false
    
    
    init(dict: [String: Any]) {
        if let obj = dict["category_name"] as? String{
            category_name = obj
        }
        if let obj = dict["category_id"] as? Int{
            category_id = obj
        }
    }
}
