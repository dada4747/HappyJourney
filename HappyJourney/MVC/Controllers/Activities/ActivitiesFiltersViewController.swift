//
//  ActivitiesFiltersViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 06/08/21.
//

import UIKit
//import WARangeSlider

protocol TransfersFiltersApplied1: class {
    func filtersApplied(isPriceRangeFilterApplied: Bool, min_Price: Double, max_Price: Double, activitiesTypeArr: [ActivitiesTypeModel])
    func resetFilters()
}
class ActivitiesFiltersViewController: UIViewController {
    @IBOutlet weak var lbl_priceAmt: UILabel!
    @IBOutlet weak var view_CustomSlider: RangeSlider!

    @IBOutlet weak var btn_price_Low: UIButton!
    @IBOutlet weak var btn_price_High: UIButton!
    @IBOutlet weak var btn_star_Low: UIButton!
    @IBOutlet weak var btn_star_High: UIButton!
    @IBOutlet weak var btn_name_Low: UIButton!
    @IBOutlet weak var btn_name_High: UIButton!

    @IBOutlet weak var btn_offers: UIButton!
    @IBOutlet weak var txt_name: UITextField!

    @IBOutlet weak var tbl_Category: UITableView!
    @IBOutlet weak var tbl_Category_HeightConstraint: NSLayoutConstraint!

    var transferList_array: [DActivitySearchItem] = []
    var isPriceRangeFilterApplied = false
    var isPriceOrderChanged = false
    weak var delegate: TransfersFiltersApplied1?
    
    var isOffersClicked = false
    var activitiesTypesArr: [ActivitiesTypeModel] = []
    var cityID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl_Category.register(UINib(nibName: "ActivitiesTypeTVCell", bundle: .main), forCellReuseIdentifier: "ActivitiesTypeTVCell")

