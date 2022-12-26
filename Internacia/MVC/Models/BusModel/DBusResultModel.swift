//
//  DBusResultModel.swift
//  Internacia
//
//  Created by Admin on 20/11/22.
//

import Foundation
struct DBusResultModel {
    static var busSeatAttributDetails : [String : Any] = [:]
    static var bus_Selected_Seats_list : [Value] = []
    static var bus_final_total_price : Float = 0.0
    static var bus_discount : Float = 0.0
    static var selected_dropOff : Dropoff = Dropoff(details: [:])
    static var selected_boarding : Pickup = Pickup(details: [:])
    static var selectedBus : DBusesSearchItem?
    static var convenienceFee : Float = 0.0
    static var gst : Float = 0.0
    
}
