//
//  TourseHomeVC.swift
//  Travelomatix
//
//  Created by Admin on 11/08/22.
//

import UIKit

class ToursHomeVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var tf_city: UITextField!
    @IBOutlet weak var lbl_allPackage: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_all: UILabel!
    @IBOutlet weak var view_header: UIView!
    
    //MARK: - Variables
    var packageTypeArray : [[String: Any]] = []
    var packageDurationArray : [Any] = []
    
    var holidayType: String?
    var holidayCity = ""
    var duration: String?
    
    var view_packageTypePop: ToursPackageView?
    //MARK: - Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .appColor
        addFrameAddView()
    }
    //MARK: -IBActions
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchLocationClicked(_ sender: Any) {
        
        let searchObj = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "SearchToursCitiesVC") as! SearchToursCitiesVC
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
    
    @IBAction func selectPackagesClicked(_ sender: Any) {
        print(packageTypeArray)
        self.view_packageTypePop?.packageType = .AllPackageType
        self.view_packageTypePop?.packageTypeArray = packageTypeArray
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.pkgTypDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    
    @IBAction func selectDurationClicked(_ sender: Any) {
        print(packageDurationArray)
        self.view_packageTypePop?.packageType = .PackageDuration
        self.view_packageTypePop?.packageDurationArray = packageDurationArray
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.pkgDurationDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    
    @IBAction func selectAllClicked(_ sender: Any) {
        
        self.view_packageTypePop?.packageType = .PackageAmount
        self.view_packageTypePop?.packageAmountArray = ["All","100.00-500.00","500.00-1000","1000-5000","5000 >"]
        self.view_packageTypePop?.displayInfo()
        self.view_packageTypePop?.allTypDelegate = self
        self.view_packageTypePop?.isHidden = false
        UIApplication.shared.keyWindow?.bringSubviewToFront(self.view_packageTypePop!)
    }
    
    @IBAction func searchAction(_ sender: Any) {

        if holidayCity == nil {
            self.view.makeToast(message: "Please Select Holiday Country")
        } else if holidayType == nil {
            print("holidayType is nil")
        } else if duration == nil {
            print("holidayDuration is nil")
        } else {
            var packageSearch: [String: Any] = ["city": holidayCity,
                                                "holiday_type": "",
                                                "duration": ""]
            
           // packageSearch["holiday_type"] = holidayType
           // packageSearch["city"] = holidayCity
            //packageSearch["duration"] = duration
            
            let hSearchObj = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "SearchedToursListVC") as! SearchedToursListVC
            hSearchObj.packageSearchParam =  packageSearch
            self.navigationController?.pushViewController(hSearchObj, animated: true)
           
            print(packageSearch)
        }
    }
    //MARK: - Methods & Functions
    func addFrameAddView() {
        
        tf_city.text = "All"
        
        view_header.viewShadow()
        
        self.view_packageTypePop = ToursPackageView.loadViewFromNib() as? ToursPackageView
        self.view_packageTypePop?.isHidden = true
        self.view_packageTypePop?.tag = 102
        UIApplication.shared.keyWindow?.addSubview(self.view_packageTypePop!)
        
        getAllPackage()
        getPackageDurations()
    }
}
//MARK: - Custom Delegates
extension ToursHomeVC: PackageTypeDelegate, PackageAmountDelegate, PackageDurationDelegate, searchToursCitiesDelegate {
    
    func searchCity(cityInfo: [String : Any]) {
        tf_city.text = cityInfo["country_name"]! as? String
        self.holidayCity = cityInfo["package_country"] as? String ?? ""
        
        //getAllPackage()
        //getPackageDurations()
    }
    func selectedDuration(duration: String) {
        
        self.lbl_duration.text = duration
        
        self.duration = duration
        if duration == "All Durations" {
            self.duration = ""
        }
    }
    
    func selectedAmount(pkgAmount: String) {
        self.lbl_all.text = pkgAmount
    }
    
    func selectedPackage(holidayTypId: String, holidayName: String) {
        
        self.holidayType = holidayTypId
        self.lbl_allPackage.text = holidayName
    }
}

//MARK: - API Call
extension ToursHomeVC  {
    
    func getAllPackage() -> Void {
//        SwiftLoader.show(animated: true)
        CommonLoader.shared.startLoader(in: view)

        VKAPIs.shared.getRequest(file: Tours_getPackageType, httpMethod: .POST, handler:
            { (resultObj, success, error) in
                if success == true {
                    print("All Package Types: \(String(describing: resultObj))")
                    if let result = resultObj as? [[String: Any]] {
                        
                        self.packageTypeArray = result
                        let elemtDict:[String: Any] = ["package_types_id": "",
                                                       "package_types_name":"All Package Types"]
                        self.packageTypeArray.insert(elemtDict, at: 0)
                        self.lbl_allPackage.text = self.packageTypeArray.first!["package_types_name"] as? String
                        self.holidayType = self.packageTypeArray.first!["package_types_id"] as? String
                        
                    } else {
                        if let message = resultObj as? [String: String] {
                            self.view.makeToast(message: message["message"]!)
                        }
                    }
                }
            })
    }
    
    func getPackageDurations()-> Void {
        
        VKAPIs.shared.getRequest(file: Tours_getPackageDurations, httpMethod: .POST, handler:
            { (resultObj, success, error) in
                if success == true {
                    print("All Package Durations: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        self.packageDurationArray = result["days"] as! [Any]
                        
                        self.packageDurationArray.insert("All Durations", at: 0)
                        
                        self.lbl_duration.text = self.packageDurationArray.first as? String
                        self.duration = (self.packageDurationArray.first as? String)!
                        print(result["days"] as Any)
                    }
                }
            })
//        SwiftLoader.hide()
        CommonLoader.shared.stopLoader()

    }

}
