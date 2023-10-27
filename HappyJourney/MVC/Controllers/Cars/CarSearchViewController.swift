//
//  CarSearchViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 08/07/21.
//

import UIKit

class CarSearchViewController: UIViewController {
    @IBOutlet weak var txt_departure: UITextField!
    @IBOutlet weak var txt_destination: UITextField!
    
    @IBOutlet weak var lbl_pickDate: UILabel!
    @IBOutlet weak var lbl_returnDate: UILabel!

    @IBOutlet weak var lbl_nationality: UILabel!
    @IBOutlet weak var txt_driversAge: UITextField!

    @IBOutlet weak var returnView: UIView!
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var age_CheckBtn: UIButton!
    @IBOutlet weak var return_CheckBtn: UIButton!
    @IBOutlet weak var returnViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var returnViewTopSize: NSLayoutConstraint!
    
    // date pickers...
    @IBOutlet weak var datePicker_MainView: UIView!
    @IBOutlet weak var datePicker_View: UIDatePicker!

    @IBOutlet weak var img_loader: UIImageView!
    @IBOutlet weak var img_loader_popup: UIView!

    @IBOutlet weak var coll_BestTransfer: UICollectionView!
    @IBOutlet weak var coll_PerfectTransferPackages: UICollectionView!

    var cityIndex: Int = 0
    var dateIndex: Int = 0
    var returnCheckBoxClicked = false
    var ageCheckBoxClicked = false
    
    var departAirline: [String: String]?
    var destinationAirline: [String: String]?

    var countries_array: [[String: String]] = []
    var countryISO_Dict: [String: String] = [:]

    
    var returnDate = ""
    var returnTime = ""
    var pickupDate = ""
    var pickupTime = ""

    var carSearchMainModel: CarSearchMainModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        departAirline = ["airline_fullName": "Dubai International Airport (DXB), United Arab Emirates", "airline_country": "United Arab Emirates", "airline_code": "DXB", "airline_city": "DXB", "airline_top_destination": "3081", "airline_id": "1390", "airline_name": "Dubai International Airport (DXB)"]
        
