//
//  CarFiltersViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 16/07/21.
//

import UIKit
import WARangeSlider
protocol FilterApplied: class {
    func filterApplied(minPrice: Double, maxPrice: Double, suppliersArr: [Car_FiltersModel], auto_manualArr: [Car_FiltersModel],ac_NonAcArr: [Car_FiltersModel], packageArr: [Car_FiltersModel], doorCountArr: [Car_FiltersModel], passangerCountArr: [Car_FiltersModel], carCategoryArr: [Car_FiltersModel], carSizeArr: [Car_FiltersModel])
    func clearAppliedFilters()
    
}
class CarFiltersViewController: UIViewController {

    @IBOutlet weak var view_CustomSlider: RangeSlider!
    @IBOutlet weak var lbl_minPrice: UILabel!
    @IBOutlet weak var lbl_maxPrice: UILabel!
    
    var carSearchMainModel: CarSearchMainModel?
    var isPriceRangeFilterApplied = false
    var isFiltersApplied = false

    @IBOutlet weak var minPriceLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var maxPriceLabelLeadingingConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_Suppliers: UITableView!
    @IBOutlet weak var hei_tbl_SuppliersConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_AutoManual: UITableView!
    @IBOutlet weak var hei_tbl_AutoManualConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_Ac_NonAc: UITableView!
    @IBOutlet weak var hei_tbl_Ac_NonAcConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_Package: UITableView!
    @IBOutlet weak var hei_PackageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tbl_DoorCount: UITableView!
    @IBOutlet weak var hei_DoorCountConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_PassangerCount: UITableView!
    @IBOutlet weak var hei_tbl_PassangerCountConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_CarCategory: UITableView!
    @IBOutlet weak var hei_tbl_CarCategoryConstraint: NSLayoutConstraint!

    @IBOutlet weak var tbl_CarSize: UITableView!
    @IBOutlet weak var hei_tbl_CarSizeConstraint: NSLayoutConstraint!

    weak var delegate: FilterApplied?

