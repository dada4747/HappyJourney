//
//  TransferSearchListVC.swift
//  CheapToGo
//
//  Created by Anand S on 20/11/19.
//  Copyright © 2019 Provab. All rights reserved.
//

import UIKit

class TransferSearchListVC: UIViewController {
    
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
    var transferList_array: [DTransferSearchItem] = []
    var transferList_array_Dummy: [DTransferSearchItem] = []
    var isFiltersApplied = false
    var isPriceOrderChanged = false
    var city_dict: [String: Any] = [:]
    
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
        //lbl_city.text = city_dict["city_name"] ?? ""
        txt_search.text = city_dict["city_name"] as? String
        // getting transfer info...
        DTransferSearchModel.clearAllTransferSearch_Information()
        searchTransfer_APIConnection()
    }
    
    func addDelegates() {
        
        coll_transferList.delegate = self
        coll_transferList.dataSource = self

        // register...
        coll_transferList.register(UINib.init(nibName: "TransferListCVCell", bundle: nil), forCellWithReuseIdentifier: "TransferListCVCell")
    }
    
    func reloadTransferList_Information() {
        
        transferList_array = DTransferSearchModel.transferCityList_Array
        transferList_array_Dummy = DTransferSearchModel.transferCityList_Array
        lbl_totalCount.text = String(transferList_array.count) + " Transfers found"
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
        let vc = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransfersFiltersViewController") as! TransfersFiltersViewController
        vc.delegate = self
        vc.transferList_array = self.transferList_array_Dummy
        vc.isPriceOrderChanged = self.isPriceOrderChanged
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func name_sortBtnClicked(_ sender: Any) {
        self.nameSort = !self.nameSort
        self.isFiltersApplied = true
        if nameSort{
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_name?.localizedCaseInsensitiveCompare($1.product_name ?? "") == ComparisonResult.orderedAscending })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
            
        }else{
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_name?.localizedCaseInsensitiveCompare($1.product_name ?? "") == ComparisonResult.orderedDescending })
            self.transferList_array_Dummy = sortedList
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
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.star_rating < $1.star_rating })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else{
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.star_rating > $1.star_rating })
            self.transferList_array_Dummy = sortedList
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
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_price < $1.product_price })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else{
            self.isPriceOrderChanged = true
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_price > $1.product_price })
            self.transferList_array_Dummy = sortedList
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
extension TransferSearchListVC : transferSearchCitiesDelegate {
    
    // MARK:- transferSearchCitiesDelegate
    func transferSearchCities_info(cityInfo: [String : Any]) {
        txt_search.text = cityInfo["city_name"] as? String
        city_dict = cityInfo
    }
}
extension TransferSearchListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //let width = (coll_transferList.frame.size.width/2) - 5
        //return CGSize(width:width, height: width + 40)
        let width = (coll_transferList.frame.size.width) - 5

        return CGSize(width:width, height: 360)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltersApplied == false{
            return transferList_array.count
        }else{
            return transferList_array_Dummy.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransferListCVCell", for: indexPath as IndexPath) as! TransferListCVCell
        
        //display information...
        if isFiltersApplied == false{
        cell.dispalyTransferList(model: transferList_array[indexPath.row])
        }else{
            cell.dispalyTransferList(model: transferList_array_Dummy[indexPath.row])
        }
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // move to details screen...
        //let transferDetVc = TransferStoryBoard.instantiateViewController(withIdentifier: "TransferDetailsVC") as! TransferDetailsVC
        let transferDetVc = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransferDetailsVC2") as! TransferDetailsVC2

        if isFiltersApplied == false{
            transferDetVc.transfer_dict = transferList_array[indexPath.row]
        }else{
            transferDetVc.transfer_dict = transferList_array_Dummy[indexPath.row]
        }
        self.navigationController?.pushViewController(transferDetVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
}


extension TransferSearchListVC {
    
    // MARK: - Api's
    func searchTransfer_APIConnection() -> Void {
        
        //SwiftLoader.show(animated: true)
        CommonLoader.shared.startLoader(in: view)
//        self.img_loader_popup.alpha = 1
        // params...
        let params: [String: String] = ["from": city_dict["city_name"] as! String,
                                        "destination_id": city_dict["id"] as! String,
                                        "from_date": "",
                                        "to_date": ""]
        
        let paramString: [String: String] = ["transfer_search": VKAPIs.getJSONString(object: params)]
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: TRANSFER_Search, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Search Transfer response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if result_dict["status"] as? Bool == true {
                        if let transfer_dict = result_dict["data"] as? [String: Any] {
                            DTransferSearchModel.createModels(result_dict: transfer_dict)
                        }
                    } else {
                        // error message...
                        if let message_str = result_dict["msg"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                        self.navigationController?.popViewController(animated: true)
                }
            } else {
                    print("Search Transfer error : \(String(describing: error?.localizedDescription))")
                    self.navigationController?.popViewController(animated: true)
                    self.view.makeToast(message: error?.localizedDescription ?? "")
                }
                //SwiftLoader.hide()
                CommonLoader.shared.stopLoader()

//                self.img_loader_popup.alpha = 0
                self.reloadTransferList_Information()
            }
        }
    }
}
extension TransferSearchListVC: TransfersFiltersApplied{
    