        txt_driversAge.keyboardType = .numberPad
        returnView.alpha = 0
        returnViewHeightConstraint.constant = 0
        returnViewTopSize.constant = 0
        searchViewHeightConstraint.constant = 320//215
        datePicker_View.datePickerMode = .dateAndTime
        //datePicker_View.minuteInterval = 30
        getISOCodeList()
        
//        self.img_loader_popup.frame = self.view.frame
//        self.view.addSubview(img_loader_popup)
//        img_loader_popup.alpha = 0
//
//        img_loader.image = UIImage.gifImageWithName("alkhaleej-loader")
//        coll_BestTransfer.register(UINib.init(nibName: "BestTransferCVCell", bundle: nil), forCellWithReuseIdentifier: "BestTransferCVCell")
//        coll_PerfectTransferPackages.register(UINib.init(nibName: "PerfectPackagesCVCell", bundle: nil), forCellWithReuseIdentifier: "PerfectPackagesCVCell")

    }
    // MARK:- API CAll

    func searchAPICall(){

        
        let params:[String: Any] = ["depature": self.pickupDate,
                                    "depature_time": self.pickupTime,
                                    "return": self.returnDate,
                                    "return_time": self.returnTime,
                                    "car_from_loc_code": self.departAirline?["airline_code"] as? String,
                                    "car_from":self.departAirline?["airline_fullName"] as? String,
                                    "from_loc_id":self.departAirline?["airline_id"] as? String,
                                    "car_to_loc_code": self.destinationAirline?["airline_code"] as? String,
                                    "car_to":self.destinationAirline?["airline_fullName"] as? String,
                                    "to_loc_id":self.destinationAirline?["airline_id"] as? String,
                                    "country": lbl_nationality.text,
                                    "driver_age": txt_driversAge.text,
                                    "search_flight":"search"]
        
        
        
        
        
        
//        {"car_from":"Dubai International Airport (DXB),United Arab Emirates",
//            "from_loc_id":"5",
//            "car_from_loc_code":"DXB",
//            "car_to":"Dubai International Airport (DXB),United Arab Emirates",
//            "to_loc_id":"5",
//            "car_to_loc_code":"DXB",
//            "depature":"02-08-2021",
//            "depature_time":"09:00",
//            "return":"11-08-2021",
//            "return_time":"16:30"
//            ,"driver_age":"35",
//            "country":"IN",
//            "search_flight":"search"}
        
        
        let paramString: [String: String] = ["car_search": VKAPIs.getJSONString(object: params)]
//        self.img_loader_popup.alpha = 1
        CommonLoader.shared.startLoader(in: view)

        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: car_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Car search list success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if let obj = result["carlist"] as? [String: Any] {
                        if obj["status"] as? Bool == true {
                            if let data = obj["data"] as? [String: Any] {
                                if let carSearchResult = data["CarSearchResult"] as? [String: Any] {
                                    self.carSearchMainModel = CarSearchMainModel(dict: carSearchResult)
                                }
                            }
                        }else{
                            print("Something wrong..")
                            CommonLoader.shared.stopLoader()
                            return
                        }
                        
                    } else {
                        
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                            CommonLoader.shared.stopLoader()
                            return
                        }
                    }
                    
                    if let obj = result["search_params"] as? [String: Any] {
                        self.carSearchMainModel?.booking_source = obj["booking_source"] as? String
                        let id = obj["search_id"] as? Int
                        self.carSearchMainModel?.search_id = String(id ?? 0)
                    }
                } else {
                    print("Hotel search list formate : \(String(describing: resultObj))")
//                    self.img_loader_popup.alpha = 0
                    CommonLoader.shared.stopLoader()

                    return
                }
            } else {
                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
//                self.img_loader_popup.alpha = 0
                CommonLoader.shared.stopLoader()

                return
            }
            
           // self.displaycarsListMethod()
            //CommonLoader.shared.stopLoader()
            CommonLoader.shared.stopLoader()
            self.displaycarsListMethod()
        }
    }
    