    //var suppliersArray: [[String: Any]] = [[:]]
    var suppliersArray: [Car_FiltersModel] = [Car_FiltersModel]()
    var auto_Manual_Array: [Car_FiltersModel] = [Car_FiltersModel]()
    var ac_NonAc_Array: [Car_FiltersModel] = [Car_FiltersModel]()
    var packageArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var doorCountArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var passangerCountArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var carCategoryArray:[Car_FiltersModel] = [Car_FiltersModel]()
    var carSizeArray:[Car_FiltersModel] = [Car_FiltersModel]()

//    var suppliersArray = [
//        ["key": "Alamo", "isSelected": false],
//        ["key": "Greenmotion", "isSelected": false],
//        ["key": "National", "isSelected": false]
//    ]
//    var suppliersArray = [
//        ["key": "Alamo", "isSelected": false],
//        ["key": "Greenmotion", "isSelected": false],
//        ["key": "National", "isSelected": false]
//    ]
//    var suppliersArray = [
//        ["key": "Alamo", "isSelected": false],
//        ["key": "Greenmotion", "isSelected": false],
//        ["key": "National", "isSelected": false]
//    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sliderInit()
        if isFiltersApplied == true{
            DispatchQueue.main.async {
                self.tbl_Suppliers.reloadData()
                self.hei_tbl_SuppliersConstraint.constant = self.tbl_Suppliers.contentSize.height

                self.tbl_AutoManual.reloadData()
                self.hei_tbl_AutoManualConstraint.constant = self.tbl_AutoManual.contentSize.height

                self.tbl_Ac_NonAc.reloadData()
                self.hei_tbl_Ac_NonAcConstraint.constant = self.tbl_Ac_NonAc.contentSize.height

                self.tbl_Package.reloadData()
                self.hei_PackageConstraint.constant = self.tbl_Package.contentSize.height

                self.tbl_DoorCount.reloadData()
                self.hei_DoorCountConstraint.constant = self.tbl_DoorCount.contentSize.height

                self.tbl_PassangerCount.reloadData()
                self.hei_tbl_PassangerCountConstraint.constant = self.tbl_PassangerCount.contentSize.height

                self.tbl_CarCategory.reloadData()
                self.hei_tbl_CarCategoryConstraint.constant = self.tbl_CarCategory.contentSize.height

                self.tbl_CarSize.reloadData()
                self.hei_tbl_CarSizeConstraint.constant = self.tbl_CarSize.contentSize.height
                
            }
        }else{
            getVendorsArray()
            getAutoManualArray()
            getAcNonAcArray()
            getPackagesArray()
            getDoorCountArray()
            getPassangerCountArray()
            getCarCategoryArray()
            getCarSizeArray()
        }
    }
    
    func getVendorsArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.Vendor
        }
        //        let testarray = ["one", "one", "two", "two", "three", "three"]
        //        let unique = Array(Set(testarray))
        let temp = Array(Set(filteredArr ?? []))
        suppliersArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.suppliersArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_Suppliers.reloadData()
            self.hei_tbl_SuppliersConstraint.constant = self.tbl_Suppliers.contentSize.height
        }
    }
    func getAutoManualArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.TransmissionType
        }
        let temp = Array(Set(filteredArr ?? []))
        auto_Manual_Array.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.auto_Manual_Array.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_AutoManual.reloadData()
            self.hei_tbl_AutoManualConstraint.constant = self.tbl_AutoManual.contentSize.height
        }
    }
    func getAcNonAcArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.AirConditionInd
        }
        let temp = Array(Set(filteredArr ?? []))
        ac_NonAc_Array.removeAll()
        for item in temp {
            //var dict = ["isSelected": false] as! [String : Any]
            let dict = ["name": item, "isSelected": false] as! [String : Any]

//            if item == "true"{
//                dict["name"] = "AC"
//            }else{
//                dict["name"] = "Non AC"
//            }
            self.ac_NonAc_Array.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_Ac_NonAc.reloadData()
            self.hei_tbl_Ac_NonAcConstraint.constant = self.tbl_Ac_NonAc.contentSize.height
        }
    }
    func getPackagesArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.RateComments
        }
        let temp = Array(Set(filteredArr ?? []))
        packageArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.packageArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_Package.reloadData()
            self.hei_PackageConstraint.constant = self.tbl_Package.contentSize.height
        }
    }
    func getDoorCountArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.DoorCount
        }
        let temp = Array(Set(filteredArr ?? []))
        doorCountArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.doorCountArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_DoorCount.reloadData()
            self.hei_DoorCountConstraint.constant = self.tbl_DoorCount.contentSize.height
        }
    }
    
    func getPassangerCountArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.PassengerQuantity
        }
        let temp = Array(Set(filteredArr ?? []))
        passangerCountArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.passangerCountArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_PassangerCount.reloadData()
            self.hei_tbl_PassangerCountConstraint.constant = self.tbl_PassangerCount.contentSize.height
        }
    }
    
    func getCarCategoryArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.VehicleCategoryName
        }
        let temp = Array(Set(filteredArr ?? []))
        carCategoryArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.carCategoryArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_CarCategory.reloadData()
            self.hei_tbl_CarCategoryConstraint.constant = self.tbl_CarCategory.contentSize.height
        }
    }
    
    func getCarSizeArray(){
        let filteredArr = carSearchMainModel?.CarsList.map {
            $0.VehClassSizeName
        }
        let temp = Array(Set(filteredArr ?? []))
        carSizeArray.removeAll()
        for item in temp {
            let dict = ["name": item, "isSelected": false] as! [String : Any]
            self.carSizeArray.append(Car_FiltersModel(dict: dict))
        }
        DispatchQueue.main.async {
            self.tbl_CarSize.reloadData()
            self.hei_tbl_CarSizeConstraint.constant = self.tbl_CarSize.contentSize.height
        }
    }
    
    func sliderInit(){
        view_CustomSlider.maximumValue = carSearchMainModel?.CarsList.last?.TotalCharge?.EstimatedTotalAmount ?? 0.0
        view_CustomSlider.upperValue = carSearchMainModel?.CarsList.last?.TotalCharge?.EstimatedTotalAmount ?? 0.0
        
        
        
        view_CustomSlider.minimumValue = carSearchMainModel?.CarsList.first?.TotalCharge?.EstimatedTotalAmount ?? 0.0
        view_CustomSlider.lowerValue =  carSearchMainModel?.CarsList.first?.TotalCharge?.EstimatedTotalAmount ?? 0.0
        
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue_min = (view_CustomSlider.minimumValue) * (Double(value ?? "0.0") ?? 0.0)
//            let multipliedValue_max = (view_CustomSlider.maximumValue) * (Double(value ?? "0.0") ?? 0.0)
//            self.lbl_minPrice.text = symbol + " " + String(format: "%.2f", multipliedValue_min)
//            self.lbl_maxPrice.text = symbol + " " + String(format: "%.2f", multipliedValue_max)
//
//        }
        self.lbl_minPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.minimumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
//        String(format: "%.1f", view_CustomSlider.minimumValue)
        self.lbl_maxPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.maximumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
//        String(format: "%.1f", view_CustomSlider.maximumValue)

        
        view_CustomSlider.addTarget(self, action: #selector(rangeSliderValueChanged),
                                 for: .valueChanged)
        maxPriceLabelLeadingingConstraint.constant = (view_CustomSlider.frame.width - 90)
    }
    
    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider){
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        self.isPriceRangeFilterApplied = true
        
        if rangeSlider.lowerThumbLayer.highlighted == true {
            DispatchQueue.main.async {
                self.minPriceLabelLeadingConstraint.constant = rangeSlider.previouslocation.x
                self.lbl_minPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", Float(rangeSlider.lowerValue).formattedWithSeparator())
//                String(format: "%.2f", rangeSlider.lowerValue)
            }
        }else{
            self.maxPriceLabelLeadingingConstraint.constant = (rangeSlider.previouslocation.x - 90)
            self.lbl_maxPrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", Float(rangeSlider.upperValue).formattedWithSeparator())
//            String(format: "%.2f", rangeSlider.upperValue)
        }
//        
        
    }
    
    
    // MARK:- Button Actions
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterApply_Clicked(_ sender: Any) {
        delegate?.filterApplied(minPrice: self.view_CustomSlider.lowerValue, maxPrice: self.view_CustomSlider.upperValue, suppliersArr: suppliersArray, auto_manualArr: auto_Manual_Array, ac_NonAcArr: ac_NonAc_Array, packageArr: packageArray, doorCountArr: doorCountArray, passangerCountArr: passangerCountArray, carCategoryArr: carCategoryArray, carSizeArr: carSizeArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClear_Clicked(_ sender: Any) {
        delegate?.clearAppliedFilters()
        self.navigationController?.popViewController(animated: true)
    }
}


extension CarFiltersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_Suppliers{
            return suppliersArray.count
        }else if tableView == tbl_AutoManual{
            return auto_Manual_Array.count
        }else if tableView == tbl_Ac_NonAc{
            return ac_NonAc_Array.count
        }else if tableView == tbl_Package{
            return packageArray.count
        }else if tableView == tbl_DoorCount{
            return doorCountArray.count
        }else if tableView == tbl_PassangerCount{
            return passangerCountArray.count
        }else if tableView == tbl_CarCategory{
            return carCategoryArray.count
        }else if tableView == tbl_CarSize{
            return carSizeArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell
        if cell == nil {
            tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell
        }
        
        if tableView == tbl_Suppliers{
            cell?.lbl_name.text = suppliersArray[indexPath.row].name
            if suppliersArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_1), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_AutoManual{
            cell?.lbl_name.text = auto_Manual_Array[indexPath.row].name
            if auto_Manual_Array[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_2), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_Ac_NonAc{
            if ac_NonAc_Array[indexPath.row].name == "true"{
                cell?.lbl_name.text = "AC"
            }else{
                cell?.lbl_name.text = "Non AC"
            }
            if ac_NonAc_Array[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_3), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_Package{
            cell?.lbl_name.text = packageArray[indexPath.row].name
            if packageArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_4), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_DoorCount{
            cell?.lbl_name.text = doorCountArray[indexPath.row].name
            if doorCountArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_5), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_PassangerCount{
            cell?.lbl_name.text = passangerCountArray[indexPath.row].name
            if passangerCountArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_6), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_CarCategory{
            cell?.lbl_name.text = carCategoryArray[indexPath.row].name
            if carCategoryArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_7), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }else if tableView == tbl_CarSize{
            cell?.lbl_name.text = carSizeArray[indexPath.row].name
            if carSizeArray[indexPath.row].isSelected == true{
                cell?.btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
            }else{
                cell?.btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
            cell?.btn_checkBox.addTarget(self, action: #selector(checkBoxClicked_8), for: .touchUpInside)
            cell?.btn_checkBox.tag = indexPath.row
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func checkBoxClicked_1(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
            if suppliersArray[sender.tag].isSelected == true{
                suppliersArray[sender.tag].isSelected = false
            }else{
                suppliersArray[sender.tag].isSelected = true
            }
            self.tbl_Suppliers.reloadRows(at: [indexPath], with: .automatic)
    }
    @objc func checkBoxClicked_2(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if auto_Manual_Array[sender.tag].isSelected == true{
            auto_Manual_Array[sender.tag].isSelected = false
        }else{
            auto_Manual_Array[sender.tag].isSelected = true
        }
        self.tbl_AutoManual.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_3(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if ac_NonAc_Array[sender.tag].isSelected == true{
            ac_NonAc_Array[sender.tag].isSelected = false
        }else{
            ac_NonAc_Array[sender.tag].isSelected = true
        }
        self.tbl_Ac_NonAc.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_4(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if packageArray[sender.tag].isSelected == true{
            packageArray[sender.tag].isSelected = false
        }else{
            packageArray[sender.tag].isSelected = true
        }
        self.tbl_Package.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_5(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if doorCountArray[sender.tag].isSelected == true{
            doorCountArray[sender.tag].isSelected = false
        }else{
            doorCountArray[sender.tag].isSelected = true
        }
        self.tbl_DoorCount.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_6(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if passangerCountArray[sender.tag].isSelected == true{
            passangerCountArray[sender.tag].isSelected = false
        }else{
            passangerCountArray[sender.tag].isSelected = true
        }
        self.tbl_PassangerCount.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_7(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if carCategoryArray[sender.tag].isSelected == true{
            carCategoryArray[sender.tag].isSelected = false
        }else{
            carCategoryArray[sender.tag].isSelected = true
        }
        self.tbl_CarCategory.reloadRows(at: [indexPath], with: .automatic)
        
    }
    @objc func checkBoxClicked_8(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if carSizeArray[sender.tag].isSelected == true{
            carSizeArray[sender.tag].isSelected = false
        }else{
            carSizeArray[sender.tag].isSelected = true
        }
        self.tbl_CarSize.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
}
