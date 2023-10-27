//
//  CarsListViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 12/07/21.
//

import UIKit

class CarsListViewController: UIViewController {
    
    @IBOutlet weak var tbl_carsList: UITableView!
    @IBOutlet weak var tbl_cancellationPolicy: UITableView!
    @IBOutlet weak var hei_tbl_cancellationPolicy: NSLayoutConstraint!

    @IBOutlet weak var view_cancellationPolicy_Popup: UIView!

    var carSearchMainModel: CarSearchMainModel?
    var carSearchMainModel_Dummy: CarSearchMainModel?
    var isFiltersApplied = false
    
    var cancellationPolicy: [CancellationPolicy_Model] = [CancellationPolicy_Model]()
    var carDetailsModel: CarDetailsModel?

    ///Filters
    var suppliersArray: [Car_FiltersModel] = [Car_FiltersModel]()
    var auto_Manual_Array: [Car_FiltersModel] = [Car_FiltersModel]()
    var ac_NonAc_Array: [Car_FiltersModel] = [Car_FiltersModel]()
    var packageArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var doorCountArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var passangerCountArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var carCategoryArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var carSizeArray:[Car_FiltersModel] = [Car_FiltersModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view_cancellationPolicy_Popup.frame = self.view.frame
        self.view.addSubview(view_cancellationPolicy_Popup)
        view_cancellationPolicy_Popup.isHidden = true
    }
    
