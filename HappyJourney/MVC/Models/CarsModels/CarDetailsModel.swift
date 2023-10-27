//
//  CarDetailsModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 13/07/21.
//

import UIKit

struct CarDetailsModel {

    var active_booking_source: String?
    var token: String?
    var token_m: String?
    var token_key: String?
    var token_m_key: String?
    
    var carRules: CarRulesModel?
    init(dict: [String: Any]) {

        if let obj = dict["active_booking_source"] as? String{
            active_booking_source = obj
        }
        if let obj = dict["token"] as? String{
            token = obj
        }
        if let obj = dict["token_m"] as? String{
            token_m = obj
        }
        if let obj = dict["token_key"] as? String{
            token_key = obj
        }
        if let obj = dict["token_m_key"] as? String{
            token_m_key = obj
        }
        
        if let car_rules = dict["car_rules"] as? [String: Any] {
            if let rateRule = car_rules["RateRule"] as? [String: Any]{
                
                if let obj = rateRule["CarRuleResult"] as? [[String: Any]], obj.count > 0{
                   carRules = CarRulesModel(dict: obj[0])
                }
            }
        }
        
    }
    
    
}
struct CarRulesModel {
    var PickUpDateTime: String?
    var ReturnDateTime: String?
    var ResultToken: String?
//    var CompanyShortName: String?
//    var TravelSector: String?
//    var AirConditionInd: String?
//    var TransmissionType: String?
//    var FuelType: String?
    var PassengerQuantity: Int?
//    var BaggageQuantity: String?
//    var VendorCarType: String?
//    var VehicleCategoryName: String?
//    var Name: String?
//    var PictureURL: String?
//    var Unlimited: String?
//    var DistUnitName: String?
//    var RateComments: String?
    var LocationDetails: LocationDetails_Model?
    var PricedEquip: [PricedEquip_Model] = [PricedEquip_Model]()
    var TotalCharge: TotalCharge_Model?

    init(dict: [String: Any]) {
        if let obj = dict["PickUpDateTime"] as? String{
            PickUpDateTime = obj
        }
        if let obj = dict["ReturnDateTime"] as? String{
            ReturnDateTime = obj
        }
        if let obj = dict["ResultToken"] as? String{
            ResultToken = obj
        }
        if let obj = dict["PassengerQuantity"] as? String{
            PassengerQuantity = Int(obj)
        }
        
        if let obj = dict["LocationDetails"] as? [String: Any]{
            LocationDetails = LocationDetails_Model(dict: obj)
        }
        if let obj = dict["PricedEquip"] as? [[String: Any]]{
            for (index, item) in obj.enumerated(){
                let obj = PricedEquip_Model(dict: item)
                self.PricedEquip.append(obj)
            }
        }
        if let obj = dict["TotalCharge"] as? [String: Any]{
            TotalCharge = TotalCharge_Model(dict: obj)
        }
       
    }
}
struct LocationDetails_Model {
    var PickUpLocation: PickUpLocation_Model?
    var DropLocation: DropLocation_Model?
    init(dict: [String: Any]) {
        if let obj = dict["PickUpLocation"] as? [String:Any]{
            PickUpLocation = PickUpLocation_Model(dict: obj)
        }
        if let obj = dict["DropLocation"] as? [String:Any]{
            DropLocation = DropLocation_Model(dict: obj)
        }
    }
}

struct PickUpLocation_Model {
    var Telephone: String?
    var Address: Address_Model?
    var AdditionalInfo: AdditionalInfo_Model?
    
    var value: value_Model?
    var OpeningHours: [OpeningHours_Model] = [OpeningHours_Model]()

    init(dict: [String: Any]) {
        if let obj = dict["Telephone"] as? String{
            Telephone = obj
        }
        if let obj = dict["Address"] as? [String: Any]{
            Address = Address_Model(dict: obj)
        }
        if let obj = dict["value"] as? [String: Any]{
            value = value_Model(dict: obj)
        }
        if let obj = dict["AdditionalInfo"] as? [String: Any]{
            AdditionalInfo = AdditionalInfo_Model(dict: obj)
        }
        if let obj = dict["AdditionalInfo"] as? [String: Any]{
            if let obj1 = obj["OpeningHours"] as? [[String: Any]] {
                for (index, item) in obj1.enumerated(){
                    let obj = OpeningHours_Model(dict: item)
                    self.OpeningHours.append(obj)
                }
            }
        }
        
    }
    
}
struct DropLocation_Model {
    var Telephone: String?
    var Address: Address_Model?
    var AdditionalInfo: AdditionalInfo_Model?
    
    var value: value_Model?
    var OpeningHours: [OpeningHours_Model] = [OpeningHours_Model]()
    
