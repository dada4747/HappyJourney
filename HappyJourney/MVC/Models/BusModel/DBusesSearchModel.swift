//
//  DBusesSearchModel.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import Foundation
struct DBusSearchModel{
    static var search_id = ""
    static var booking_source = ""
    static var busSearch_array : [DBusesSearchItem] = []
    static func clearModels(){
        busSearch_array.removeAll()
        booking_source = ""
        search_id = ""
    }
    static func createModels(result_dict: [String: Any]){
        busSearch_array.removeAll()
        if let searchId = result_dict["search_id"] as? Int {
            self.search_id = "\(searchId)"
        }
        if let bookingSource = result_dict["booking_source"] as? String {
            self.booking_source = bookingSource
        }
        if let data_list = result_dict["data"] as? [[String: Any]] {
            for bus in data_list {
                let searchItem = DBusesSearchItem.init(details: bus)
                self.busSearch_array.append(searchItem)
            }
        }
    }
}
            

struct DBusesSearchItem {
    var CompanyName : String?
    var CompanyId : String?
    var ProvId : String?
    var RouteScheduleId : String?
    var BusTypeName : String?
    var BusLabel : String?
    var RouteCode : String?
    var DeptTime : String?
    var DepartureTime : String?
    var ArrTime : String?
    var ArrivalTime : String?
    var CommAmount : Float = 0.0
    var DiscountAmt : Float = 0.0
    var TripId : String?
    var CompanySuf : String?
    var From : String?
    var To : String?
    var Duration : String?
    var Fare : Float = 0.0
    var AvailableSeats : Int = 0
    var ResultToken : String?
    //filters..
    var stop_type: Int = 0
    var depart_type: Int = 0
    var arrival_type: Int = 0
    
    var start_date = Date()
    var end_date = Date()
    var duration_seconds: Int = 0
    var canc: [[String: Any]] = [[:]]

    
    init(details: [String :Any]) {
        self.CompanyName = ""
        self.CompanyId = ""
        self.ProvId = ""
        self.RouteScheduleId = ""
        self.BusTypeName = ""
        self.BusLabel = ""
        self.RouteCode = ""
        self.DeptTime = ""
        self.DepartureTime = ""
        self.ArrTime = ""
        self.ArrivalTime = ""
        self.TripId = ""
        self.CompanySuf = ""
        self.From = ""
        self.To = ""
        self.Duration = ""
        self.ResultToken = ""
    
        if let CompanyName = details["CompanyName"] as? String{
            self.CompanyName = CompanyName
        }
        if let CompanyId = details["CompanyId"] as? Int{
            self.CompanyId = String(CompanyId)
        }
        if let ProvId = details["ProvId"] as? Int{
            self.ProvId = "\(ProvId)"
        }
        if let RouteScheduleId = details["RouteScheduleId"] as? String{
            self.RouteScheduleId = String(RouteScheduleId)
        }
//        print(self.RouteScheduleId)
        if let BusTypeName = details["BusTypeName"] as? String{
            self.BusTypeName = BusTypeName
        }
//        if let cancellationPolicy = details[""] as? {
        if let value = details["CancPolicy"] as? [[String: Any]] {
                self.canc = value
            }
//        }
        if let BusLabel = details["BusLabel"] as? String{
            self.BusLabel = BusLabel
        }
        if let RouteCode = details["RouteCode"] as? Int{
            self.RouteCode = String(RouteCode)
        }
        if let DeptTime = details["DeptTime"] as? String{
            self.DeptTime = DeptTime
            let destDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: DeptTime)
            self.start_date = destDate

        }
        if let DepartureTime = details["DepartureTime"] as? String{
            self.DepartureTime = DepartureTime
        }
        if let ArrTime = details["ArrTime"] as? String{

            self.ArrTime = ArrTime
            let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: ArrTime)
            self.end_date = arrDate
//            print(ArrTime)

        }
        if let ArrivalTime = details["ArrivalTime"] as? String{
            self.ArrivalTime = ArrivalTime
//            print(ArrivalTime)
        }
//        if let CommAmount = details["CommAmount"] as? Int{
            self.CommAmount =  Float(String.init(describing: details["CommAmount"])) ?? 0.0
//        }
        if let DiscountAmt = details["DiscountAmt"] as? String{
            self.DiscountAmt = Float(String.init(describing: DiscountAmt)) ?? 0.0
        }
        if let TripId = details["TripId"] as? String{
            self.TripId = TripId
        }
        if let CompanySuf = details["CompanySuf"] as? String{
            self.CompanySuf = CompanySuf
        }
        if let From = details["From"] as? String{
            self.From = From
        }
        if let To = details["To"] as? String{
            self.To = To
        }
        if let Duration = details["Duration"] as? String{
            self.Duration = Duration
        }
        if let Fare = details["API_Raw_Fare"] as? Float{
            self.Fare = Float(String.init(describing: Fare)) ?? 0.0
        }
        if let AvailableSeats = details["AvailableSeats"] as? Int {
            self.AvailableSeats = AvailableSeats
        }
        if let ResultToken = details["ResultToken"] as? String{
            self.ResultToken = ResultToken
        }
        
        depart_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: start_date)
        arrival_type = DFlightSearchModel.gettingDepart_arrivalIndex(select_date: end_date)

        stop_type = 0
        if ((BusTypeName?.contains("A/C")) == true || (BusTypeName?.contains("AC")) == true ) && (BusTypeName?.contains("Seater")) == true && (BusTypeName?.contains("NON")) != true {
         stop_type = 0
        } else if ((BusTypeName?.contains("NON")) == true && (BusTypeName?.contains("Seater")) == true )  {
            stop_type = 1
        }else if ((BusTypeName?.contains("A/C")) == true || (BusTypeName?.contains("AC")) == true ) && (BusTypeName?.contains("Sleeper")) == true && (BusTypeName?.contains("NON")) != true {
            stop_type = 2
        }else if((BusTypeName?.contains("NON")) == true && (BusTypeName?.contains("Sleeper")) == true ) {
            stop_type = 3
        }else{}
        
//        if ((BusTypeName?.contains("A/C")) == true || (BusTypeName?.contains("AC")) == true) && (BusTypeName?.contains("Sleeper")) == true {
//            stop_type = 2
//        } else if (BusTypeName?.contains("Non-A/C")) == true && (BusTypeName?.contains("Sleeper")) == true {
//            stop_type = 3
//        }else if (BusTypeName?.contains("Seater")) == true && (BusTypeName?.contains("A/C")) == true {
//            stop_type = 0
//        }else{
//
//        }
    }
}
            
//ac seater - 0
//non ac seater - 1
//ac sleeper - 2
//non a sleeper -3
   
