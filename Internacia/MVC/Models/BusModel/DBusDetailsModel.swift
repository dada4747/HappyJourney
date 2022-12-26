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

                if let hasSeater = route["HasSeater"] as? Bool {
                    self.has_seater = hasSeater
                }
                if let hasSleeper = route["HasSleeper"] as? Bool {
                    self.has_sleeper = hasSleeper
                }
                if let hasSemiSeater = route["SemiSeater"] as? Bool {
                    self.has_semi_seater = hasSemiSeater
                }
            }
        }
    }
    
}

// MARK: - Result
struct Result {
//    var seatDetails: SeatDetails
    var values: [Value] = []
//    var layout: Layout
    var pickups: [Pickup] = []
    var dropoffs: [Dropoff] = []
    var canc: [[String: Int]] = [[:]]
    var max_Rows : Int = 0
    var max_Cols : Int = 0
    init(details: [String: Any]) {
        if let detail = details["layout"] as? [String:Any] {
            if let maxRows = detail["MaxRows"] as? Int {
                self.max_Rows = maxRows
                print(maxRows)
            }
            if let maxCols = detail["MaxCols"] as? Int {
                self.max_Cols = maxCols
                print(maxCols)
            }
            if let pickup = details["Pickups"] as? [[String: Any]] {
                for pick in pickup {
                    let item = Pickup.init(details: pick)
                    pickups.append(item)
                }
            }
            if let drops = details["Dropoffs"] as? [[String: Any]] {
                for drop in drops {
                    let item = Dropoff.init(details: drop)
                    dropoffs.append(item)
                }
            }
            if let value = details["value"] as? [[String: Any]] {
                for v in value {
                    let item = Value.init(details : v)
                    values.append(item)
                }
            }
            if let value = details["Canc"] as? [[String: Int]] {
                self.canc = value
            }
        }
    }
}