    func carDetailsAPICall(index: Int){
        var params: [String: String] = [:]
        if isFiltersApplied == true{
            params = ["search_id": self.carSearchMainModel_Dummy?.search_id ?? "", "ResultIndex": self.carSearchMainModel_Dummy?.CarsList[index].ResultToken ?? "", "booking_source": self.carSearchMainModel_Dummy?.booking_source ?? "", "op": "get_details"]
        }else{
            params = ["search_id": self.carSearchMainModel?.search_id ?? "", "ResultIndex": self.carSearchMainModel?.CarsList[index].ResultToken ?? "", "booking_source": self.carSearchMainModel?.booking_source ?? "", "op": "get_details"]
        }
        CommonLoader.shared.startLoader(in: view)
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: params, file: car_Details, httpMethod: .POST)
        { (resultObj, success, error) in

            // success status...
            if success == true {
                print("Car Details success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    
                    if let data = result["data"] as? [String: Any] {
                        
                        self.carDetailsModel = CarDetailsModel(dict: data)
                        
                        let vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarDetailsViewController") as! CarDetailsViewController
                        vc.carDetailsModel = self.carDetailsModel
                        vc.selectedCarIndex = index
                        if self.isFiltersApplied == true{
                            vc.carSearchMainModel = self.carSearchMainModel_Dummy
                        }else{
                            vc.carSearchMainModel = self.carSearchMainModel
                        }
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                    
                    
                }
                

            } else {
                print("Hotel search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
                
            }
            CommonLoader.shared.stopLoader()
        }

    }
    

    
    
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        let vc = CARTSTORYBOARD.instantiateViewController(withIdentifier: "CarFiltersViewController") as! CarFiltersViewController
        vc.carSearchMainModel = self.carSearchMainModel
        vc.isFiltersApplied = self.isFiltersApplied
        vc.suppliersArray = self.suppliersArray
        vc.auto_Manual_Array = self.auto_Manual_Array
        vc.ac_NonAc_Array = self.ac_NonAc_Array
        vc.packageArray = self.packageArray
        vc.doorCountArray = self.doorCountArray
        vc.passangerCountArray = self.passangerCountArray
        vc.carCategoryArray = self.carCategoryArray
        vc.carSizeArray = self.carSizeArray
        vc.delegate = self
        
        self.carSearchMainModel_Dummy = self.carSearchMainModel ///Passing original data for each time applying filters to reset 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func closeCancellationPolicyButtonClicked(_ sender: UIButton) {
        view_cancellationPolicy_Popup.isHidden = true
    }
    
    

}
extension CarsListViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return carSearchMainModel?.CarsList.count ?? 0
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_cancellationPolicy{
            return cancellationPolicy.count
        }else{
            if isFiltersApplied == true{
                return carSearchMainModel_Dummy?.CarsList.count ?? 0
            }else{
                return carSearchMainModel?.CarsList.count ?? 0
            }
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_cancellationPolicy {
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "CancellationPolicyCell") as? CancellationPolicyCell
            if cell == nil {
                tableView.register(UINib(nibName: "CancellationPolicyCell", bundle: nil), forCellReuseIdentifier: "CancellationPolicyCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CancellationPolicyCell") as? CancellationPolicyCell
            }
            
            cell?.displayContent(obj: cancellationPolicy[indexPath.row])
            cell?.selectionStyle = .none
            return cell!
        }
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "CarsListCell") as? CarsListCell
        if cell == nil {
            tableView.register(UINib(nibName: "CarsListCell", bundle: nil), forCellReuseIdentifier: "CarsListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CarsListCell") as? CarsListCell
        }
        if isFiltersApplied == true{
            if carSearchMainModel_Dummy?.CarsList[indexPath.row].isViewMoreClicked == true{
                cell?.hei_moreDetialsConstraint.constant = cell?.tbl_silverPackage.contentSize.height ?? 0
                //            let count = carSearchMainModel?.CarsList[indexPath.row].PricedCoverage.count ?? 0
                //            cell?.hei_moreDetialsConstraint.constant = CGFloat(84 + (90 * count))
                cell?.view_more.alpha = 1
            }else{
                cell?.hei_moreDetialsConstraint.constant = 0
                cell?.view_more.alpha = 0
            }
            
            cell?.displayData(obj: (carSearchMainModel_Dummy?.CarsList[indexPath.row])!)
        }else{
            if carSearchMainModel?.CarsList[indexPath.row].isViewMoreClicked == true{
                cell?.hei_moreDetialsConstraint.constant = cell?.tbl_silverPackage.contentSize.height ?? 0
                //            let count = carSearchMainModel?.CarsList[indexPath.row].PricedCoverage.count ?? 0
                //            cell?.hei_moreDetialsConstraint.constant = CGFloat(84 + (90 * count))
                cell?.view_more.alpha = 1
            }else{
                cell?.hei_moreDetialsConstraint.constant = 0
                cell?.view_more.alpha = 0
            }
            
            cell?.displayData(obj: (carSearchMainModel?.CarsList[indexPath.row])!)
        }
        cell?.btn_moreDetails.addTarget(self, action: #selector(moreClicked), for: .touchUpInside)
        cell?.btn_moreDetails.tag = indexPath.row
        
        cell?.btn_cancelPolicy.addTarget(self, action: #selector(cancellationPolicyClicked), for: .touchUpInside)
        cell?.btn_cancelPolicy.tag = indexPath.row

        cell?.btn_book.addTarget(self, action: #selector(bookClicked), for: .touchUpInside)
        cell?.btn_book.tag = indexPath.row

        
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @objc func moreClicked(sender:UIButton){
        if isFiltersApplied == true{
            if carSearchMainModel_Dummy?.CarsList[sender.tag].PricedCoverage.count ?? 0 > 0{
                if (carSearchMainModel_Dummy?.CarsList[sender.tag].isViewMoreClicked == true){
                    carSearchMainModel_Dummy?.CarsList[sender.tag].isViewMoreClicked = false
                }else{
                    carSearchMainModel_Dummy?.CarsList[sender.tag].isViewMoreClicked = true
                }
            }
        }else{
            if carSearchMainModel?.CarsList[sender.tag].PricedCoverage.count ?? 0 > 0{
                if (carSearchMainModel?.CarsList[sender.tag].isViewMoreClicked == true){
                    carSearchMainModel?.CarsList[sender.tag].isViewMoreClicked = false
                }else{
                    carSearchMainModel?.CarsList[sender.tag].isViewMoreClicked = true
                }
            }
        }
        DispatchQueue.main.async {
            self.tbl_carsList.reloadData()
        }
    }
    
    @objc func cancellationPolicyClicked(sender:UIButton){
        self.view_cancellationPolicy_Popup.isHidden = false
        if isFiltersApplied == true{
            self.cancellationPolicy = carSearchMainModel_Dummy?.CarsList[sender.tag].CancellationPolicy ?? []
            self.hei_tbl_cancellationPolicy.constant = CGFloat(self.cancellationPolicy.count * 50)

        }else{
            self.cancellationPolicy = carSearchMainModel?.CarsList[sender.tag].CancellationPolicy ?? []
            self.hei_tbl_cancellationPolicy.constant = CGFloat(self.cancellationPolicy.count * 50)
        }
            DispatchQueue.main.async {
            self.tbl_cancellationPolicy.reloadData()
        }
    }
    
    @objc func bookClicked(sender:UIButton){
        DispatchQueue.main.async {
            self.carDetailsAPICall(index: sender.tag)
        }
    }
}
extension CarsListViewController:FilterApplied {
    func clearAppliedFilters() {
        self.isFiltersApplied = false
        tbl_carsList.reloadData()
    }
    
    func filterApplied(minPrice: Double, maxPrice: Double, suppliersArr: [Car_FiltersModel], auto_manualArr: [Car_FiltersModel], ac_NonAcArr: [Car_FiltersModel], packageArr: [Car_FiltersModel], doorCountArr: [Car_FiltersModel], passangerCountArr: [Car_FiltersModel], carCategoryArr: [Car_FiltersModel], carSizeArr: [Car_FiltersModel]) {
        
        self.isFiltersApplied = true
        self.suppliersArray = suppliersArr
        self.auto_Manual_Array = auto_manualArr
        self.ac_NonAc_Array = ac_NonAcArr
        self.packageArray = packageArr
        self.doorCountArray = doorCountArr
        self.passangerCountArray = passangerCountArr
        self.carCategoryArray = carCategoryArr
        self.carSizeArray = carSizeArr

        
        
        
        
        
        ///Price Range
        let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
            ($0.TotalCharge?.EstimatedTotalAmount ?? 0.0 >= minPrice) && ($0.TotalCharge?.EstimatedTotalAmount ?? 0 <= maxPrice)
        }
        
        if filteredArray?.count ?? 0 > 0 {
            self.carSearchMainModel_Dummy?.CarsList = filteredArray!
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///Suppliers
        var finalArray1: [CarsListModel] = []
        let selectedSuppliers = suppliersArr.filter {$0.isSelected == true}
        if selectedSuppliers.count > 0{
            for (index, element) in selectedSuppliers.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.Vendor == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray1.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray1
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///Auto/manual
        var finalArray2: [CarsListModel] = []
        let selectedAuto = auto_manualArr.filter {$0.isSelected == true}
        if selectedAuto.count > 0{
            for (index, element) in selectedAuto.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.TransmissionType == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray2.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray2
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///AC/NonAc
        var finalArray3: [CarsListModel] = []
        let selectedAC = ac_NonAcArr.filter {$0.isSelected == true}
        if selectedAC.count > 0{
            for (index, element) in selectedAC.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.AirConditionInd == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray3.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray3
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        
        ///Package
        var finalArray4: [CarsListModel] = []
        let selectedPackage = packageArr.filter {$0.isSelected == true}
        if selectedPackage.count > 0{
            for (index, element) in selectedPackage.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.RateComments == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray4.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray4
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        
        ///DoorCount
        var finalArray5: [CarsListModel] = []
        let selectedDoorCount = doorCountArr.filter {$0.isSelected == true}
        if selectedDoorCount.count > 0{
            for (index, element) in selectedDoorCount.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.DoorCount == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray5.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray5
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///PassangerCount
        var finalArray6: [CarsListModel] = []
        let selectedPassangerCount = passangerCountArr.filter {$0.isSelected == true}
        if selectedPassangerCount.count > 0{
            for (index, element) in selectedPassangerCount.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.DoorCount == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray6.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray6
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///Car Category
        var finalArray7: [CarsListModel] = []
        let selectedCarCategory = carCategoryArr.filter {$0.isSelected == true}
        if selectedCarCategory.count > 0{
            for (index, element) in selectedCarCategory.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.VehicleCategoryName == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray7.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray7
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
        
        ///Car Sze
        var finalArray8: [CarsListModel] = []
        let selectedCarSize = carSizeArr.filter {$0.isSelected == true}
        if selectedCarSize.count > 0{
            for (index, element) in selectedCarSize.enumerated(){
                let filteredArray = self.carSearchMainModel_Dummy?.CarsList.filter{
                    $0.VehClassSizeName == element.name
                }
                if filteredArray?.count ?? 0 > 0{
                    finalArray8.append(contentsOf: filteredArray!)
                }
            }
            self.carSearchMainModel_Dummy?.CarsList = finalArray8
            DispatchQueue.main.async {
                self.tbl_carsList.reloadData()
            }
        }
    }
    
    
}