    func filtersApplied(isPriceRangeFilterApplied: Bool, min_Price: Double, max_Price: Double) {
        self.isFiltersApplied = true
        
        if isPriceRangeFilterApplied == true{
            ///Price Range
            let filteredArray = self.transferList_array_Dummy.filter{
                ($0.product_price ?? 0.0 >= min_Price) && ($0.product_price ?? 0 <= max_Price)
            }
            
            if filteredArray.count ?? 0 > 0 {
                self.transferList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }
        
        ///Price
        if DTransfersFiltersModel.lowest_Price == true{
            self.isPriceOrderChanged = false
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_price < $1.product_price })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Price == true {
            self.isPriceOrderChanged = true
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_price > $1.product_price })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        ///Star
        if DTransfersFiltersModel.lowest_Star == true{
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.star_rating < $1.star_rating })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Star == true {
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.star_rating > $1.star_rating })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        
        ///Name
        if DTransfersFiltersModel.lowest_Name == true{
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_name?.localizedCaseInsensitiveCompare($1.product_name ?? "") == ComparisonResult.orderedAscending })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }else if DTransfersFiltersModel.highest_Name == true {
            let sortedList = self.transferList_array_Dummy.sorted(by: { $0.product_name?.localizedCaseInsensitiveCompare($1.product_name ?? "") == ComparisonResult.orderedDescending })
            self.transferList_array_Dummy = sortedList
            DispatchQueue.main.async {
                self.coll_transferList.reloadData()
            }
        }
        
        ///New
        print(DTransfersFiltersModel.txt_Name!)
        if DTransfersFiltersModel.txt_Name != "" {
            let name = DTransfersFiltersModel.txt_Name
            print(name)
            print(transferList_array_Dummy.forEach({print($0.product_name)}))
            let filteredArray = self.transferList_array_Dummy.filter{
                ($0.product_name?.lowercased() ?? "" == name?.lowercased())
            }
            print(filteredArray.forEach({print($0.product_name!)}))
            print(filteredArray.count)
            if filteredArray.count > 0 {
                self.transferList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }
        
        if DTransfersFiltersModel.btn_Offer == true{
            let filteredArray = self.transferList_array_Dummy.filter{
                ($0.Promotion ?? false == true)
            }
            if filteredArray.count ?? 0 > 0 {
                self.transferList_array_Dummy = filteredArray
                DispatchQueue.main.async {
                    self.coll_transferList.reloadData()
                }
            }
        }
        
    }
    
    func resetFilters(){
        DTransfersFiltersModel.resetFilters()
        self.isFiltersApplied = false
        self.transferList_array_Dummy = self.transferList_array
        DispatchQueue.main.async {
            self.coll_transferList.reloadData()
        }
    }
}

