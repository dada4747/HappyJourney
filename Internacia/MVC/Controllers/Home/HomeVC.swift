//
//  HomeVC.swift
//  Internacia
//
//  Created by Admin on 28/10/22.
//

import UIKit
import AVFoundation
class HomeVC: UIViewController{
    
    @IBOutlet weak var tbl_ads: UITableView!
    @IBOutlet weak var coll_tabModules: UICollectionView!
    @IBOutlet weak var coll_quickTab: UICollectionView!
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var img_currency: UIImageView!
    
    @IBOutlet var headerview: UIView!
    
    @IBOutlet weak var headerViewimage: UIImageView!
    //    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var lbl_greeting: UILabel!
    var topOffer_Array: [DCommonTopOfferItems] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
    var trendingBuses_Array: [DCommonTrendingBusesItem] = []
    var view_currencyPop: CurrencyView?
    var temp_currencyModel: DCurrencyItem?
    
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add views...
        
        
        homePageAdsList_APIConnection()
        getAllPromoCode_APIConnection()
        displayWelcomeGreeting()

    }
    override func viewWillAppear(_ animated: Bool) {
        addTblDelegates()
        addSideMenu()
//        tbl_ads.reloadData()
        addFrameAdd_views()
        
    }
    
    override func viewDidLayoutSubviews() {
        coll_tabModules.layoutIfNeeded()
        coll_quickTab.layoutIfNeeded()
//        tbl_ads.reloadData()
    }
    // MARK: - Helper
    func displayWelcomeGreeting(){
        var currentTimeOfDay = ""

                let hour = NSCalendar.current.component(.hour, from: NSDate() as Date)
                if hour >= 0 && hour < 12 {

                    currentTimeOfDay = "Morning"

                } else if hour >= 12 && hour < 17 {

                    currentTimeOfDay = "Afternoon"

                } else if hour >= 17 {

                    currentTimeOfDay = "Evening"

                }
        lbl_greeting.text = "Good \(currentTimeOfDay)"
    }

    func addTblDelegates() {
        
        // table delegates...
        tbl_ads.delegate = self
        tbl_ads.dataSource = self
        
        tbl_ads.rowHeight = UITableView.automaticDimension
        tbl_ads.estimatedRowHeight = 140
        tbl_ads.tableHeaderView = headerview//UIView(frame: CGRect(x: 0, y: 0, width: 290, height: 400))
        
        // delegate...
        coll_tabModules.delegate = self
        coll_tabModules.dataSource = self
        coll_quickTab.delegate = self
        coll_quickTab.dataSource = self
        
        // register...
        coll_tabModules.register(UINib.init(nibName: "HomeModulesCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeModulesCVCell")
        coll_quickTab.register(UINib.init(nibName: "QuickTabCV", bundle: nil), forCellWithReuseIdentifier: "QuickTabCV")
        
    }
    
    func addFrameAdd_views() {
        
        // calendar pop adding to window...
        for views in (UIApplication.shared.keyWindow?.subviews)! {
            if views.tag == 100 || views.tag == 102 {
                views.removeFromSuperview()
            }
        }
        
        // currency pop view...
        self.view_currencyPop = CurrencyView.loadViewFromNib() as? CurrencyView
        self.view_currencyPop?.isHidden = true
        self.view_currencyPop?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_currencyPop!)
        
        getCurrencyConverterList()
    }
    
    func displayAds() {
        topOffer_Array = DCommonModel.topOffer_Array
        trendingHotel_Array = DCommonModel.trendingHotel_Array
        trendingFlight_Array = DCommonModel.trendingFligh_Array
        trendingBuses_Array = DCommonModel.trendingBus_Array
//        trendingHoliday_Array = DCommonModel.trendingPackage_Array

        DispatchQueue.main.async {
            self.tbl_ads.reloadData()

        }
    }
    
    func addSideMenu() -> Void {
        
        // remove if existed...
        let window = getWindow()
        let menu_view = window.viewWithTag(50000)
        if menu_view != nil {
            menu_view?.removeFromSuperview()
        }
        
        // slider menu...
        let side_menu = Bundle.main.loadNibNamed("SliderMenuView", owner: nil, options: nil)![0] as! SliderMenuView
        side_menu.frame = CGRect.init(x: -self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        side_menu.delegate = self
        side_menu.btn_bg.alpha = 0
        side_menu.tag = 50000
        UIApplication.shared.keyWindow?.addSubview(side_menu)
    }

    // MARK: - ButtonAction
    @IBAction func menuBtnClicked(_ sender: UIButton) {
        // menu moving...
        appDel.sideMenu_actions()
    }
    
    @IBAction func currencyBtnClicked(_ sender: UIButton) {
        
        self.view_currencyPop?.isFrom = ""
        self.view_currencyPop?.displayInformation()
        self.view_currencyPop?.delegate = self
        self.view_currencyPop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_currencyPop!)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
        if cell == nil {
            tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
        cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
        }
        
        if indexPath.row == 0 {
            
            
            cell?.selectionStyle = .none
//            cell?.trendingHotel_Array = []
                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
                cell?.adsType = "Hotel"
            
                cell?.topDestHotelDelegate = self
            return cell!
            }
        else if indexPath.row == 1 {
            
            
                cell?.selectionStyle = .none
            cell?.topDestHotelDelegate = self
                cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
                cell?.adsType = "Flight"
            return cell!
        } else {
            
            cell?.topDestHotelDelegate = self
            cell?.selectionStyle = .none
            cell?.displayTopBusesDestination(trendingBuses_Array: trendingBuses_Array)
            cell?.adsType = "buses"
            return cell!
        }
//        return cell!
        }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coll_tabModules {
            return CGSize(width: 70, height: 70)
        } else {
            let l = self.coll_quickTab.frame.width / 3
            return CGSize(width: l, height: 35)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coll_tabModules {
            return 3
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coll_tabModules {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeModulesCVCell", for: indexPath as IndexPath) as! HomeModulesCVCell
//            cell.lbl_title.textColor = .white
            
            //display information...
            switch indexPath.row {
            case 0:
                cell.lbl_title.text = "FLIGHTS"
                cell.img_icon.image = UIImage.init(named: "flight_module")
                
            case 1:
                cell.lbl_title.text = "HOTELS"
                cell.img_icon.image = UIImage.init(named: "hotel_module")
                
            case 2:
                cell.lbl_title.text = "BUSES"
                cell.img_icon.image = UIImage.init(named: "bus_module")

            default: break
                
            }
            
            return cell
            
        } else {
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuickTabCV", for: indexPath as IndexPath) as! QuickTabCV
            cell.lbl_title.textColor = .black
            
            
            //display information...
            switch indexPath.row {
            case 0:
                cell.lbl_title.text = "Booking Status"
                cell.img_icon.image = UIImage.init(named: "ic_flight_takeoff")
                
            case 1:
                cell.lbl_title.text = "Offers"
                cell.img_icon.image = UIImage.init(named: "ic_offer")
                
            case 2:
                cell.lbl_title.text = "Festivals"
                cell.img_icon.image = UIImage.init(named: "bus")
            default: break
                
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coll_tabModules {

        switch indexPath.row {
        case 0:
            let nextVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightHomeVC") as! FlightHomeVC
            let navControl = getRootNavigation()

            navControl?.pushViewController(nextVC, animated: true)
        case 1:
            let nextVC = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHomeVC") as! HotelHomeVC
            let navControl = getRootNavigation()
            
            navControl?.pushViewController(nextVC, animated: true)
        case 2:
            let nextVC = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusHomeVC") as! BusHomeVC
            let navControl = getRootNavigation()
            navControl?.pushViewController(nextVC, animated: true)
            break
        default:
            break
        }
        }else if collectionView == coll_quickTab {
            switch indexPath.row {
            case 0:
                let navControl = getRootNavigation()

                if "".getUserId().isEmpty {
                    view.makeToast(message: "Please Login")
                    let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginNavigationVC") as! LoginNavigationVC
                    navControl?.pushViewController(vc, animated: true)
                } else {

                // move to my bookings...
                    let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "NewBookingsVC") as! NewBookingsVC
                    bookVC.from = "menu"
                navControl?.pushViewController(bookVC, animated: true)
                }
            case 1:
                let nextVC = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
                let navControl = getRootNavigation()
                
                navControl?.pushViewController(nextVC, animated: true)
            case 2:
                let nextVC = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
                let navControl = getRootNavigation()
                
                navControl?.pushViewController(nextVC, animated: true)

                break
            default:
                break
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coll_tabModules {

            return 10
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == coll_tabModules {
            return 10
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return  UIEdgeInsets.zero
    }
}



extension HomeVC: SliderMenuViewDelegate {
    
    // MARK:- SMenuViewDelegate
    func sliderMenuActions(section_name: String) {
        let userId = ""
        // menu moving...
        let appDele : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDele.sideMenu_actions()
        print("slider menu : \(section_name)")
        
        let navControl = getRootNavigation()
        
        // menu actions...
        if section_name == "My Account" {
            if userId.getUserId().isEmpty {
                view.makeToast(message: "Please Login")
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginNavigationVC") as! LoginNavigationVC
                navControl?.pushViewController(vc, animated: true)
            } else {

            // move to my profile...
                let profile_vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                profile_vc.isFrom = "Menu"
                navControl?.pushViewController(profile_vc, animated: true)
            }
        }
        else if section_name == "My Bookings" {
            if userId.getUserId().isEmpty {
                view.makeToast(message: "Please Login")
                let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "LoginNavigationVC") as! LoginNavigationVC
                navControl?.pushViewController(vc, animated: true)
            } else {

            // move to my bookings...
                let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "NewBookingsVC") as! NewBookingsVC
                bookVC.from = "menu"
            navControl?.pushViewController(bookVC, animated: true)
            }
        }
        else if section_name == "About Us" {
            
            
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .AboutUs
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Contact Us" {
            
            // move to contact us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .ContactUs
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Privacy Policy" {
            
            // move to Privacy...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Privacy
            navControl?.pushViewController(vc, animated: true)
        }
        else if section_name == "Terms & Conditions" {
            
            // move to about us...
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "CMSContentVC") as! CMSContentVC
            vc.isFrom = .Terms
            navControl?.pushViewController(vc, animated: true)
        } else if section_name == "My Rewards" || section_name == "Wallet" {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
            navControl?.pushViewController(vc, animated: true)
        }else if section_name == "Change Password" {
                    let changePassVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            navControl?.pushViewController(changePassVC, animated: true)

        } else if section_name == "Rate Us" {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
            
            navControl?.pushViewController(vc, animated: true)
        } else if section_name == "Wishlist"  {
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistVC
            navControl?.pushViewController(vc, animated: true)
        }else if  section_name == "Notifications" {
//            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "EmptyVC") as! EmptyVC
            let vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "NotificationsVC") as! NotificationsVC
            navControl?.pushViewController(vc, animated: true)
        } else if section_name == "Create Account"{
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//            let navigationController = UINavigationController(rootViewController: VC)
//            navigationController.isNavigationBarHidden = true
            
//            appDel.window?.rootViewController = navigationController
            VC.isFrom = "Menu"
            navControl?.pushViewController(VC, animated: true)
        }
        else if section_name == "Logout" || section_name == "Login" {
            
            if profile_dict != nil {
                //user logout...
                UserDefaults.standard.set(nil, forKey: TMXUser_Profile)
            }
            
            // move to Login(Change root for window)...
            let loginObj = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            let navigationController = UINavigationController(rootViewController: loginObj!)
            navigationController.isNavigationBarHidden = true
            appDel.window?.rootViewController = navigationController
        }
        
        else {}
    }
}

extension HomeVC : CurrencyDelegate {
    
    // get currency converter...
    func getCurrencyConverterList() -> Void {
        
        // currency api...
        SwiftLoader.show(animated: true)
        
        DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        if DCurrencyModel.currency_saved == nil {
            DCurrencyModel.setDefaultCurrency()
            DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        }
        TMXClass.shared.getCurrencyConverterList { [weak self] (message) in
            
            // adding inforamtion
            let old_currency = DCurrencyModel.retriveCurrency()
            for model in DCurrencyModel.currency_array {
                if old_currency?.currency_id == model.currency_id {
                    
                    DCurrencyModel.saveCurrency(model: model)
                    DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
                    break
                }
            }
            
            // success response
            if message == "Success" {
                self?.displayCurrency()
            }
            SwiftLoader.hide()
        }
    }
    
    func displayCurrency() {
        
        temp_currencyModel = DCurrencyModel.currency_saved
        let code = DCurrencyModel.currency_saved?.currency_country ?? "USD"
        self.getCurrencyValue_APIConnection(toCurrency: code)
        lbl_currency.text = code
        img_currency.image = UIImage.init(named: String.init(format: "%@.png",code))
    }
    
    // MARK: - CurrencyDelegate
    func currencyListActions(model: DCurrencyItem) {

        temp_currencyModel = model
        
        img_currency.image = UIImage.init(named: String.init(format: "%@.png", model.currency_country!))
        lbl_currency.text = model.currency_country
        
        getCurrencyValue_APIConnection(toCurrency: model.currency_country ?? "USD")
//        updateCurrencyValue(currency_value: model.currency_value)
    }
}

extension HomeVC {
    
    // MARK: - API's
    func homePageAdsList_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // calling api...
        VKAPIs.shared.getRequest(file: HomePageAdsList, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("homePageAds success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        if let dataDict = result["data"] as? [String: Any] {
                            DCommonModel.createModels(result_dict: dataDict)
                        }
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("homePageAds formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayAds()
            SwiftLoader.hide()
        }
    }
    
    func getAllPromoCode_APIConnection() -> Void {
        
        SwiftLoader.show(animated: true)
        // calling api...
        VKAPIs.shared.getRequest(file: Get_AllPromo, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Promo code success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        // response date...
                        DCommonModel.createPromoCodeModels(result_dict: result)
                        
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            //                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Promo code formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            self.displayAds()
            SwiftLoader.hide()
        }
    }
    
    func getCurrencyValue_APIConnection(toCurrency: String) -> Void {
        
        SwiftLoader.show(animated: true)
        
        let urlString = "\("http://prod.services.travelomatix.com/webservices/index.php/rest/currecny_value_details?amount=1&from=")\(BASE_CURRENCY)\("&to=")\(toCurrency)"
        
        print("urlString : \(urlString)")
        
        // Create URL
        let url = URL(string: urlString)
        guard let requestUrl = url else { fatalError() }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                let result = VKAPIs.getObject(jsonString: dataString)
                
                if let responseDict = result as? [String: Any] {
                    
                    if let curr_value = responseDict["currency_value"] as? Float {
                        self.updateCurrencyValue(currency_value: curr_value)
                    }
                    
                    if let curr_value = responseDict["currency_value"] as? String {
                        self.updateCurrencyValue(currency_value: Float(curr_value) ?? 1.0)
                    }
                }
            }
        }
        task.resume()
        SwiftLoader.hide()
    }
    
    func updateCurrencyValue(currency_value: Float) {
        
        print("Before: \(String(describing: temp_currencyModel))")
        temp_currencyModel?.currency_value = currency_value
        print("After: \(String(describing: temp_currencyModel))")
        DCurrencyModel.saveCurrency(model: temp_currencyModel!)
        DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
    }
    
}


