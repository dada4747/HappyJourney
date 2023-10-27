//
//  VisaCountryModel.swift
//  ExtactTravel
//
//  Created by Admin on 19/08/22.
//

import Foundation

// MARK: - CountryModel
struct CountryModel {
    static var countryList: [CountryItem] = []
    static func creatCountryList(result: [[String: Any]]) {
        for item in result {
            let i = CountryItem.init(item: item)
            countryList.append(i)
        }
    }
}

// MARK: - CountryList
struct CountryItem {
    var origin: String = ""
    var apiContinentListFk: String = ""
    var name: String = ""
    var countryCode: String = ""
    var isoCountryCode: String = ""
    init() {
    }
    
    init(item: [String: Any]) {
        if let origin = item["origin"] as? String {
            self.origin = origin
        }
        if let apiContinentListFk = item["api_continent_list_fk"] as? String {
            self.apiContinentListFk = apiContinentListFk
        }
        if let name = item["name"] as? String {
            self.name = name
        }
        if let countryCode = item["country_code"] as? String {
            self.countryCode = countryCode
        }
        if let isoCountryCode = item["iso_country_code"] as? String {
            self.isoCountryCode = isoCountryCode
        }
    }
}