// MARK: - Dropoff
struct Dropoff {
    var dropoffTime : String? = ""
    var dropoffName : String? = ""
    var dropoffCode : String? = ""
    init(details: [String : Any]) {
        print(details)
        if let dropoffTime = details["DropoffTime"] as? String{
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: dropoffTime)
            let time = DateFormatter.getDateString(formate: "HH:mm a", date: destinDate)

            self.dropoffTime = time
        }
        if let dropoffName = details["DropoffName"] as? String{
            self.dropoffName = dropoffName
        }
        if let dropoffCode = details["DropoffCode"] as? String{
            self.dropoffCode = dropoffCode
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
    var pickupCode: String? = ""
    
    init(details: [String : Any]){
        if let pickupCrossed = details["PickupCrossed"] as? Bool {
            self.pickupCrossed = pickupCrossed
        }
        if let contact = details["Contact"] as? String {
            self.contact = contact
        }
        if let landmark = details["Landmark"] as? String {
            self.landmark = landmark
        }
        if let address = details["Address"] as? String {
            self.address = address
        }
        if let pickupTime = details["PickupTime"] as? String {
            let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: pickupTime)
            let time = DateFormatter.getDateString(formate: "HH:mm a", date: destinDate)
            self.pickupTime = time
        }
        if let pickupArea = details["PickupArea"] as? String {
            self.pickupArea = pickupArea
        }
        if let pickupName = details["PickupName"] as? String {
            self.pickupName = pickupName
        }
        if let pickupCode = details["PickupCode"] as? String {
            self.pickupCode = pickupCode
        }
        
    }
}
// MARK: - Value
struct Value {
    var seqNo : Int = 0
    var row : Int = 0
    var col : Int = 0
    var width: Int = 0
    var height : Int = 0
    var seatType: Int = 0
    var seatNo: String = ""
    var totalFare : Float = 0.0
    var baseFare : Float = 0.0
    var status: Int = 0
    var decks: String = ""
    var maxRows: Int = 0
    var maxCols: Int = 0
    var isAvailable: Bool = false
    var fare : Float = 0.0
    var childFare : Float = 0.0
    var infantFare: Int = 0
    init(details:[String : Any]) {
        
        if let seqNo = details["seq_no"] as? Int {
            self.seqNo = seqNo
        }
        if let row = details["row"] as? Int {
            self.row = row
        }
        if let col = details["col"] as? Int {
            self.col = col
        }
        if let width = details["width"] as? Int {
            self.width = width
        }
        if let height = details["height"] as? Int {
            self.height = height
        }
        if let seatType = details["seat_type"] as? Int {
            self.seatType = seatType
        }
        if let seatNo = details["seat_no"] as? String {
            self.seatNo = seatNo
        }
        if let totalFare = details["total_fare"] as? Float {
            self.totalFare = totalFare// Float(String.init(describing: details["total_fare"])) ?? 0.0
        }
//        if let baseFare = details[""] as? Int {
            self.baseFare = Float(String.init(describing: details["base_fare"])) ?? 0.0
//        }
        if let status = details["status"] as? Int {
            self.status = status
        }
        if let decks = details["decks"] as? String {
            
            self.decks = decks
            print(self.decks)
        }
        if let maxRows = details["MaxRows"] as? Int {
            self.maxRows = maxRows
        }
        if let maxCols = details["MaxCols"] as? Int {
            self.maxCols = maxCols
        }
        if let isAvailable = details["IsAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
//        if let fare = details[""] as? Int {
        self.fare = Float(String.init(describing: details["Fare"])) ?? 0.0
//        }
//        if let childFare = details[""] as? Int {
        self.childFare = Float(String.init(describing: details["ChildFare"])) ?? 0.0
//        }
        if let infantFare = details["InfantFare"] as? Int {
            self.infantFare = infantFare
        }
        
    }
}
// MARK: - Layout
// MARK: - Pickup

// MARK: - SeatDetails
struct SeatDetails {
    let isCovidSafe, hasPreHold, hasPGCharges, paxVerify: Bool
    let gstEnabled: Bool
    let reliabilityVersion, maxAllowedSeats: Int
    let chartLayout: ChartLayout
    let chartSeats: ChartSeats
    let seatsStatus: SeatsStatus
    let pickups: [Pickup]
    let dropoffs: [Dropoff]
    let canc: [[String: Int]]
    let availSeats: AvailSeats
//    let preponePostponePolicy: PreponePostponePolicy
    let suretyScore: Int
    let provID, chartCode: String
}

// MARK: - AvailSeats
struct AvailSeats {
    let upper, lower: Int
}

// MARK: - ChartLayout
struct ChartLayout {
    let info: Info
    let layout: LayoutClass
}

// MARK: - Info
struct Info {
    let totalSleeper, totalSemiSleeper, totalSeater, totalSeats: Int
    let decks: Int
//    let lower, upper: Layout
    let layoutName: String
}

// MARK: - LayoutClass
struct LayoutClass {
    let lower, upper: [[Int]]
}

// MARK: - ChartSeats
struct ChartSeats {
    let seats: [String]
}

// MARK: - PreponePostponePolicy
//struct PreponePostponePolicy {
//    let preponePolicy, postponePolicy, sameDayPolicy: [[String: Int]]
//    let isPostpone, isPrepone: Bool
//    let chargeMode: String
//}

// MARK: - SeatsStatus
struct SeatsStatus {
    let status: [Int]
    let fares: [[Int]]
    let uniqFares, covidBlockStatus: [Int]
    let profiler: String
}



//
//enum Decks {
//    case lower
//    case upper
//}

//// MARK: - Route
//struct Route {
//    let companyName: String
//    let companyID, provID, routeScheduleID: Int
//    let busTypeName, busLabel, routeCode, deptTime: String
//    let departureTime, arrTime, arrivalTime: String
//    let hasNAC, hasAC, hasSleeper, hasSeater: Bool
//    let semiSeater, isVolvo: Bool
//    let commAmount, discountAmt: Int
//    let tripID: String
//    let companySuf: NSNull
//    let from, to, duration: String
//    let busStatus: BusStatus
//    let fare, availableSeats: Int
//    let amenities: [Int]
//    let busTypeNames: BusTypeNames
//    let resultToken, bookingSource: String
//    let status: Int
//    let apiRawFare: String
//    let seaterFareNAC, seaterFareAC, sleeperFareNAC, sleeperFareAC: Int
//    let busType: Int
//}
//
//// MARK: - BusStatus
//struct BusStatus {
//    let baseFares: [Int]
//    let totalTax: Int
//    let currencyCode: String
//}

//// MARK: - BusTypeNames
//struct BusTypeNames {
//    let isAC, seating, make: String
//}
