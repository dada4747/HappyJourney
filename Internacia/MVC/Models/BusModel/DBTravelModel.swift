//
//  DBTravelModel.swift
//  Internacia
//
//  Created by Admin on 14/11/22.
//

import Foundation

struct DBTravelModel {
    static var departDate = Date()
    static var sourceCity: [String : String] = [:]
    static var destinationCity: [String: String] = [:]
    static var selectdBus = DBusesSearchItem(details: [:])
//    static var
    static func clearAllTraveller(){
        
    }

}