    init(dict: [String: Any]) {
        if let obj = dict["Telephone"] as? String{
            Telephone = obj
        }
        if let obj = dict["Address"] as? [String: Any]{
            Address = Address_Model(dict: obj)
        }
        if let obj = dict["value"] as? [String: Any]{
            value = value_Model(dict: obj)
        }
        if let obj = dict["AdditionalInfo"] as? [String: Any]{
            AdditionalInfo = AdditionalInfo_Model(dict: obj)
        }
        if let obj = dict["AdditionalInfo"] as? [String: Any]{
            if let obj1 = obj["OpeningHours"] as? [[String: Any]] {
                for (index, item) in obj1.enumerated(){
                    let obj = OpeningHours_Model(dict: item)
                    self.OpeningHours.append(obj)
                }
            }
        }
    }
}

struct Address_Model {
    var StreetNmbr: String?
    var CityName: String?
    var PostalCode: String?
    var CountryName: String?

    
    init(dict: [String: Any]) {
        if let obj = dict["StreetNmbr"] as? String{
            StreetNmbr = obj
        }
        if let obj = dict["CityName"] as? String{
            CityName = obj
        }
        if let obj = dict["PostalCode"] as? String{
            PostalCode = obj
        }
        if let obj = dict["CountryName"] as? String{
            CountryName = obj
        }
    }
}

struct value_Model {
    var Name: String?
    var Code: String?
    init(dict: [String: Any]) {
        if let obj = dict["Name"] as? String{
            Name = obj
        }
        if let obj = dict["Code"] as? String{
            Code = obj
        }
    }
}
struct AdditionalInfo_Model {
    var ParkLocation: String?
    init(dict: [String: Any]) {
        if let obj = dict["ParkLocation"] as? String{
            ParkLocation = obj
        }
    }
}

struct OpeningHours_Model {
    var Day: String?
    var Start: String?
    var End: String?
    
    init(dict: [String: Any]) {
        if let obj = dict["Day"] as? String{
            Day = obj
        }
        if let obj = dict["Start"] as? String{
            Start = obj
        }
        if let obj = dict["End"] as? String{
            End = obj
        }
    }
}

struct PricedEquip_Model {
    var Description: String?
    var EquipType: String?
    var CurrencyCode: String?
    var name: String?
    var Amount: Double?
    var isSelected: Bool?
    var seatCount : Int?
    var policy_description: policy_description_Model?
    
    
    
    init(dict: [String: Any]) {
        isSelected = false
        seatCount = 0
        
        if let obj = dict["Description"] as? String{
            Description = obj
        }
        if let obj = dict["EquipType"] as? String{
            EquipType = obj
        }
        if let obj = dict["CurrencyCode"] as? String{
            CurrencyCode = obj
        }
        if let obj = dict["name"] as? String{
            name = obj
        }
        if let obj = dict["Amount"] as? String{
            Amount = Double(obj)
        }
        if let obj = dict["Amount"] as? Double{
            Amount = obj
        }
        if let obj = dict["policy_description"] as? [String: Any]{
            policy_description = policy_description_Model(dict: obj)
        }
    }
    
}
struct policy_description_Model {
    var PolicyName: String?
    var Description: String?
    var InclusionsList:[InclusionsList_Model] = [InclusionsList_Model]()
    
    init(dict: [String: Any]) {
        if let obj = dict["PolicyName"] as? String{
            PolicyName = obj
        }
        if let obj = dict["Description"] as? String{
            Description = obj
        }
        if let obj = dict["InclusionsList"] as? [[String:Any]]{
            for (index, item) in obj.enumerated(){
                let obj = InclusionsList_Model(dict: item)
                self.InclusionsList.append(obj)
            }
        }
    }
}

struct InclusionsList_Model {
    var Title: String?
    var Content: String?
    var isExpanded = false
    
    init(dict: [String: Any]) {
        if let obj = dict["Title"] as? String{
            Title = obj
        }
        if let obj = dict["Content"] as? String{
            Content = obj
        }
    }
}

struct TotalCharge_Model {
    var Pay_now: Double?
    var EstimatedTotalAmount: Double?
    var Pricebreakup: Pricebreakup_Model?
    init(dict: [String: Any]) {
        if let obj = dict["Pay_now"] as? Double{
            Pay_now = obj
        }
        if let obj = dict["EstimatedTotalAmount"] as? Double{
            EstimatedTotalAmount = obj
        }
        if let obj = dict["Pricebreakup"] as? [String: Any]{
            Pricebreakup = Pricebreakup_Model(dict: obj)
        }
    }
}
struct Pricebreakup_Model {
    var RentalPrice: Double?
    var OtherTaxes: Double?
    init(dict: [String: Any]) {
        if let obj = dict["RentalPrice"] as? Double{
            RentalPrice = obj
        }
        if let obj = dict["OtherTaxes"] as? Double{
            OtherTaxes = obj
        }
    }
}
