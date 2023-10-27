//
//  ActivitiesSearchListVC.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 06/08/21.
//

import UIKit

class ActivitiesSearchListVC: UIViewController {
    
    // Outlets....
    @IBOutlet weak var lbl_city: UILabel!
    @IBOutlet weak var lbl_totalCount: UILabel!

    @IBOutlet weak var coll_transferList: UICollectionView!
    
//    @IBOutlet weak var img_loader: UIImageView!
//    @IBOutlet weak var img_loader_popup: UIView!

    @IBOutlet weak var view_name: UIView!
    @IBOutlet weak var view_rating: UIView!
    @IBOutlet weak var view_price: UIView!

    @IBOutlet weak var img_name: UIImageView!
    @IBOutlet weak var img_rating: UIImageView!
    @IBOutlet weak var img_price: UIImageView!

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_price: UILabel!

    @IBOutlet weak var view_search: UIView!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var txt_search: UITextField!

    @IBOutlet weak var view_HContraint_Search: NSLayoutConstraint!
    // MARK:- Variables
    var activitiesList_array: [DActivitySearchItem] = []
    var activitiesList_array_Dummy: [DActivitySearchItem] = []
    var isFiltersApplied = false
    var isPriceOrderChanged = false
    var city_dict: [String: Any] = [:]
    var search_id: Int = 0
    var cityID: Int = 0
    
    var nameSort = false
    var ratingSort = false
    var priceSort = false

    var modifySearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.img_loader_popup.frame = self.view.frame
//        self.view.addSubview(img_loader_popup)
//        img_loader_popup.alpha = 0
//
//        img_loader.image = UIImage.gifImageWithName("alkhaleej-loader")
        displayInformation()
        initSearchView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- Helpers
    func displayInformation() {
        
        addDelegates()
        lbl_city.text = "Modify Search"//city_dict["value"]  as! String
        txt_search.text = city_dict["value"]  as! String
        
        // getting activities info...
        DActivitiesSearchModel.clearAllSearch_Information()
        searchActivities_APIConnection()
    }
    
    func addDelegates() {
        
        coll_transferList.delegate = self
        coll_transferList.dataSource = self

        // register...
        coll_transferList.register(UINib.init(nibName: "ActivityListCVCell", bundle: nil), forCellWithReuseIdentifier: "ActivityListCVCell")

    }
    
    func reloadTransferList_Information() {
        
        activitiesList_array = DActivitiesSearchModel.activitiesCityList_Array
        activitiesList_array_Dummy = DActivitiesSearchModel.activitiesCityList_Array
        lbl_totalCount.text = String(activitiesList_array.count) + " Activities found"
        modifySearch = false
        initSearchView()

        coll_transferList.reloadData()
    }
    
