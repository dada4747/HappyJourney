//
//  DBusDetailsModel.swift
//  Internacia
//
//  Created by Admin on 17/11/22.
//
import Foundation
struct DBusDetailModel {
    static var search_id : String? = ""
    static var result_token: String? = ""
    static var token : String? = ""
    static var token_key : String? = ""
    static var has_seater: Bool = false
    static var has_sleeper: Bool = false
    static var has_semi_seater: Bool = false
    static var details = DBusDetailModel()
    static var result = Result(details: [:])
    static var pickups: [Pickup] = []
    static var dropoffs: [Dropoff] = []
 
    static func clearModel(){
        details = DBusDetailModel()
        result = Result(details: [:])
        pickups = []
        dropoffs = []
    }
    static func createModel(details: [String : Any]){
        
        
        if let searchId = details["search_id"] as? String {
            self.search_id = searchId
        }
        if let resultToken = details["ResultToken"] as? String {
            self.result_token = resultToken
        }
        if let token = details["token"] as? String {
            self.token = token
        }
        if let tokenKey = details[""] as? String {
            self.token_key = tokenKey
        }
        if let detail = details["details"] as? [String: Any] {
            if let results = detail["result"] as? [String: Any]{
                self.result = Result.init(details: results)

            }
            if let route = detail["Route"] as? [String: Any] {
                
                if let hasSeater = route["SeaterFareAC"] as? Bool {
                    self.has_seater = hasSeater
                }
                if let hasSleeper = route["SleeperFareAC"] as? Bool {
                    self.has_sleeper = hasSleeper
                }
                if let hasSemiSeater = route["SemiSeater"] as? Bool {
                    self.has_semi_seater = hasSemiSeater
                }
            }
            if let boardingDetails = detail["boarding_details"] as? [String : Any] {
                if let data = boardingDetails["data"] as? [String : Any] {
                    if let result = data["result"] as? [String : Any] {
                        if let getdetails = result["GetBusRouteDetailResult"] as? [String : Any] {
                            if let bordinglist = getdetails["BoardingPointsDetails"] as? [[String: Any]] {
                                bordinglist.forEach { item in
                                    let i = Pickup.init(details: item)
//                                    print(i)
                                    self.pickups.append(i)
                                }
                            }
                            
                            print(pickups)
                            if let dropingList = getdetails["DroppingPointsDetails"] as? [[String: Any]] {
                                dropingList.forEach { item in
                                    let i = Dropoff.init(details: item)
//                                    print(i)
                                    self.dropoffs.append(i)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
}

// MARK: - Result
struct Result {
    var layout: [SeatDetails] = []
//    var canc: [[String: Int]] = [[:]]
    var max_Rows : Int = 0
    var max_Cols : Int = 0
    var htmlLayout: String? = ""
    var lower_array: [[SeatDetails?]] = []
    var upper_array: [[SeatDetails?]] = []
    var result_token: String = ""
    init(details: [String: Any]) {
        if let seatLayout = details["layout"] as? [String:Any] {
            var upper_array:  [SeatDetails] = []
            var lower_array : [SeatDetails] = []

            if let seatDetails = seatLayout["SeatDetails"] as? [[Any]] {
                var rowCount : Int
                rowCount = seatDetails.count
                var column_count: Int  = 0
                for i in 0..<rowCount {
                    column_count = seatDetails[i].count//4
                    for j in 0..<column_count {//13
                        if let seats = seatLayout["SeatDetails"] as? [[[String:Any]]]{
                            let inner_loop_data =  seats[i][j];//[0][0] = oth data
                            if ((inner_loop_data["IsUpper"] as! Int != 1) && ((inner_loop_data["SeatType"] as! Int != 4))) {
                                //lower array start
                                let k = SeatDetails.init(details: inner_loop_data )
                                //                                                    layout.append(k)
                                lower_array.append(k)
                                //lower array ends
                            } else {
                                // upper array start
                                let k = SeatDetails.init(details: inner_loop_data )
                                upper_array.append(k)
                            }
                        }
                    }
                }
                self.lower_array = creatArray(array: lower_array)
                self.upper_array = creatArray(array: upper_array)
                print("Upper Array ")
                printArray(array2D: self.upper_array)
                print("Lower Array ")
                printArray(array2D: self.lower_array)
            }
            
            if let maxRows = seatLayout["NoOfRows"] as? Int {
                self.max_Rows = maxRows
            }
            if let maxCols = seatLayout["NoOfColumns"] as? Int {
                self.max_Cols = maxCols
            }
            if let htmlLayout = details["HTMLLayout"]  as? String{
                self.htmlLayout = htmlLayout
            }
            if let resultToken = details["ResultToken"] as? String {
                self.result_token = resultToken
            }
            
           

           
            
        }
    }
    func printArray(array2D: [[SeatDetails?]]) {
        for row in lower_array {
            
            for object in row {
                if let object = object {
                    print("\(object.seatIndex)/\(object.seatName)", terminator: " ")
                } else {
                    print("nil", terminator: " ")
                }
            }
            print() // Print a new line after each row
        }
    }
    func creatArray(array: [SeatDetails]) -> [[SeatDetails?]] {
        //----------
        var maxRow = 0
        var maxColumn = 0
        
        for object in array {
            if object.rowNo! > maxRow {
                maxRow = object.rowNo!
            }
            
            if object.columnNo! > maxColumn {
                maxColumn = object.columnNo!
            }
        }
        var array2D: [[SeatDetails?]] = Array(repeating: Array(repeating: nil, count: maxColumn + 1), count: maxRow + 1)
        for object in array {
            array2D[object.rowNo!][object.columnNo!] = object
        }
        //---------
        return array2D
    }
}

// MARK: - Dropoff
struct Dropoff {
    var dropoffTime : String? = ""
    var dropoffName : String? = ""
    var dropoffCode : Int = 0
    var dropoffIndex: Int = 0
    var dropoffLocation: String? = ""
    init(details: [String : Any]) {
//        print(details)
        if let dropoffTime = details["CityPointTime"] as? String{
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd'T'HH:mm:ss", date: dropoffTime)
            let time = DateFormatter.getDateString(formate: "hh:mm a", date: destinDate)
            
            self.dropoffTime = time
        }
        if let dropoffName = details["CityPointName"] as? String{
            self.dropoffName = dropoffName
        }
        if let dropoffCode = details["CityPointIndex"] as? Int{
            self.dropoffCode = dropoffCode
        }
        if let dropoffIndex = details["CityPointIndex"] as? Int{
            self.dropoffIndex = dropoffIndex
        }
        
        if let dropoffLocation = details["CityPointLocation"] as? String{
            self.dropoffLocation = dropoffLocation
        }
    }
}
struct Pickup {
    var pickupCrossed: Bool = false
    var contact:  String? = ""
    var landmark:  String? = ""
    var address:  String? = ""
    var pickupTime: String? = ""
    var pickupArea : String? = ""
    var pickupName : String? = ""
    var pickupCode: Int = 0
    var pickupIndex: Int = 1
    init(details: [String : Any]){
        if let pickupCrossed = details["PickupCrossed"] as? Bool {
            self.pickupCrossed = pickupCrossed
        }
        if let contact = details["CityPointContactNumber"] as? String {
            self.contact = contact
        }
        if let landmark = details["CityPointLandmark"] as? String {
            self.landmark = landmark
        }
        if let address = details["CityPointAddress"] as? String {
            self.address = address
        }
        if let pickupTime = details["CityPointTime"] as? String {
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd'T'HH:mm:ss", date: pickupTime)
            let time = DateFormatter.getDateString(formate: "hh:mm a", date: destinDate)
            self.pickupTime = time
        }
        if let pickupArea = details["PickupArea"] as? String {
            self.pickupArea = pickupArea
        }
        if let pickupName = details["CityPointName"] as? String {
            self.pickupName = pickupName
        }
        if let pickupCode = details["CityPointIndex"] as? Int {
            self.pickupCode = pickupCode
        }
        if let pickupIndex = details["CityPointIndex"] as? Int {
            self.pickupIndex = pickupIndex
        }
    }
}


// MARK: - SeatDetails
struct SeatDetails {
    var  columnNo: Int?
    var  height: Int = 0
    var  isLadiesSeat : Bool = false
    var  isMalesSeat : Bool = false
    var  isUpper: Bool = false
    var  rowNo: Int?
    var  seatFare: Float = 0.0
    var  seatIndex: Int = 0
    var  seatName: String = ""
    var  seatStatus: Bool = false
    var  seatType : Int = 0
    var  width: Int = 0
    var  price: Price?
    init(details:[String : Any]) {
        
        if let columnNo = details["ColumnNo"] as? String{
            self.columnNo = Int(columnNo)
        }
        
        if let height = details["Height"] as? Int{
            self.height = height
        }
        
        if let isLadiesSeat = details["IsLadiesSeat"] as? Bool{
            self.isLadiesSeat = isLadiesSeat//na
        }
        
        if let isMalesSeat = details["IsMalesSeat"] as? Bool{
            self.isMalesSeat = isMalesSeat//na
        }
        
        if let isUpper = details["IsUpper"] as? Bool{
            self.isUpper = isUpper//na
        }
        
        if let rowNo = details["RowNo"] as? String{
            self.rowNo = Int(rowNo)
//            print(rowNo)
//            print(Int(rowNo))
        }
        
        if let seatFare = details["SeatFare"] as? Double{
            self.seatFare = Float(seatFare)
        }
        
        if let seatIndex = details["SeatIndex"] as? Int{
            self.seatIndex = seatIndex
        }
        
        if let seatName = details["SeatName"] as? String{
            self.seatName = seatName//na
        }
        
        if let seatStatus = details["SeatStatus"] as? Bool{
            self.seatStatus = seatStatus
        }
        
        if let seatType = details["SeatType"] as? Int{
            self.seatType = seatType
        }
        
        if let width = details["Width"] as? Int{
            self.width = width
        }
        
        //        if let price = details["ColumnNo"] as? {
        //            self.price = price
        //        }
        
        
        
        
    }
}

// MARK: - Price
struct Price {
    let currencyCode: String
    let basePrice: Double
    let tax, otherCharges, discount: Int
    let publishedPrice: Double
    let publishedPriceRoundedOff: Int
    let offeredPrice: Double
    let offeredPriceRoundedOff, agentCommission, agentMarkUp, tds: Int
    let gst: Gst
}
// MARK: - Gst
struct Gst {
    let cgstAmount, cgstRate, cessAmount, cessRate: Int
    let igstAmount, igstRate, sgstAmount, sgstRate: Int
    let taxableAmount: Int
}
