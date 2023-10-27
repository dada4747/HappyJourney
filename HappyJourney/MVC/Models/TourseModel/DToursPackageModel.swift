//
//  ToursPackageModel.swift
//  ExtactTravel
//
//  Created by Admin on 12/08/22.
//

import Foundation
// MARK: - Package Model
struct DTourPackageModel {
    static var packageArray : [TourPackageItem] = []
    static func createToursModel(result: [[String: Any]]) {
        packageArray.removeAll()
        for res in result {
            let item = TourPackageItem.init(result: res)
            self.packageArray.append(item)
        }
        DToursFilterModel.getPackagesAndPrice_fromResponce()
    }
}

// MARK: - Welcome5
//struct Welcome5 {
//    let city, duration, holidayType: String
//    let currencyObj: CurrencyObj
//    let scountry, spackageType, sduration, sbudget: NSNull
//    var packages: [Package]
//    let caption: Caption
//    let countries: [Country]
//    let packageTypes: [PackageTypee]
//}

// MARK: - Caption
//struct Caption {
//    let id, pageName, caption: String
//}

// MARK: - Country
//struct Country {
//    let packageCountry, countryName: String
//}

// MARK: - CurrencyObj
//struct CurrencyObj {
//    let toCurrency: String
//    let conversionRate: NSNull
//}

// MARK: - PackageType
//struct PackageTypee {
//    let packageTypesID, packageTypesName, domainListFk: String
//}

//MARK:- Package
struct TourPackageItem {
    var packageID: String = ""
    var packageCode: String = ""
    var supplierID: String = ""
    var tourTypes: String = ""
    var packageName: String = ""
    var packageTourCode: String = ""
    var duration: Int? = 0
    var packageDescription: String? = ""
    var image: String = ""
    var packageCountry: String = ""
    var packageState: String = ""
    var packageCity: String = ""
    var packageLocation: String = ""
    var packageType: String = ""
    var priceIncludes: String = ""
    var deals: String = ""
    var noQue: String = ""
    var homePage: String = ""
    var rating: Int? = 0
    var status: String = ""
    var price: Float = 0.0
    var display: String = ""
    var domainListFk: String = ""
    var topDestination: String = ""
    init(){}
    init(result: [String: Any]) {
        if let package_id = result["package_id"] as? String {
            self.packageID = package_id
        }
        
        if let packageCode = result["package_code"] as? String{
            self.packageCode = packageCode
        }
        if let supplierID = result["supplier_id"] as? String{
            self.supplierID = supplierID
        }
        if let tourTypes = result["tour_types"] as? String{
            self.tourTypes = tourTypes
        }
        if let packageName = result["package_name"] as? String{
            self.packageName = packageName
        }
        if let packageTourCode = result["package_tour_code"] as? String{
            self.packageTourCode = packageTourCode
        }
        if let duration = result["duration"] as? String{
            self.duration = Int(duration)
        }
        if let packageDescription = result["package_description"] as? String{
            self.packageDescription = packageDescription
        }
        if let image = result["image"] as? String{
            self.image = image
        }
        if let packageCountry = result["package_country"] as? String{
            self.packageCountry = packageCountry
        }
        if let packageState = result["package_state"] as? String{
            self.packageState = packageState
        }
        if let packageCity = result["package_city"] as? String{
            self.packageCity = packageCity
        }
        if let packageLocation = result["package_location"] as? String{
            self.packageLocation = packageLocation
        }
        if let packageType = result["package_type"] as? String{
            self.packageType = packageType
        }
        if let priceIncludes = result["price_includes"] as? String{
            self.priceIncludes = priceIncludes
        }
        if let deals = result["deals"] as? String{
            self.deals = deals
        }
        if let noQue = result["no_que"] as? String{
            self.noQue = noQue
        }
        if let homePage = result["home_page"] as? String{
            self.homePage = homePage
        }
        if let rating = result["rating"] as? String{
            self.rating = Int(rating)
        }
        if let status = result["status"] as? String{
            self.status = status
        }
        if let price = result["price"] as? String{
            self.price = Float(String.init(describing: price)) ?? 0.0
        }
        if let display = result["display"] as? String{
            self.display = display
        }
        if let domainListFk = result["domain_list_fk"] as? String{
            self.domainListFk = domainListFk
        }
        if let topDestination = result["top_destination"] as? String{
            self.topDestination = topDestination
        }        
    }
}
