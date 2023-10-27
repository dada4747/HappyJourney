//
//  CarSearchMainModel.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 12/07/21.
//

import UIKit

struct CarSearchMainModel {
    
    var search_id: String?
    var booking_source: String?
    var PreferredCurrency: String?
    var CarsList: [CarsListModel] = [CarsListModel]()

    
    
    init(dict: [String: Any]) {
//        if let obj = dict["search_id"] as? Int{
//            search_id = String(obj)
//        }
//        if let obj = dict["booking_source"] as? String{
//            booking_source = obj
//        }
        
        if let obj = dict["CarResults"] as? [[String: Any]] {
            for (index, item) in obj.enumerated(){
                let obj = CarsListModel(dict: item)
                self.CarsList.append(obj)
            }
        }
        
    }
    
    
    
}

struct CarsListModel {
    var PickUpDateTime: String?
    var ReturnDateTime: String?
    var Status: String?
    var AirConditionInd: String?
    var TransmissionType: String?
    var FuelType: String?
    var PassengerQuantity: String?
    var BaggageQuantity: String?
    var VendorCarType: String?
    var VehicleCategoryName: String?
    var DoorCount: String?
    var VehClassSizeName: String?
    var Name: String?
    var PictureURL: String?
    var Unlimited: String?
    var DistUnitName: String?
    var RateComments: String?
    var Vendor: String = ""
    var DropOffLocation: String?
    var ResultToken: String?
    
    var RateRestrictions: RateRestrictions_Model?
    var PaymentRules: PaymentRules_Model?
    var TPA_Extensions: TPA_Extensions_Model?
    
    var PricedCoverage: [PricedCoverage_Model] = [PricedCoverage_Model]()
    var CancellationPolicy: [CancellationPolicy_Model] = [CancellationPolicy_Model]()
    
    var PricedEquip: [PricedEquip_Model] = [PricedEquip_Model]()
    var TotalCharge: TotalCharge_Model?

    var isViewMoreClicked = false
    
    init(dict: [String: Any]) {
        
        if let obj = dict["PickUpDateTime"] as? String{
            PickUpDateTime = obj
        }
        if let obj = dict["ReturnDateTime"] as? String{
            ReturnDateTime = obj
        }
        if let obj = dict["Status"] as? String{
            Status = obj
        }
        if let obj = dict["AirConditionInd"] as? String{
            AirConditionInd = obj
        }
        if let obj = dict["TransmissionType"] as? String{
            TransmissionType = obj
        }
        if let obj = dict["FuelType"] as? String{
            FuelType = obj
        }
        if let obj = dict["PassengerQuantity"] as? String{
            PassengerQuantity = obj
        }
        if let obj = dict["BaggageQuantity"] as? String{
            BaggageQuantity = obj
        }
        if let obj = dict["VendorCarType"] as? String{
            VendorCarType = obj
        }
        if let obj = dict["VehicleCategoryName"] as? String{
            VehicleCategoryName = obj
        }
        if let obj = dict["DoorCount"] as? String{
            DoorCount = obj
        }
        if let obj = dict["VehClassSizeName"] as? String{
            VehClassSizeName = obj
        }
        if let obj = dict["Name"] as? String{
            Name = obj
        }
        if let obj = dict["PictureURL"] as? String{
            PictureURL = obj
        }
        if let obj = dict["Unlimited"] as? String{
            Unlimited = obj
        }
        if let obj = dict["DistUnitName"] as? String{
            DistUnitName = obj
        }
        if let obj = dict["RateComments"] as? String{
            RateComments = obj
        }
        if let obj = dict["Vendor"] as? String{
            Vendor = obj
        }
        if let obj = dict["DropOffLocation"] as? String{
            DropOffLocation = obj
        }
        if let obj = dict["ResultToken"] as? String{
            ResultToken = obj
        }
        if let obj = dict["TotalCharge"] as? [String: Any]{
            TotalCharge = TotalCharge_Model(dict: obj)
        }
        
        if let obj = dict["RateRestrictions"] as? [String: Any]{
            RateRestrictions = RateRestrictions_Model(dict: obj)
        }
        if let obj = dict["PaymentRules"] as? [String: Any]{
            PaymentRules = PaymentRules_Model(dict: obj)
        }
        if let obj = dict["TPA_Extensions"] as? [String: Any]{
            TPA_Extensions = TPA_Extensions_Model(dict: obj)
        }
        
        if let obj = dict["PricedCoverage"] as? [[String: Any]] {
            for (index, item) in obj.enumerated(){
                let obj = PricedCoverage_Model(dict: item)
                self.PricedCoverage.append(obj)
            }
        }
        
        if let obj = dict["CancellationPolicy"] as? [[String: Any]] {
            for (index, item) in obj.enumerated(){
                let obj = CancellationPolicy_Model(dict: item)
                self.CancellationPolicy.append(obj)
            }
        }
        if let obj = dict["TotalCharge"] as? [String: Any]{
            TotalCharge = TotalCharge_Model(dict: obj)
        }

    }
    
    
}

struct RateRestrictions_Model {
    var MinimumAge: String?
    var MaximumAge: String?
    var NoShowFeeInd: String?

    init(dict: [String: Any]) {
        
        if let obj = dict["MinimumAge"] as? String{
            MinimumAge = obj
        }
        if let obj = dict["MaximumAge"] as? String{
            MaximumAge = obj
        }
        if let obj = dict["NoShowFeeInd"] as? String{
            NoShowFeeInd = obj
        }
    }
}

struct PaymentRules_Model {
    var PaymentType: String?
    var PaymentRule: String?
    
    init(dict: [String: Any]) {
        if let obj = dict["PaymentType"] as? String{
            PaymentType = obj
        }
        if let obj = dict["PaymentRule"] as? String{
            PaymentRule = obj
        }
    }
}
struct TPA_Extensions_Model {
    var TermsConditions: String?
    var SupplierLogo: String?

    init(dict: [String: Any]) {
        if let obj = dict["TermsConditions"] as? String{
            TermsConditions = obj
        }
        if let obj = dict["SupplierLogo"] as? String{
            SupplierLogo = obj
        }
    }
}
struct PricedCoverage_Model {
    var Amount: Double?
    var Code: String?
    var CoverageType: String?
    var Currency: String?
    var Desscription: String?
    var IncludedInRate: String?
    
    init(dict: [String: Any]) {
        if let obj = dict["Amount"] as? Double{
            Amount = obj
        }
        if let obj = dict["Code"] as? String{
            Code = obj
        }
        if let obj = dict["CoverageType"] as? String{
            CoverageType = obj
        }
        if let obj = dict["Currency"] as? String{
            Currency = obj
        }
        if let obj = dict["Desscription"] as? String{
            Desscription = obj
        }
        if let obj = dict["IncludedInRate"] as? String{
            IncludedInRate = obj
        }
    }
}
struct CancellationPolicy_Model {
    var Amount: String?
    var CurrencyCode: String?
    var FromDate: String?
    var ToDate: String?
    var _Markup: Double?
    var _Markup_Gst: Double?
    
    init(dict: [String: Any]) {
        if let obj = dict["Amount"] as? String{
            Amount = obj
        }
        if let obj = dict["CurrencyCode"] as? String{
            CurrencyCode = obj
        }
        if let obj = dict["FromDate"] as? String{
            FromDate = obj
        }
        if let obj = dict["ToDate"] as? String{
            ToDate = obj
        }
        if let obj = dict["_Markup"] as? Double{
            _Markup = obj
        }
        if let obj = dict["_Markup_Gst"] as? Double{
            _Markup_Gst = obj
        }
    }
}