        sliderInit()
        initSort()
        getCategoryNamesAPI()
        tbl_Category_HeightConstraint.constant = 0
    }
    func initSort(){
        
        if DActivitiesFiltersModel.lowest_Price == true{
            btn_price_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_price_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DActivitiesFiltersModel.highest_Price == true{
            btn_price_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_price_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        
        if DActivitiesFiltersModel.lowest_Star == true{
            btn_star_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_star_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DActivitiesFiltersModel.highest_Star == true{
            btn_star_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_star_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        if DActivitiesFiltersModel.lowest_Name == true{
            btn_name_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_name_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DActivitiesFiltersModel.highest_Name == true{
            btn_name_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_name_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    func sliderInit(){
        if self.isPriceOrderChanged == false{
            view_CustomSlider.maximumValue = transferList_array.last?.TotalDisplayFare ?? 0.0
            view_CustomSlider.upperValue = transferList_array.last?.TotalDisplayFare ?? 0.0
            
            view_CustomSlider.minimumValue = transferList_array.first?.TotalDisplayFare ?? 0.0
            view_CustomSlider.lowerValue =  transferList_array.first?.TotalDisplayFare ?? 0.0
        }else{
            view_CustomSlider.maximumValue = transferList_array.first?.TotalDisplayFare ?? 0.0
            view_CustomSlider.upperValue = transferList_array.first?.TotalDisplayFare ?? 0.0
            
            view_CustomSlider.minimumValue = transferList_array.last?.TotalDisplayFare ?? 0.0
            view_CustomSlider.lowerValue =  transferList_array.last?.TotalDisplayFare ?? 0.0
        }
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue_min = (view_CustomSlider.minimumValue) * (Double(value ?? "0.0") ?? 0.0)
//            let multipliedValue_max = (view_CustomSlider.maximumValue) * (Double(value ?? "0.0") ?? 0.0)
//            let min = symbol + " " + String(format: "%.2f", multipliedValue_min)
//            let max = symbol + " " + String(format: "%.2f", multipliedValue_max)
//            self.lbl_priceAmt.text = min + " - " + max
//
//        }
        lbl_priceAmt.text = String(format: "%@ %@ %@ %@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.minimumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator()," - ", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.maximumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        
        view_CustomSlider.addTarget(self, action: #selector(rangeSliderValueChanged),
                                    for: .valueChanged)
    }
    
    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider){
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        self.isPriceRangeFilterApplied = true
        let min = String(format: "%.2f", rangeSlider.lowerValue)
        let max = String(format: "%.2f", rangeSlider.upperValue)
        DispatchQueue.main.async {
            self.lbl_priceAmt.text = min + " - " + max
        }
        
    }
    
    @objc func tableHeightCalculation() {
        
        tbl_Category_HeightConstraint.constant = tbl_Category.contentSize.height + 60

        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func getCategoryNamesAPI(){
        var apiName = Activities_Types
        apiName += "?city_id=\(self.cityID)&Select_cate_id=0"
        CommonLoader.shared.startLoader(in: view)

        // calling api...
        VKAPIs.shared.getRequest(file:apiName, httpMethod: .GET)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Activities_Types success: \(String(describing: resultObj))")
                
                if let result = resultObj as? [String: Any] {
                    if let data = result["data"] as? [String: Any]{
//                        if let list = data["CategoryList"] as? [[String: Any]]{
//                            self.activitiesTypesArr.removeAll()
//                            for item in list{
//                                let obj = ActivitiesTypeModel(dict: item)
//                                self.activitiesTypesArr.append(obj)
//                            }
//                            DispatchQueue.main.async {
//                                self.tbl_Category.reloadData()
//                            }
//                            self.perform(#selector(self.tableHeightCalculation), with: nil, afterDelay: 2)
//                        }
                        if let list = data["CategoryList"] as? NSArray{
                            self.activitiesTypesArr.removeAll()
                            for item in list{
                                if let temp = item as? [String : Any] {
                                    let obj = ActivitiesTypeModel(dict: temp)
                                    self.activitiesTypesArr.append(obj)
                                }
                            }
                            DispatchQueue.main.async {
                                self.tbl_Category.reloadData()
                            }
                            self.perform(#selector(self.tableHeightCalculation), with: nil, afterDelay: 1)
                        }
                    }
                    if result["status"] as? Bool == true {
                        DActivitiesSearchModel.createModels(result_dict: result)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            UIApplication.shared.keyWindow?.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Activities_Types formate : \(String(describing: resultObj))")
                }
            }
            else {
                // error message...
                UIApplication.shared.keyWindow?.makeToast(message: error?.localizedDescription ?? "")
            }
            
            CommonLoader.shared.stopLoader()
        }
    }

    // MARK:- Button Actions
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterApply_Clicked(_ sender: Any) {
        DActivitiesFiltersModel.txt_Name = txt_name.text
        DActivitiesFiltersModel.btn_Offer = isOffersClicked
        print(DActivitiesFiltersModel.btn_Offer = isOffersClicked)
        delegate?.filtersApplied(isPriceRangeFilterApplied: self.isPriceRangeFilterApplied, min_Price: view_CustomSlider.lowerValue, max_Price: view_CustomSlider.upperValue, activitiesTypeArr: self.activitiesTypesArr)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClear_Clicked(_ sender: Any) {
        delegate?.resetFilters()
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Sort
    @IBAction func sort_price_Low_Clicked(_ sender: UIButton) {
        
            DActivitiesFiltersModel.lowest_Price  = true
            DActivitiesFiltersModel.highest_Price  = false

        initSort()
    }
    
    @IBAction func sort_price_High_Clicked(_ sender: UIButton) {
            DActivitiesFiltersModel.highest_Price  = true
            DActivitiesFiltersModel.lowest_Price  = false

        initSort()
    }
    
    @IBAction func sort_star_Low_Clicked(_ sender: UIButton) {
            DActivitiesFiltersModel.lowest_Star  = true
            DActivitiesFiltersModel.highest_Star  = false

        initSort()
    }
    
    @IBAction func sort_star_High_Clicked(_ sender: UIButton) {
            DActivitiesFiltersModel.highest_Star  = true
            DActivitiesFiltersModel.lowest_Star  = false
        
        initSort()
    }
    
    @IBAction func sort_name_Low_Clicked(_ sender: UIButton) {
        DActivitiesFiltersModel.lowest_Name  = true
        DActivitiesFiltersModel.highest_Name  = false
        
        initSort()
    }
    
    @IBAction func sort_name_High_Clicked(_ sender: UIButton) {
        DActivitiesFiltersModel.highest_Name  = true
        DActivitiesFiltersModel.lowest_Name  = false
        initSort()
    }
    ///New
    @IBAction func offers_Clicked(_ sender: Any) {
        if self.isOffersClicked{
            isOffersClicked = false
            btn_offers.setImage(UIImage(named: "unchecked"), for: .normal)
        }else{
            isOffersClicked = true
            btn_offers.setImage(UIImage(named: "checked"), for: .normal)
        }
    }
}

extension ActivitiesFiltersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesTypesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesTypeTVCell", for: indexPath as IndexPath) as! ActivitiesTypeTVCell
        cell.selectionStyle = .none
        cell.btn_checkBox.tag = indexPath.row
        cell.displayData(obj: (activitiesTypesArr[indexPath.row]))
        cell.btn_checkBox.addTarget(self, action: #selector(checkBoxAction), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @objc func checkBoxAction(sender:UIButton){
        
        if self.activitiesTypesArr[sender.tag].isSelected == true{
            self.activitiesTypesArr[sender.tag].isSelected = false
        }else{
            self.activitiesTypesArr[sender.tag].isSelected = true
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        self.tbl_Category.beginUpdates()
        self.tbl_Category.reloadRows(at: [indexPath], with: .none)
        self.tbl_Category.endUpdates()
    }
    
}