extension HomeVC : TopDestinationHotelProtocol {
    func selectBusesDest(index: Int) {
        
        var a : [String : String] = [:]
        
        a["state"] = trendingBuses_Array[index].from_bus_name
        a["city"] = trendingBuses_Array[index].from_bus_name
        a["id"] = trendingBuses_Array[index].from_station_id
        
        var b : [String : String] = [:]
        b["state"] = trendingBuses_Array[index].to_bus_name
        b["city"] = trendingBuses_Array[index].to_bus_name
        b["id"] = trendingBuses_Array[index].to_station_id
        
        let nextVC = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusHomeVC") as! BusHomeVC
        nextVC.sourceCity = a
        nextVC.destinationCity = b
        DBTravelModel.sourceCity = a
        DBTravelModel.destinationCity = b
        let navControl = getRootNavigation()
        navControl?.pushViewController(nextVC, animated: true)


    }
    

    func selectToDestHolidays(index: Int) {
        let nextVC = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHomeVC") as! HotelHomeVC
        nextVC.text = trendingHotel_Array[index].cityName! + "," + trendingHotel_Array[index].countryName!
        var a : [String: String] = [:]
        a["id"] = trendingHotel_Array[index].id
        a["city"] = trendingHotel_Array[index].cityName
        a["country"] = trendingHotel_Array[index].countryName
        DHTravelModel.hotelCity_dict = a
        let navControl = getRootNavigation()
        navControl?.pushViewController(nextVC, animated: true)
    }
    func selectFlightDest(index: Int) {
        let nextVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightHomeVC") as! FlightHomeVC
        let ss = trendingFlight_Array[index]
        let dep = ["airline_id": "",
                   "airline_code": ss.from_airport_code!,
                   "airline_city":ss.from_airport_name!]
        let dest = ["airline_id": "",
                    "airline_code": ss.to_airport_code!,
                    "airline_city":ss.to_airport_name!]
        nextVC.departAirline = dep
        nextVC.destinationAirline = dest
        DTravelModel.departAirline = dep
        DTravelModel.destinationAirline = dest
        let navControl = getRootNavigation()
        navControl?.pushViewController(nextVC, animated: true)

    }
    
    
}



extension String{
    //format hh:mm:ss or hh:mm or HH:mm
    var secondFromString : Int{
        var n = 3600
        return self.replacingOccurrences(of: "h", with: "").replacingOccurrences(of: "m", with: "").components(separatedBy: " ").reduce(0) {
            defer { n /= 60 }
            return $0 + (Int($1) ?? 0) * n
        }
    }
}



