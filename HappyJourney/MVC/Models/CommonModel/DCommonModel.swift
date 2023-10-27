//
//  DCommonModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

//MARK:- DCommonModel
struct DCommonModel {
    
    static var trendingHotel_imgPath = ""
    static var trendingbus_imgPath = ""
    static var trendingFlight_imgPath = ""
    static var topOffer_Array: [DCommonTopOfferItems] = []
    static var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    static var trendingActivities_imgPath = ""
    static var trendingActivities_Array: [DCommonTrendingActivitiesItems] = []
    static var perfectActivities_Array: [DCommonPerfectActivitiesItems_Packages] = []
    static var perfectActivities_imgPath = ""

    
    
    
    static var trendingPackage_Array: [DCommonTrendingPackageItem] = []
    static var trendingPackageImage = ""
    static var trendingFligh_Array: [DCommonTrendingFlightItem] = []
    static var trendingBus_Array : [DCommonTrendingBusesItem] = []
    static var trendingCar_Array: [DCommonTrendingCarItems] = []
    static var perfectCar_imgPath = ""
    static var trendingCar_imgPath = ""

    // clear all search information...
    static func clearDCommomModelInfo() {
        
        trendingHotel_imgPath = ""
        trendingFlight_imgPath = ""
        trendingbus_imgPath = ""
        // remove all array...
        topOffer_Array.removeAll()
        trendingHotel_Array.removeAll()
        trendingPackage_Array.removeAll()
        trendingFligh_Array.removeAll()
        trendingBus_Array.removeAll()
    }
    
    // create search items...
    static func createModels(result_dict: [String: Any]) {
        
        self.trendingHotel_Array.removeAll()
        self.trendingPackage_Array.removeAll()
        self.trendingFligh_Array.removeAll()
        self.trendingBus_Array.removeAll()
        // trending hotel...
        if let hotel_dict = result_dict["hotel"] as? [String: Any] {
            
            if let imagePath = hotel_dict["img_url"] as? String {
                self.trendingHotel_imgPath = imagePath
            }
            
            if let hotel_array = hotel_dict["list"] as? [[String: Any]] {
                
                for hotelList in hotel_array {
                    let hotelItem = DCommonTrendingHotelItems.init(details: hotelList)
                    self.trendingHotel_Array.append(hotelItem)
                }
            }
        }
        //package
        if let pkg_dict = result_dict["package"] as? [String: Any] {
            if let imagePath = pkg_dict["img_url"] as? String {
                self.trendingPackageImage = imagePath
            }
            if let busArray = pkg_dict["list"] as? [[String: Any]]{
                for busItem in busArray {
                    let item = DCommonTrendingPackageItem.init(details: busItem)
                    self.trendingPackage_Array.append(item)
                }
                
            }
        }
        //bus
        if let bus_dict = result_dict["bus"] as? [String: Any] {
            if let imagePath = bus_dict["img_url"] as? String {
                self.trendingbus_imgPath = imagePath
            }
            if let busArray = bus_dict["list"] as? [[String: Any]]{
                for busItem in busArray {
                    let item = DCommonTrendingBusesItem.init(details: busItem)
                    self.trendingBus_Array.append(item)
                }
                
            }
        }
        //flight
        if let flight_dict = result_dict["flight"] as? [String: Any] {
            if let imagePath = flight_dict["img_url"] as? String {
                self.trendingFlight_imgPath = imagePath
            }
            if let flightArray = flight_dict["list"] as? [[String: Any]]{
                for flightList in flightArray {
                    let flightItem = DCommonTrendingFlightItem.init(details: flightList)
                    self.trendingFligh_Array.append(flightItem)
                }            }
        }
        if let flight_dict = result_dict["BestCar"] as? [String: Any] {
            
            if let imagePath = flight_dict["img_url"] as? String {
                self.trendingCar_imgPath = imagePath
            }
            
            if let flight_array = flight_dict["list"] as? [[String: Any]] {
                
                for flightList in flight_array {
//                    if flightList["home_status"] as? String == "1"{
                        let item = DCommonTrendingCarItems.init(details: flightList)
                        self.trendingCar_Array.append(item)
//                    }
                }
            }
        }
        
        // BestActivities...
        if let flight_dict = result_dict["BestActivities"] as? [String: Any] {
            
            if let imagePath = flight_dict["img_url"] as? String {
                self.trendingActivities_imgPath = imagePath
            }
            
            if let flight_array = flight_dict["list"] as? [[String: Any]] {
                
                for flightList in flight_array {
                    if flightList["home_status"] as? String == "1"{
                        let item = DCommonTrendingActivitiesItems.init(details: flightList)
                        self.trendingActivities_Array.append(item)
                    }
                }
            }
        }
        // Perfect Activities Packages
        if let flight_dict = result_dict["PerfectActivities"] as? [String: Any] {
            
            if let imagePath = flight_dict["img_url"] as? String {
                self.perfectActivities_imgPath = imagePath
            }
            
            if let flight_array = flight_dict["list"] as? [[String: Any]] {
                
                for flightList in flight_array {
                    //if flightList["home_status"] as? String == "1"{
                        let item = DCommonPerfectActivitiesItems_Packages.init(details: flightList)
                        self.perfectActivities_Array.append(item)
                    //}
                }
            }
        }
    }
    
