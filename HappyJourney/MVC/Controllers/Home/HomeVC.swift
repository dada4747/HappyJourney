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
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var img_currency: UIImageView!
    
    @IBOutlet var headerview: UIView!
    

//    @IBOutlet weak var lbl_greeting: UILabel!
    
    var topOffer_Array: [DCommonTopOfferItems] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
    var trendingBuses_Array: [DCommonTrendingBusesItem] = []
    var toHolidayDestinationArray: [DCommonTrendingPackageItem] = []
    var view_currencyPop: CurrencyView?
    var temp_currencyModel: DCurrencyItem?
    
    let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add views...
        
        
        homePageAdsList_APIConnection()
        getAllPromoCode_APIConnection()

    }
    override func viewWillAppear(_ animated: Bool) {
        addTblDelegates()
        addSideMenu()
//        tbl_ads.reloadData()
        addFrameAdd_views()
        
    }
    
    override func viewDidLayoutSubviews() {
        coll_tabModules.layoutIfNeeded()
//        coll_quickTab.layoutIfNeeded()
//        tbl_ads.reloadData()
    }
    // MARK: - Helper

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
        
        // register...
        coll_tabModules.register(UINib.init(nibName: "HomeModulesCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeModulesCVCell")
        
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
        toHolidayDestinationArray = DCommonModel.trendingPackage_Array

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
        if indexPath.row == 0 || indexPath.row == 2 {
            return 290
        } else if indexPath.row == 1 || indexPath.row == 4 {
            return 220
        } else if indexPath.row == 3 || indexPath.row == 6 {
            return 260
        } else if indexPath.row == 5 || indexPath.row == 7 {
            return 344
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5//8
    }
    /*
     cell no
     0,3,4,6 - hotel,food
     2,5,7, popular dest exp
     1
     
     
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                // cell creation...
        
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    }

            
            cell?.selectionStyle = .none
//            cell?.trendingHotel_Array = []
                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
                cell?.adsType = "Hotel"
                cell?.topDestinationsDelegate = self
            return cell!
            }
        else if indexPath.row == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "PremiumHotelTVCell") as? PremiumHotelTVCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "PremiumHotelTVCell", bundle: nil), forCellReuseIdentifier: "PremiumHotelTVCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "PremiumHotelTVCell") as? PremiumHotelTVCell
                    }

            
            
                cell?.selectionStyle = .none
//            cell?.topDestHotelDelegate = self
//                cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
//                cell?.adsType = "Flight"
            return cell!
        } else if indexPath.row == 2 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    }

            
            cell?.selectionStyle = .none
//            cell?.displayTopFlighDestination(trendingFlight_Array: <#T##[DCommonTrendingFlightItem]#>)
            cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
//            cell?.dispayTopPopularDestination()
//            cell?.trendingHotel_Array = []
//                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
                cell?.adsType = "Flight"
            
                cell?.topDestinationsDelegate = self
            return cell!
            }else if indexPath.row == 3 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        if cell == nil {
                            tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                        cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        }

                
                cell?.adsType = "Holidays"
                cell?.topHolidayDestination(trendingHolidayPackage: toHolidayDestinationArray)
             
                cell?.selectionStyle = .none

                    cell?.topDestinationsDelegate = self
                return cell!
            } else if indexPath.row == 4 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        if cell == nil {
                            tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                        cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        }

                
                cell?.selectionStyle = .none
                cell?.adsType = "Buses"

                cell?.displayTopBusesDestination(trendingBuses_Array: trendingBuses_Array)
    //            cell?.trendingHotel_Array = []
    //                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
//                    cell?.adsType = "POPULAR DESTINATION"
                
                    cell?.topDestinationsDelegate = self
                return cell!

                
                
//                    cell?.selectionStyle = .none
    //            cell?.topDestHotelDelegate = self
    //                cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
    //                cell?.adsType = "Flight"
                return cell!
            } else if indexPath.row == 7 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        if cell == nil {
                            tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                        cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                        }

                
                cell?.selectionStyle = .none
                cell?.dispayExperienceInSpotlight()
    //            cell?.trendingHotel_Array = []
    //                cell?.displayTopHotelDestination(dest_array: trendingHotel_Array)
                    cell?.adsType = "POPULAR DESTINATION"
                
    //                cell?.topDestHotelDelegate = self
                return cell!

                
                
                    cell?.selectionStyle = .none
    //            cell?.topDestHotelDelegate = self
    //                cell?.displayTopFlighDestination(trendingFlight_Array: trendingFlight_Array)
    //                cell?.adsType = "Flight"
                return cell!
            } else  {
            var cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "HomeAdsCell", bundle: nil), forCellReuseIdentifier: "HomeAdsCell")
                    cell = tableView.dequeueReusableCell(withIdentifier: "HomeAdsCell") as? HomeAdsCell
                    }
            cell?.topDestinationsDelegate = self
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
            return CGSize(width: 63, height: 89)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeModulesCVCell", for: indexPath as IndexPath) as! HomeModulesCVCell
//            cell.lbl_title.textColor = .white
            
            //display information...
            switch indexPath.row {
            case 0:
                cell.lbl_title.text = "FLIGHTS"
                cell.img_icon.image = UIImage.init(named: "flight_module")
//                cell.gradientView.startColor = UIColor(hexString: "#FFD438")
//                cell.gradientView.endColor = UIColor(hexString: "#FF895F")
                
            case 1:
                cell.lbl_title.text = "HOTELS"
                cell.img_icon.image = UIImage.init(named: "hotel_module")
                cell.gradientView.startColor = UIColor(hexString: "#FFD438")
                cell.gradientView.endColor = UIColor(hexString: "#FF895F")
                cell.gradientView.shadowColor = UIColor(hexString: "#FF895F")
                cell.gradientView.isShadow = true

            case 2:
                cell.lbl_title.text = "BUSES"
                cell.img_icon.image = UIImage.init(named: "bus_module")
                cell.gradientView.startColor = UIColor(hexString: "#24D5C3")
                cell.gradientView.endColor = UIColor(hexString: "#249CD5")
                cell.gradientView.shadowColor = UIColor(hexString: "#249CD5")
                cell.gradientView.isShadow = true

            case 3:
                cell.lbl_title.text = "TRANSFERS"
                cell.img_icon.image = UIImage.init(named: "transfer_module")
                cell.gradientView.startColor = UIColor(hexString: "#FF825F")
                cell.gradientView.endColor = UIColor(hexString: "#FF4C51")
                cell.gradientView.shadowColor = UIColor(hexString: "#FF4C51")
                cell.gradientView.isShadow = true

            
            case 4:
                cell.lbl_title.text = "CAR"
                cell.img_icon.image = UIImage.init(named: "car_module")
//                cell.gradientView.shadowColor = UIColor(hexString: "#249CD5")
                cell.gradientView.isShadow = true

               
            case 5:
                cell.lbl_title.text = "ACTIVITIES"
                cell.img_icon.image = UIImage.init(named: "activities_module")
                cell.gradientView.startColor = UIColor(hexString: "#FFD438")
                cell.gradientView.endColor = UIColor(hexString: "#FF895F")
                cell.gradientView.shadowColor = UIColor(hexString: "#FF895F")
                cell.gradientView.isShadow = true

            case 6:
                cell.lbl_title.text = "HOLIDAY"
                cell.img_icon.image = UIImage.init(named: "holiday_module")
                cell.gradientView.startColor = UIColor(hexString: "#24D5C3")
                cell.gradientView.endColor = UIColor(hexString: "#249CD5")
                cell.gradientView.shadowColor = UIColor(hexString: "#249CD5")
                cell.gradientView.isShadow = true


            case 7:
                cell.lbl_title.text = "BLOGS"
                cell.img_icon.image = UIImage.init(named: "blog_module")
                cell.gradientView.startColor = UIColor(hexString: "#FF825F")
                cell.gradientView.endColor = UIColor(hexString: "#FF4C51")
                cell.gradientView.shadowColor = UIColor(hexString: "#FF4C51")
                cell.gradientView.isShadow = true


            default: break
                
            }
            
            return cell
            
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
//            view.makeToast(message: "Coming soon")
            let nextVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightHomeVC") as! FlightHomeVC
            let navControl = getRootNavigation()

            navControl?.pushViewController(nextVC, animated: true)
            break
        case 1:
            let nextVC = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHomeVC") as! HotelHomeVC
            let navControl = getRootNavigation()
            
            navControl?.pushViewController(nextVC, animated: true)
        case 2:
//            view.makeToast(message: "Coming soon")
            let nextVC = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusHomeVC") as! BusHomeVC
            let navControl = getRootNavigation()
            navControl?.pushViewController(nextVC, animated: true)
            break
        case 3:
//            view.makeToast(message: "Coming soon")

            let nextVC = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransferSearchVC") as! TransferSearchVC
            let navControl = getRootNavigation()

            navControl?.pushViewController(nextVC, animated: true)
            break
        case 4:
//            view.makeToast(message: "Coming soon")

            let vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarSearchViewController") as! CarSearchViewController
            let navControl = getRootNavigation()
            navControl?.pushViewController(vc, animated: true)
            break
        case 5:
//            view.makeToast(message: "Coming soon")

            let vc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesSearchVC") as! ActivitiesSearchVC
            let navControl = getRootNavigation()
            navControl?.pushViewController(vc, animated: true)
            break
        case 6:
//            view.makeToast(message: "Coming soon")

            let nextVC = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "ToursHomeVC") as! ToursHomeVC
            let navControl = getRootNavigation()
            navControl?.pushViewController(nextVC, animated: true)
            break
        case 7:
            if let url = URL(string: "https://alphacentaurux.com"), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }
//            let pay_vc = STORYBOARD_MAIN.instantiateViewController(withIdentifier: "HistoryVoucherVC") as! HistoryVoucherVC
//            pay_vc.payment_url = "https://alphacentaurux.com"
//            pay_vc.download_url = "downloadUrl"
//            pay_vc.booking_id = "id"
//            self.navigationController?.pushViewController(pay_vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 20
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
            } else {

            // move to my bookings...
                let bookVC = self.storyboard?.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
//                bookVC.from = "menu"
            navControl?.pushViewController(bookVC, animated: true)
            }
        }else if section_name == "Hotels"{
            let nextVC = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHomeVC") as! HotelHomeVC
            let navControl = getRootNavigation()
            
            navControl?.pushViewController(nextVC, animated: true)
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
        CommonLoader.shared.startLoader(in: view)
        
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
            CommonLoader.shared.stopLoader()
        }
    }
    
    func displayCurrency() {
        
        temp_currencyModel = DCurrencyModel.currency_saved
        let code = DCurrencyModel.currency_saved?.currency_country ?? "USD"
        self.getCurrencyValue_APIConnection(toCurrency: code)
        lbl_currency.text = code
        img_currency.image = UIImage.init(named: String.init(format: "%@.png",code))
//        tbl_ads.reloadData()
//        displayAds()
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
        
        CommonLoader.shared.startLoader(in: view)
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
            CommonLoader.shared.stopLoader()
        }
    }
    
    func getAllPromoCode_APIConnection() -> Void {
        
        CommonLoader.shared.startLoader(in: view)
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
            CommonLoader.shared.stopLoader()
        }
    }
    
    func getCurrencyValue_APIConnection(toCurrency: String) -> Void {
        
        CommonLoader.shared.startLoader(in: view)
        
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
        CommonLoader.shared.stopLoader()
    }
    
    func updateCurrencyValue(currency_value: Float) {
        
        print("Before: \(String(describing: temp_currencyModel))")
        temp_currencyModel?.currency_value = currency_value
        print("After: \(String(describing: temp_currencyModel))")
        DCurrencyModel.saveCurrency(model: temp_currencyModel!)
        DCurrencyModel.currency_saved = DCurrencyModel.retriveCurrency()
        displayAds()
    }
    
}


extension HomeVC : TopDestinationsProtocol {
    
  
    
    
    
    func selectTopHolidays(index: Int) {
//          let model = toHolidayDestinationArray[index]
//        
////        view.makeToast(message: "Coming soon")
//        let vc = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "NewToursDetailVC") as! ToursDetailVC
//        vc.packageID =  model.package_id //packageArray[indexPath.row].packageID
//        let navControl = getRootNavigation()
//        navControl?.pushViewController(vc, animated: true)
////        print(packageSearch)
    }
    //Bus
    func selectBusesDest(index: Int) {
        
//        var a : [String : String] = [:]
//
//        a["state"] = ""//trendingBuses_Array[index].from_bus_name
//        a["city"] = ""//trendingBuses_Array[index].from_bus_name
//        a["id"] = ""//trendingBuses_Array[index].from_station_id
//
//        var b : [String : String] = [:]
//        b["state"] = trendingBuses_Array[index].state
//        b["city"] = trendingBuses_Array[index].from_bus_name
//        b["id"] = trendingBuses_Array[index].to_station_id
//
//        let nextVC = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusHomeVC") as! BusHomeVC
//        nextVC.sourceCity = a
//        nextVC.destinationCity = b
//        DBTravelModel.sourceCity = a
//        DBTravelModel.destinationCity = b
//        let navControl = getRootNavigation()
//        navControl?.pushViewController(nextVC, animated: true)


    }
    

    func selectToDestHotels(index: Int) {
        //hotel
//        let nextVC = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelHomeVC") as! HotelHomeVC
//        nextVC.text = trendingHotel_Array[index].cityName! + "," + trendingHotel_Array[index].countryName!
//        var a : [String: String] = [:]
//        a["id"] = trendingHotel_Array[index].id
//        a["city"] = trendingHotel_Array[index].cityName
//        a["country"] = trendingHotel_Array[index].countryName
//        DHTravelModel.hotelCity_dict = a
//        let navControl = getRootNavigation()
//        navControl?.pushViewController(nextVC, animated: true)
    }
    //flight
   
    
    func selectFlightDest(index: Int) {
        
//        let nextVC = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightHomeVC") as! FlightHomeVC
//        let ss = trendingFlight_Array[index]
//        let dep = ["airline_id": "",
//                   "airline_code": ss.from_airport_code!,
//                   "airline_city":ss.from_airport_name!]
//        let dest = ["airline_id": "",
//                    "airline_code": ss.to_airport_code!,
//                    "airline_city":ss.to_airport_name!]
//        nextVC.departAirline = dep
//        nextVC.destinationAirline = dest
//        DTravelModel.departAirline = dep
//        DTravelModel.destinationAirline = dest
//        let navControl = getRootNavigation()
//        navControl?.pushViewController(nextVC, animated: true)

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