//    func searchAPICall2(obj1: DCommonTrendingCarItems?, obj2: DCommonPerfectCarsItems_Packages?){
//        let currentDate = Date()
//        let calendar = Calendar.current
//
//        guard let oneweekDate = calendar.date(byAdding: .day, value: 7, to: currentDate) else {return}
//         let oneweekDateStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: oneweekDate)
//
//        guard let eightDate = calendar.date(byAdding: .day, value: 8, to: currentDate) else {return}
//         let eightDateStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: eightDate)
//
//
//        var params:[String: Any] = ["depature": oneweekDateStr,
//                                    "depature_time": "09:00",
//                                    "return": eightDateStr,
//                                    "return_time": "10:30",
//                                    "car_from_loc_code": "",
//                                    "car_from":"",
//                                    "from_loc_id":"",
//                                    "car_to_loc_code": "",
//                                    "car_to":"",
//                                    "to_loc_id":"",
//                                    "country": "",
//                                    "driver_age": "35",
//                                    "search_flight":"search"]
//
//        if obj1 != nil{
//            params["car_from"] = obj1?.airportName
//            params["car_from_loc_code"] = obj1?.airportCode
//            params["from_loc_id"] = obj1?.airportID
//            params["country"] = obj1?.countryName
//
//            params["car_to"] = obj1?.airportName
//            params["car_to_loc_code"] = obj1?.airportCode
//            params["to_loc_id"] = obj1?.airportID
//        }else if obj2 != nil{
//            params["car_from"] = obj2?.airportName
//            params["car_from_loc_code"] = obj2?.airportCode
//            params["from_loc_id"] = obj2?.airportID
//            params["country"] = obj2?.countryName
//
//            params["car_to"] = obj2?.airportName
//            params["car_from_loc_code"] = obj2?.airportCode
//            params["to_loc_id"] = obj2?.airportID
//
//        }
//
//        let paramString: [String: String] = ["car_search": VKAPIs.getJSONString(object: params)]
//        self.img_loader_popup.alpha = 1
//
//        // calling apis...
//        VKAPIs.shared.getRequestXwwwform(params: paramString, file: car_Search, httpMethod: .POST)
//        { (resultObj, success, error) in
//
//            // success status...
//            if success == true {
//                print("Car search list success: \(String(describing: resultObj))")
//
//                if let result = resultObj as? [String: Any] {
//                    if let obj = result["carlist"] as? [String: Any] {
//                        if obj["status"] as? Bool == true {
//                            if let data = obj["data"] as? [String: Any] {
//                                if let carSearchResult = data["CarSearchResult"] as? [String: Any] {
//                                    self.carSearchMainModel = CarSearchMainModel(dict: carSearchResult)
//                                }
//                            }
//                        }else{
//                            print("Something wrong..")
//                            self.img_loader_popup.alpha = 0
//                            return
//                        }
//
//                    } else {
//
//                        // error message...
//                        if let message_str = result["message"] as? String {
//                            self.view.makeToast(message: message_str)
//                            self.img_loader_popup.alpha = 0
//                            return
//                        }
//                    }
//
//                    if let obj = result["search_params"] as? [String: Any] {
//                        self.carSearchMainModel?.booking_source = obj["booking_source"] as? String
//                        let id = obj["search_id"] as? Int
//                        self.carSearchMainModel?.search_id = String(id ?? 0)
//                    }
//                } else {
//                    print("Hotel search list formate : \(String(describing: resultObj))")
//                    self.img_loader_popup.alpha = 0
//                    return
//                }
//            } else {
//                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
//                self.view.makeToast(message: error?.localizedDescription ?? "")
//                self.img_loader_popup.alpha = 0
//                return
//            }
//
//           // self.displaycarsListMethod()
//            //CommonLoader.shared.stopLoader()
//            self.img_loader_popup.alpha = 0
//            self.displaycarsListMethod()
//        }
//    }
    
    func displaycarsListMethod(){
        let vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarsListViewController") as! CarsListViewController
        vc.carSearchMainModel = self.carSearchMainModel
        vc.carSearchMainModel_Dummy = self.carSearchMainModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    // MARK:- Helper
    func getISOCodeList() {
        
        // getting country codes...
        countryISO_Dict = VKDialCodes.shared.current_dialCode
        displayDialCode(dailCode: countryISO_Dict)
        
        let temp_countries = VKDialCodes.shared.dialCodes_array
        if temp_countries.count != 0  {
            countries_array = temp_countries
        }
    }
    func displayDialCode(dailCode: [String: String]) {
        self.lbl_nationality.text = "\(String(describing: dailCode["Country"]!))"
    }
    
    
    // MARK:- Button Actions
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func search_Clicked(_ sender: Any) {
        print(departAirline?["airline_code"])
        let beforeDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                               date: pickupDate)

       if departAirline == nil {
            view.makeToast(message: "Enter Departure city or Airport")
        }else if returnCheckBoxClicked == true && destinationAirline == nil {
            view.makeToast(message: "Enter Destination city or Airport")
        }else if pickupDate.isEmpty == true {
            view.makeToast(message: "Enter pickup date")
        }else if returnDate.isEmpty == true {
            view.makeToast(message: "Enter return date")
        }else if (beforeDate.compare(DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                           date: returnDate)) == .orderedDescending)  {
            self.view.makeToast(message: "Please select return date greater than depart date !")
            return
        }else{
            self.searchAPICall()

        }
    }
    
    @IBAction func returnCheckBox_Clicked(_ sender: Any) {
        if returnCheckBoxClicked{
            returnCheckBoxClicked = false
            return_CheckBtn.setImage(UIImage(named: "ic_square_check"), for: .normal)
            returnView.alpha = 0
            returnViewHeightConstraint.constant = 0
            returnViewTopSize.constant = 0
            searchViewHeightConstraint.constant = 320//215
            self.destinationAirline = self.departAirline
        }else{
            returnCheckBoxClicked = true
            return_CheckBtn.setImage(UIImage(named: "ic_square_checked"), for: .normal)
            returnView.alpha = 1
            returnViewHeightConstraint.constant = 70
            returnViewTopSize.constant = 10
            searchViewHeightConstraint.constant = 400//280
        }
    }
    
    @IBAction func ageCheckBox_Clicked(_ sender: Any) {
        if ageCheckBoxClicked{
            ageCheckBoxClicked = false
            age_CheckBtn.setImage(UIImage(named: "ic_square_check"), for: .normal)
            ageView.alpha = 1
        }else{
            ageCheckBoxClicked = true
            age_CheckBtn.setImage(UIImage(named: "ic_square_checked"), for: .normal)
            ageView.alpha = 0
        }

        
    }
    
    @IBAction func pickupClicked(_ sender: Any) {
        cityIndex = 1
        moveToCitiesSelection()
    }
    @IBAction func dropClicked(_ sender: Any) {
        cityIndex = 2
        moveToCitiesSelection()
    }
    
    @IBAction func pickupAndReturnDatesButtonsClicked(_ sender: UIButton) {
        
        dateIndex = sender.tag
        
        if sender.tag == 1{
            datePicker_View.minimumDate = NSDate() as Date
        }else {
            
        }
        
        dismissKeyboardMethod()
        self.datePicker_MainView.isHidden = false
    }
    @IBAction func nationalityButtonClicked(_ sender: UIButton) {
        
        // getting current position...
        let parent_view = sender.superview
        let fieldRect: CGRect = (self.view?.convert((parent_view?.bounds)!, from: parent_view) ?? CGRect.zero)
        
        // table pop view...
        let tbl_popView = Bundle.main.loadNibNamed("TablePopView", owner: nil, options: nil)![0] as! TablePopView
        tbl_popView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        tbl_popView.delegate = self
        tbl_popView.DType = .CountryISO
        tbl_popView.countries_array = countries_array
        tbl_popView.changeMainView_Frame(rect: fieldRect)
        self.view.addSubview(tbl_popView)
    }
    
    // MARK:- PickerButtons
    @IBAction func hiddenDatePicker_ButtonClicked(_ sender: UIButton) {
        self.datePicker_MainView.isHidden = true
    }
    
    @IBAction func pickerCancelAndDone_ButtonClicked(_ sender: UIButton) {
        
        // done button aciton
        
        if dateIndex == 1{
            
            lbl_pickDate.text = DateFormatter.getDateString(formate: "dd-MM-yyyy HH:mm",
                                                            date: self.datePicker_View.date)
            self.pickupDate = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                          date: self.datePicker_View.date)
            self.pickupTime = DateFormatter.getDateString(formate: "HH:mm",
                                                          date: self.datePicker_View.date)
            if returnDate.isEmpty == false {
                lbl_returnDate.text = DateFormatter.getDateString(formate: "dd-MM-yyyy HH:mm",
                                                                date: self.datePicker_View.date)
                self.returnDate = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                              date: self.datePicker_View.date)
                self.returnTime = DateFormatter.getDateString(formate: "HH:mm",
                                                              date: self.datePicker_View.date)

            }
        }else{
            lbl_returnDate.text = DateFormatter.getDateString(formate: "dd-MM-yyyy HH:mm",
                                                            date: self.datePicker_View.date)
            self.returnDate = DateFormatter.getDateString(formate: "dd-MM-yyyy",
                                                          date: self.datePicker_View.date)
            self.returnTime = DateFormatter.getDateString(formate: "HH:mm",
                                                          date: self.datePicker_View.date)

        }
        print(dateIndex)
        print("pickup date\(DateFormatter.getDate(formate: "dd-MM-yyyy",date: pickupDate))")
        print("departdate\(DateFormatter.getDate(formate: "dd-MM-yyyy",date: returnDate))")
        
        if dateIndex > 1 {
            
            let beforeDate = DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                   date: pickupDate)
            if (beforeDate.compare(DateFormatter.getDate(formate: "dd-MM-yyyy",
                                                         date: returnDate)) == .orderedDescending)  {
                self.view.makeToast(message: "Please select return date greater than depart date !")
                return
            }
        }
        self.datePicker_MainView.isHidden = true
    }

    func moveToCitiesSelection() {
        
        // search city...
        let searchObj = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FSearchCitiesVC") as! FSearchCitiesVC
        searchObj.isComing = .Cars
        searchObj.delegate = self
        self.navigationController?.pushViewController(searchObj, animated: true)
        
    }
    func dismissKeyboardMethod() {
        
        // resigns...
        txt_departure.resignFirstResponder()
        txt_destination.resignFirstResponder()
    }

}
extension CarSearchViewController: searchCitiesDelegate{
    // MARK:- searchCitiesDelegate
    func searchCars_info(airlineInfo: [String : String], selectedSearchBoxIndex: Int) {
        
        print("selected air lines: \(airlineInfo)")
        
        if cityIndex == 1 {
            if let departCode = destinationAirline?["airline_code"] {
                if let destCode = airlineInfo["airline_code"] {
                    if destCode == departCode {
//                        self.view.makeToast(message: "Origin and Destination can't be same airport")
                        return
                    }
                }
            }
            // dispaly from city...f
            departAirline = airlineInfo
            //txt_departure.text = String.init(format: "%@ (%@)", airlineInfo["airline_city"]!,airlineInfo["airline_code"]!)
            txt_departure.text = airlineInfo["airline_name"]

            ///passing same pick to drop
            destinationAirline = airlineInfo
            //txt_destination.text = String.init(format: "%@ (%@)", airlineInfo["airline_city"]!,airlineInfo["airline_code"]!)
            txt_destination.text = airlineInfo["airline_name"]

        }
        
        else if cityIndex == 2 {
            if let destCode = departAirline?["airline_code"] {
                if let departCode = airlineInfo["airline_code"] {
                    if destCode == departCode {
//                        self.view.makeToast(message: "Origin and Destination can't be same airport")
                        return
                    }
                }
            }
            
            // display to city...
            destinationAirline = airlineInfo
            //txt_destination.text = String.init(format: "%@ (%@)", airlineInfo["airline_city"]!,airlineInfo["airline_code"]!)
            txt_destination.text = airlineInfo["airline_name"] as? String

            
        }
    }
    
}