    // create promocode search items...
    static func createPromoCodeModels(result_dict: [String: Any]) {
        self.topOffer_Array.removeAll()
        // promocode...
        if let promo_array = result_dict["data"] as? [[String: Any]] {
            
            for promoList in promo_array {
                let promoItem = DCommonTopOfferItems.init(details: promoList)
                self.topOffer_Array.append(promoItem)
            }
        }
    }
}
// MARK:- DCommonTopOfferItems
struct DCommonTopOfferItems {
    
    //elements...
    var module: String?
    var promoCode: String?
    var promoDescription: String?
    var promo_img_url: String?
    var minimum_amount: Float?
    var value: Float?
    init(details: [String: Any]) {
        
        self.module = ""
        self.promoCode = ""
        self.promoDescription = ""
        self.promo_img_url = ""
        self.minimum_amount = 0.0
        
        self.value = 0.0
        if let moduleStr = details["module"] as? String {
            self.module = moduleStr
        }
        
        if let promo_code = details["promo_code"] as? String {
            self.promoCode = promo_code
        }
        
        if let promo_descp = details["description"] as? String {
            self.promoDescription = promo_descp
        }
        
        if let image_url = details["promo_code_image"] as? String {
            self.promo_img_url =  Promo_Image_URL + image_url
        }
        if let minimum_amount = details["minimum_amount"] as? String {
            self.minimum_amount = Float(String.init(describing: minimum_amount))!
        }
        if let value = details["value"] as? String {
            self.value = Float(String.init(describing: value))!
        }
    }
}

// MARK:- DCommonTrendingHotelItems
struct DCommonTrendingHotelItems {
    
    // elements...
    var origin_id: String?
    var cityName: String?
    var countryName: String?
    var hotelCount: String?
    var hotel_img_url: String?
    var id : String? = ""
    
    init(details: [String: Any]) {
        
        self.origin_id = ""
        self.cityName = ""
        self.countryName = ""
        self.hotelCount = ""
        self.hotel_img_url = ""
        
        if let origin = details["origin"] as? String {
            self.origin_id = origin
        }
        
        if let city_name = details["city_name"] as? String {
            self.cityName = city_name
        }
        
        if let country_name = details["country_name"] as? String {
            self.countryName = country_name
        }
        
        if let hotel_count = details["cache_hotels_count"] as? String {
            self.hotelCount = hotel_count
        }
        if let id = details["tbo_city_id"] as? String {
            self.id = id
        }
        if let img_url = details["image"] as? String {
            self.hotel_img_url = Base_Image_URL + DCommonModel.trendingHotel_imgPath + img_url// DCommonModel.trendingHotel_imgPath + img_url
        }
    }
    
}
class DCommonTrendingFlightItem {
    
    var from_airport_code: String? = ""
    var from_airport_name: String? = ""
    var image: String? = ""
    var origin: String? = ""
    var status: String? = ""
    var to_airport_code: String? = ""
    var to_airport_name: String? = ""
    
    init(details: [String: Any]) {
        if let from_airport_code = details["from_airport_code"] as? String{
            self.from_airport_code = from_airport_code
        }
        if let from_airport_name = details["from_airport_name"] as? String{
            self.from_airport_name = from_airport_name
        }
        if let image = details["image"] as? String{
            self.image = Base_Image_URL + DCommonModel.trendingFlight_imgPath + image//DCommonModel.trendingFlight_imgPath + image
        }
        if let origin = details["origin"] as? String{
            self.origin = origin
        }
        if let status = details["status"] as? String{
            self.status = status
        }
        if let to_airport_code = details["to_airport_code"] as? String{
            self.to_airport_code = to_airport_code
        }
        if let to_airport_name = details["to_airport_name"] as? String{
            self.to_airport_name = to_airport_name
        }
    }
    
    
    
    
    
}
class DCommonTrendingBusesItem {
    var from_bus_name : String? = ""
    var from_station_id : String? = ""
    var imageStr : String? = ""
    var offer : String? = ""
    var origin : String? = ""
    var to_bus_name : String? = ""
    var to_station_id : String? = ""
    var top_destination : String? = ""
    var state: String? = ""
    init(details: [String: Any]) {
        if let from_bus_name = details["name"] as? String {
            self.from_bus_name = from_bus_name
        }
        if let from_station_id = details["from_station_id"] as? String {
            self.from_station_id = from_station_id
        }
        if let imageStr = details["image"] as? String {
            self.imageStr = Base_Image_URL + DCommonModel.trendingbus_imgPath + imageStr
        }
        if let offer = details["offer"] as? String {
            self.offer = offer
        }
        if let origin = details["origin"] as? String {
            self.origin = origin
        }
        if let to_bus_name = details["to_bus_name"] as? String {
            self.to_bus_name = to_bus_name
        }
        if let to_station_id = details["station_id"] as? String {
            self.to_station_id = to_station_id
        }
        if let top_destination = details["top_destination"] as? String {
            self.top_destination = top_destination
        }
        if let top_destination = details["state"] as? String {
            self.state = top_destination
        }
        
    }

}
class DCommonTrendingPackageItem{
    var duration : String? = ""
    var image : String? = ""
    var package_city : String? = ""
    var package_code : String? = ""
    var package_country : String? = ""
    var package_description : String? = ""
    var package_id : String? = ""
    var package_location : String? = ""
    var package_name : String? = ""
    var package_type : String? = ""
    var price : Float? = 0.0
    var rating : String? = ""
    var status : String? = ""
    var top_destination : String? = ""