    func initSearchView(){
        if modifySearch == false{
            self.view_search.alpha = 0
            self.view_HContraint_Search.constant = 0
        }else{
            self.view_search.alpha = 1
            self.view_HContraint_Search.constant = 150
            
        }
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        let vc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesFiltersViewController") as! ActivitiesFiltersViewController
        vc.delegate = self
        vc.transferList_array = self.activitiesList_array_Dummy
        vc.isPriceOrderChanged = self.isPriceOrderChanged
        vc.cityID = self.cityID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func name_sortBtnClicked(_ sender: Any) {
        self.nameSort = !self.nameSort
        self.isFiltersApplied = true
        if nameSort{
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.ProductName?.localizedCaseInsensitiveCompare($1.ProductName ?? "") == ComparisonResult.orderedAscending })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
            
        }else{
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.ProductName?.localizedCaseInsensitiveCompare($1.ProductName ?? "") == ComparisonResult.orderedDescending })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        self.view_name.layer.borderColor = UIColor.white.cgColor
        self.view_name.layer.borderWidth = 1
        self.view_name.backgroundColor = .clear
        self.lbl_name.textColor = UIColor.white
        self.img_name.tintColor = UIColor.white
        
        self.view_rating.layer.borderColor = UIColor.white.cgColor
        self.view_rating.backgroundColor = .white
        self.lbl_rating.textColor = UIColor.black
        self.img_rating.tintColor = UIColor.black
        
        self.view_price.layer.borderColor = UIColor.white.cgColor
        self.view_price.backgroundColor = .white
        self.lbl_price.textColor = UIColor.black
        self.img_price.tintColor = UIColor.black

    }
    
    @IBAction func rating_sortBtnClicked(_ sender: Any) {
        self.ratingSort = !self.ratingSort
        self.isFiltersApplied = true
        if ratingSort {
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.StarRating ?? 0 < $1.StarRating ?? 0 })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else{
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.StarRating ?? 0 > $1.StarRating ?? 0})
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        self.view_name.layer.borderColor = UIColor.white.cgColor
        self.view_name.backgroundColor = .white
        self.lbl_name.textColor = UIColor.black
        self.img_name.tintColor = UIColor.black
        
        self.view_rating.layer.borderColor = UIColor.white.cgColor
        self.view_rating.layer.borderWidth = 1
        self.view_rating.backgroundColor = .clear
        self.lbl_rating.textColor = UIColor.white
        self.img_rating.tintColor = UIColor.white

        
        self.view_price.layer.borderColor = UIColor.white.cgColor
        self.view_price.backgroundColor = .white
        self.lbl_price.textColor = UIColor.black
        self.img_price.tintColor = UIColor.black

    }
    
    @IBAction func price_sortBtnClicked(_ sender: Any) {
        self.priceSort = !self.priceSort
        self.isFiltersApplied = true
        if priceSort{
            self.isPriceOrderChanged = false
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.TotalDisplayFare < $1.TotalDisplayFare })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else{
            self.isPriceOrderChanged = true
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.TotalDisplayFare > $1.TotalDisplayFare })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        self.view_name.layer.borderColor = UIColor.white.cgColor
        self.view_name.backgroundColor = .white
        self.lbl_name.textColor = UIColor.black
        self.img_name.tintColor = UIColor.black

        self.view_rating.layer.borderColor = UIColor.white.cgColor
        self.view_rating.backgroundColor = .white
        self.lbl_rating.textColor = UIColor.black
        self.img_rating.tintColor = UIColor.black

        self.view_price.layer.borderColor = UIColor.white.cgColor
        self.view_price.layer.borderWidth = 1
        self.view_price.backgroundColor = .clear
        self.lbl_price.textColor = UIColor.white
        self.img_price.tintColor = UIColor.white

    }
    @IBAction func modifySearchBtnClicked(_ sender: Any) {
        modifySearch = !modifySearch
        initSearchView()
    }
    
    @IBAction func citySearchBtnClicked(_ sender: Any) {
        
        let searchObj = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransferSearchCititesVC") as! TransferSearchCititesVC
        searchObj.delegate = self
        self.navigationController?.pushViewController(searchObj, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
        
//        let listObj = TransferStoryBoard.instantiateViewController(withIdentifier: "TransferSearchListVC") as! TransferSearchListVC
//        listObj.city_dict = city_dict
//        self.navigationController?.pushViewController(listObj, animated: true)
        displayInformation()
    }
    
    

    
}
extension ActivitiesSearchListVC : transferSearchCitiesDelegate {
    
