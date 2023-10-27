//
//  ActivitiesSearchVC.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 06/08/21.
//

import UIKit

class ActivitiesSearchVC: UIViewController {
    
    // Outlets...
    @IBOutlet weak var txt_city: UITextField!
    
    // Localization...
    @IBOutlet weak var lbl_transferLoc: UILabel!
    @IBOutlet weak var lbl_enterLoc: UILabel!
    @IBOutlet weak var coll_BestTransfer: UICollectionView!
    @IBOutlet weak var coll_PerfectTransferPackages: UICollectionView!

    var city_dict:[String: Any] = [:]
    var search_id: Int? = 0
    var cityID: Int? = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        coll_BestTransfer.register(UINib.init(nibName: "BestTransferCVCell", bundle: nil), forCellWithReuseIdentifier: "BestTransferCVCell")
        coll_PerfectTransferPackages.register(UINib.init(nibName: "PerfectPackagesCVCell", bundle: nil), forCellWithReuseIdentifier: "PerfectPackagesCVCell")

    }
    func bestTransferSearchAPICall(destinationId: String, destinationName: String){
        let cityDict:[String: String] = ["city_name": destinationName, "id": destinationId]
        
        let listObj = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesSearchListVC") as! ActivitiesSearchListVC
        listObj.city_dict = cityDict
        listObj.search_id = self.search_id ?? 0
        listObj.cityID = Int(destinationId) ?? 0
        self.navigationController?.pushViewController(listObj, animated: true)
    }
    
    func getSearchID(cityName: String, cityID: String){
        
        CommonLoader.shared.startLoader(in: view)
        
        var apiName = Activities_pre_sight_seen_search
        apiName += "?from=\(cityName)&destination_id=\(cityID)&category_id=0&from_date&to_date"
        // calling api...
        VKAPIs.shared.getRequest(file:apiName, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Get_City_List success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        self.search_id = result["search_id"] as? Int
                        self.bestTransferSearchAPICall(destinationId: cityID, destinationName: cityName)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_Get_City_List formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
        }
    }
    

    func pre_sight_seen_search_APICall(cityName: String, cityID: Int){
        
        CommonLoader.shared.startLoader(in: view)
        
        var apiName = Activities_pre_sight_seen_search
        apiName += "?from=\(cityName)&destination_id=\(cityID)&category_id=0&from_date&to_date"
        // calling api...
        VKAPIs.shared.getRequest(file:apiName, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Get_City_List success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        
                        self.search_id = result["search_id"] as? Int
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_Get_City_List formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
        }
    }
    
    // MARK:- ButtonAciton
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func citySearchBtnClicked(_ sender: Any) {
        
        let searchObj = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesSearchCitiesVC") as! ActivitiesSearchCitiesVC
        searchObj.delegate = self
        self.navigationController?.pushViewController(searchObj, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        if city_dict.isEmpty == true {
            view.makeToast(message: "Please enter city")
        } else {
            let listObj = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesSearchListVC") as! ActivitiesSearchListVC
            listObj.city_dict = city_dict
            listObj.search_id = self.search_id ?? 0
            listObj.cityID = self.cityID ?? 0
            self.navigationController?.pushViewController(listObj, animated: true)
        }
    }
    
}

//extension ActivitiesSearchVC : transferSearchCitiesDelegate1 {
//
//    // MARK:- transferSearchCitiesDelegate
//    func transferSearchCities_info(cityInfo: [String : String]) {
//        txt_city.text = cityInfo["city_name"] ?? ""
//        city_dict = cityInfo
//        if let id = Int(cityInfo["id"] ?? "") {
//            self.cityID = id
//            self.pre_sight_seen_search_APICall(cityName: cityInfo["city_name"] ?? "", cityID: id)
//        }
//    }
//}
extension ActivitiesSearchVC : transferSearchCitiesDelegate1 {
    
    // MARK:- transferSearchCitiesDelegate
    internal func transferSearchCities_info(cityInfo: [String : Any]) {
        txt_city.text = cityInfo["value"] as? String
        city_dict = cityInfo
        if let id = Int(cityInfo["id"] as! String ) {
            self.cityID = id
            self.pre_sight_seen_search_APICall(cityName: cityInfo["value"] as! String , cityID: id)
        }
    }
}
extension ActivitiesSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coll_BestTransfer{
            return DCommonModel.trendingActivities_Array.count
        }
        else{
            return  DCommonModel.perfectActivities_Array.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coll_BestTransfer{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestTransferCVCell", for: indexPath as IndexPath) as! BestTransferCVCell
        cell.displayData(obj: DCommonModel.trendingActivities_Array[indexPath.row])
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PerfectPackagesCVCell", for: indexPath as IndexPath) as! PerfectPackagesCVCell
            cell.displayData(obj: DCommonModel.perfectActivities_Array[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coll_BestTransfer{
            let model = DCommonModel.trendingActivities_Array[indexPath.row]
            self.getSearchID(cityName: model.destination_name ?? "", cityID: model.destination_id ?? "")
        }else{
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 170, height: 135)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
}
