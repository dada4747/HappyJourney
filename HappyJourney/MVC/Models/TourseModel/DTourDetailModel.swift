//
//  TourDetailModel.swift
//  ExtactTravel
//
//  Created by Admin on 17/08/22.
//

import Foundation

// MARK: - TourDetailModel
struct DToursDetailsModel {
    static var tourDetails : TourDetailsItem = TourDetailsItem()
    
    static func createTourModel(result: [String: Any]) {
        self.tourDetails = TourDetailsItem.init(result: result)
        
    }
}

struct TourDetailsItem {
    var package = TourPackageItem()
    var packageItinerary: [PackageItinerary] = []
    var packagePricePolicy = PackagePricePolicy()
    var packageCancelPolicy = PackageCancelPolicy()
    var packageTravellerPhotos : [PackageTravellerPhoto] = []
    var currencyObj: CurrencyObj = CurrencyObj()
    init(){}
    func create(result: [[String: Any]]) -> [PackageItinerary] {
        var temp : [PackageItinerary] = []
        for res in result {
            let item = PackageItinerary.init(result: res)
            temp.append(item)
        }
        return temp
    }
    func createArray(result: [[String: Any]]) -> [PackageTravellerPhoto] {
        var temp : [PackageTravellerPhoto] = []
        for res in result {
            let item = PackageTravellerPhoto.init(result: res)
            temp.append(item)
        }
        return temp
    }
    
    init(result: [String: Any]){
        package = TourPackageItem.init(result: result["package"] as! [String : Any])
//        currencyObj = CurrencyObj.init(obj: result["currency_obj"] as! [String: Any])
        packageItinerary = create(result: result["package_itinerary"] as! [[String : Any]])
        packagePricePolicy = PackagePricePolicy.init(result: result["package_price_policy"] as! [String: Any])
        packageCancelPolicy = PackageCancelPolicy.init(result: result["package_cancel_policy"] as! [String: Any])
        packageTravellerPhotos = createArray(result: result["package_traveller_photos"] as! [[String: Any]])
        
    }
}

// MARK: - CurrencyObj
struct CurrencyObj {
    var toCurrency: String = ""
    var conversionRate: String = ""
    init() {
        
    }
    init(obj: [String: Any]){
        if let toCur = obj["to_currency"] as? String {
            self.toCurrency = toCur
        }
        if let conversion = obj["conversion_rate"] as? String {
            self.conversionRate = conversion
        }
    }
}


// MARK: - PackageCancelPolicy
struct PackageCancelPolicy {
    var canID : String = ""
    var packageID : String = ""
    var cancellationAdvance : String = ""
    var cancellationPenality : String = ""

    init() {
        
    }
    
    init(result: [String: Any]) {
        if let canID = result["can_id"] as? String {
            self.canID = canID
        }
        if let packageID = result["package_id"] as? String {
            self.packageID = packageID
        }
        if let cancellationAdvance = result["cancellation_advance"] as? String {
            self.cancellationAdvance = cancellationAdvance
        }
        if let cancellationPenality = result["cancellation_penality"] as? String {
            self.cancellationPenality = cancellationPenality
        }
    }
}

// MARK: - PackageItinerary
struct PackageInterneraryModel{
}
struct PackageItinerary {
    var itiID : String = ""
    var packageID : String = ""
    var day : String = ""
    var packageCity : String = ""
    var place : String = ""
    var itineraryDescription : String = ""
    var itineraryImage : String = ""
    var itineraryLink : String = ""
    
    init() {
        
    }
    init(result: [String: Any]) {
        if let itiID = result["iti_id"] as? String {
            self.itiID = itiID
        }
        if let packageID = result["package_id"] as? String {
            self.packageID = packageID
        }
        if let day = result["day"] as? String {
            self.day = day
        }
        if let packageCity = result["package_city"] as? String {
            self.packageCity = packageCity
        }
        if let place = result["place"] as? String {
            self.place = place
        }
        if let itineraryDescription = result["itinerary_description"] as? String {
            self.itineraryDescription = itineraryDescription
        }
        if let itineraryImage = result["itinerary_image"] as? String {
            self.itineraryImage = itineraryImage
        }
        if let itineraryLink = result["itinerary_link"] as? String {
            self.itineraryLink = itineraryLink
        }
    }
    
}

// MARK: - PackagePricePolicy
struct PackagePricePolicy {
    var priceID : String  = ""
    var packageID : String  = ""
    var priceIncludes : String  = ""
    var priceExcludes: String = ""
    init() {
        
    }
    init(result: [String : Any]) {
        if let priceID = result["price_id"] as? String {
            self.priceID = priceID
        }
        if let packageID = result["package_id"] as? String {
            self.packageID = packageID
        }
        if let priceIncludes = result["price_includes"] as? String {
            self.priceIncludes = priceIncludes
        }
        if let priceExcludes = result["price_excludes"] as? String {
            self.priceExcludes = priceExcludes
        }
    }
}

// MARK: - PackageTravellerPhoto
struct PackageTravellerPhoto {
    var imgID : String = ""
    var packageID : String = ""
    var travellerImage : String = ""
    var userID: String = ""
    var userType : String = ""
    var status : String = ""
    var photoDescription : String = ""
    init() {
        
    }
    init(result : [String: Any]) {
        if let imgID = result["img_id"] as? String {
            self.imgID = imgID
        }
        if let packageID = result["package_id"] as? String {
            self.packageID = packageID
        }
        if let travellerImage = result["traveller_image"] as? String {
            self.travellerImage = travellerImage
        }
        if let userID = result["user_id"] as? String {
            self.userID = userID
        }
        if let userType = result["user_type"] as? String {
            self.userType = userType
        }
        if let status = result["status"] as? String {
            self.status = status
        }
        if let photoDescription = result["photo_description"] as? String {
            self.photoDescription = photoDescription
        }
    }
}