// MARK:- ISOCodeDelegate
extension CarSearchViewController: ISOCodeDelegate {
    
    func countryISOCode(dial_code: [String : String]) {
        
        countryISO_Dict = dial_code
        displayDialCode(dailCode: countryISO_Dict)
    }
}
//extension CarSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == coll_BestTransfer{
//            return DCommonModel.trendingCar_Array.count
//        }else{
//            return DCommonModel.perfectCars_Array.count
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == coll_BestTransfer{
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestTransferCVCell", for: indexPath as IndexPath) as! BestTransferCVCell
//        cell.displayData(obj: DCommonModel.trendingCar_Array[indexPath.row])
//        return cell
//        }else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerfectPackagesCVCell", for: indexPath as IndexPath) as! PerfectPackagesCVCell
//            cell.displayData(obj: DCommonModel.perfectCars_Array[indexPath.row])
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if collectionView == coll_BestTransfer{
//            self.searchAPICall2(obj1:DCommonModel.trendingCar_Array[indexPath.row], obj2: nil)
//        }else{
//            self.searchAPICall2(obj1: nil, obj2:DCommonModel.perfectCars_Array[indexPath.row])
//        }
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == coll_BestTransfer{
//            return CGSize(width: 170, height: 135)
//        }else{
//            return CGSize(width: 170, height: 145)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        
//        return 10
//        
//    }
//}
extension UIImage{
    public class func gifImageWithData(_ data: Data) -> UIImage? {
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                print("image doesn't exist")
                return nil
            }
            
            return UIImage.animatedImageWithSource(source)
        }
        
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            print("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.03
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.03
        }
        
        return delay
    }
        
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a ?? 0 < b ?? 0 {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    
    
    
    
    
    
        
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
        
}