    // MARK:- transferSearchCitiesDelegate
    func transferSearchCities_info(cityInfo: [String : Any]) {
        txt_search.text = cityInfo["value"] as? String
        city_dict = cityInfo
        if let id = Int(cityInfo["id"] as! String ) {
            self.cityID = id
            self.pre_sight_seen_search_APICall(cityName: cityInfo["value"] as! String , cityID: id)
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
                        
                        self.search_id = result["search_id"] as? Int ?? 0
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
}

extension ActivitiesSearchListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let width = (coll_transferList.frame.size.width/2) - 5
        //return CGSize(width:width, height: width + 40)

        let width = (coll_transferList.frame.size.width) - 5
        return CGSize(width:width, height: 350)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltersApplied == false{
            return activitiesList_array.count
        }else{
            return activitiesList_array_Dummy.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityListCVCell", for: indexPath as IndexPath) as! ActivityListCVCell
        
        //display information...
        if isFiltersApplied == false{
        cell.dispalyTransferList(model: activitiesList_array[indexPath.row])
        }else{
            cell.dispalyTransferList(model: activitiesList_array_Dummy[indexPath.row])
        }
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // move to details screen...
        //let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesDetailsViewController") as! ActivitiesDetailsViewController
        let transferDetVc = ActivitiesStoryBoard.instantiateViewController(withIdentifier: "ActivitiesDetailsVC2") as! ActivitiesDetailsVC2

        if isFiltersApplied == false{
            transferDetVc.transfer_dict = activitiesList_array[indexPath.row]
        }else{
            transferDetVc.transfer_dict = activitiesList_array_Dummy[indexPath.row]
        }
        transferDetVc.search_id = self.search_id
        self.navigationController?.pushViewController(transferDetVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
}


extension ActivitiesSearchListVC {
    
    // MARK: - Api's
    func searchActivities_APIConnection() -> Void {
        var apiName = Activities_sightseeing_list
        apiName += "?booking_source=PTBSID0000000006&search_id=\(self.search_id)&op=load"
        CommonLoader.shared.startLoader(in: view)
//        self.img_loader_popup.alpha = 1
        // calling api...
        VKAPIs.shared.getRequest(file:apiName, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_sightseeing_list success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        DActivitiesSearchModel.createModels(result_dict: result)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_sightseeing_list formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
//            self.img_loader_popup.alpha = 0
            self.reloadTransferList_Information()
        }
    }
}
extension ActivitiesSearchListVC: TransfersFiltersApplied1{
    
    func filtersApplied(isPriceRangeFilterApplied: Bool, min_Price: Double, max_Price: Double, activitiesTypeArr: [ActivitiesTypeModel]) {
        self.isFiltersApplied = true

        if isPriceRangeFilterApplied == true{
            ///Price Range
            let filteredArray = self.activitiesList_array_Dummy.filter{
                ($0.TotalDisplayFare ?? 0.0 >= min_Price) && ($0.TotalDisplayFare ?? 0 <= max_Price)
            }

            if filteredArray.count ?? 0 > 0 {
                self.activitiesList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }

        ///Price
        if DTransfersFiltersModel.lowest_Price == true{
            self.isPriceOrderChanged = false
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.TotalDisplayFare < $1.TotalDisplayFare })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Price == true {
            self.isPriceOrderChanged = true
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.TotalDisplayFare > $1.TotalDisplayFare })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }

        ///Star
        if DTransfersFiltersModel.lowest_Star == true{
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.StarRating ?? 0 < $1.StarRating ?? 0 })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Star == true {
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.StarRating ?? 0 > $1.StarRating ?? 0 })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }


        ///Name
        if DTransfersFiltersModel.lowest_Name == true{
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.ProductName?.localizedCaseInsensitiveCompare($1.ProductName ?? "") == ComparisonResult.orderedAscending })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Name == true {
            let sortedList = self.activitiesList_array_Dummy.sorted(by: { $0.ProductName?.localizedCaseInsensitiveCompare($1.ProductName ?? "") == ComparisonResult.orderedDescending })
            self.activitiesList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        ///New
        if DTransfersFiltersModel.txt_Name != "" {
            let name = DTransfersFiltersModel.txt_Name
            let filteredArray = self.activitiesList_array_Dummy.filter{
                ($0.ProductName ?? "" == name)
            }
            if filteredArray.count ?? 0 > 0 {
                self.activitiesList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }
        
        if DTransfersFiltersModel.btn_Offer == true {
            let filteredArray = self.activitiesList_array_Dummy.filter{
                ($0.Promotion ?? false == true)
            }
            if filteredArray.count > 0 {
                self.activitiesList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }
        
        ///activities type
        
        if activitiesTypeArr.count > 0{
            let filterapplied = activitiesTypeArr.filter {$0.isSelected == true}
            if filterapplied.count > 0{
                var finalFilteredArray : [DActivitySearchItem] = []
                for item in filterapplied{
                    for obj in activitiesList_array_Dummy{
                        if obj.Cat_Ids.contains(item.category_id ?? 0){
                            finalFilteredArray.append(obj)
                        }
                    }
                }
                if finalFilteredArray.count > 0{
                    activitiesList_array_Dummy = finalFilteredArray
                    DispatchQueue.main.async {
                        self.coll_transferList.reloadData()
                    }
                    
                }
            }
        }

    }
    
    func resetFilters(){
        DActivitiesFiltersModel.resetFilters()
        self.isFiltersApplied = false
        self.activitiesList_array_Dummy = self.activitiesList_array
        DispatchQueue.main.async {
            self.coll_transferList.reloadData()
        }
    }
}