    init(details: [String: Any]) {
        
        if let duration = details["duration"] as? String{
            self.duration = duration
        }
        if let image = details["image"] as? String{
            self.image = Base_Image_URL + DCommonModel.trendingPackageImage + image
        }
        if let package_city = details["package_city"] as? String{
            self.package_city = package_city
        }
        if let package_code = details["package_code"] as? String{
            self.package_code = package_code
        }
        if let package_country = details["package_country"] as? String{
            self.package_country = package_country
        }
        if let package_description = details["package_description"] as? String{
            self.package_description = package_description
        }
        if let package_id = details["package_id"] as? String{
            self.package_id = package_id
        }
        if let package_location = details["package_location"] as? String{
            self.package_location = package_location
        }
        if let package_name = details["package_name"] as? String{
            self.package_name = package_name
        }
        if let package_type = details["package_type"] as? String{
            self.package_type = package_type
        }
        if let price = details["price"] as? String {
            self.price = Float(price)
        }
        if let rating = details["rating"] as? String{
            self.rating = rating
        }
        if let status = details["status"] as? String{
            self.status = status
        }
        if let top_destination = details["top_destination"] as? String{
            self.top_destination = top_destination
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    
    }
}
// MARK:- DCommonTrendingCarItems
struct DCommonTrendingCarItems {
    
    // elements...
    var airportID: String? = ""
    var airportName: String? = ""
    var airportCode: String? = ""
    var countryName: String? = ""

    var image_activity: String? = ""

    init(details: [String: Any]) {
        
        
        if let city_name = details["origin"] as? String {
            self.airportID = city_name
        }
        if let country_name = details["Airport_IATA"] as? String {
            self.airportCode = country_name
        }
        if let country_name = details["Airport_Name_EN"] as? String {
            self.airportName = country_name
        }
        if let country_name = details["Country_Name_EN"] as? String {
            self.countryName = country_name
        }
        
        
        if let img_url = details["image"] as? String {
            //self.image = Base_Image_URL + DCommonModel.trendingFlight_imgPath + img_url
            self.image_activity = DCommonModel.trendingCar_imgPath + img_url

        }
    }
}
// MARK:- Perfect Packages
struct DCommonPerfectActivitiesItems_Packages {
    
    // elements...
    var package_name: String? = ""
    var home_status: String? = ""
    var banner_image: String? = ""
    
    init(details: [String: Any]) {
        

        if let country_name = details["package_name"] as? String {
            self.package_name = country_name
        }
        
        if let hotel_count = details["home_status"] as? String {
            self.home_status = hotel_count
        }
        if let img_url = details["banner_image"] as? String {
            self.banner_image = DCommonModel.perfectActivities_imgPath + img_url
        }
        
    }
    
}

// MARK:- DCommonTrendingActivitiesItems
struct DCommonTrendingActivitiesItems {
    
    // elements...
    var origin_id: String? = ""
    var destination_id: String? = ""
    var destination_name: String? = ""
    var image_activity: String? = ""
    var home_status: String? = ""
    
    init(details: [String: Any]) {
        

        if let origin = details["origin"] as? String {
            self.origin_id = origin
        }
        
        if let city_name = details["destination_id"] as? String {
            self.destination_id = city_name
        }
        
        if let country_name = details["destination_name"] as? String {
            self.destination_name = country_name
        }
        
        if let hotel_count = details["home_status"] as? String {
            self.home_status = hotel_count
        }
        
        if let img_url = details["image_activity"] as? String {
            //self.image = Base_Image_URL + DCommonModel.trendingFlight_imgPath + img_url
            self.image_activity = DCommonModel.trendingActivities_imgPath + img_url

        }
    }
    
}
