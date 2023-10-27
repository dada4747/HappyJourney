//
//  TransfersFiltersViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 05/08/21.
//

import UIKit
import WARangeSlider

protocol TransfersFiltersApplied: class {
    func filtersApplied(isPriceRangeFilterApplied: Bool, min_Price: Double, max_Price: Double)
    func resetFilters()
}
class TransfersFiltersViewController: UIViewController {
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


    var transferList_array: [DTransferSearchItem] = []
    var isPriceRangeFilterApplied = false
    var isPriceOrderChanged = false
    weak var delegate: TransfersFiltersApplied?
    
    var isOffersClicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sliderInit()
        initSort()
    }
    func initSort(){
        
        if DTransfersFiltersModel.lowest_Price == true{
            btn_price_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_price_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DTransfersFiltersModel.highest_Price == true{
            btn_price_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_price_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        
        if DTransfersFiltersModel.lowest_Star == true{
            btn_star_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_star_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DTransfersFiltersModel.highest_Star == true{
            btn_star_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_star_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
        if DTransfersFiltersModel.lowest_Name == true{
            btn_name_Low.setImage(UIImage(named: "checked"), for: .normal)
            btn_name_High.setImage(UIImage(named: "unchecked"), for: .normal)
        }else if DTransfersFiltersModel.highest_Name == true{
            btn_name_High.setImage(UIImage(named: "checked"), for: .normal)
            btn_name_Low.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    func sliderInit(){
//        if self.isPriceOrderChanged == false {
            view_CustomSlider.maximumValue = transferList_array.last?.product_price ?? 0.0
            view_CustomSlider.upperValue = transferList_array.last?.product_price ?? 0.0
            
            view_CustomSlider.minimumValue = transferList_array.first?.product_price ?? 0.0
            view_CustomSlider.lowerValue =  transferList_array.first?.product_price ?? 0.0
//        }else{
//            view_CustomSlider.maximumValue = transferList_array.first?.product_price ?? 0.0
//            view_CustomSlider.upperValue = transferList_array.first?.product_price ?? 0.0
//
//            view_CustomSlider.minimumValue = transferList_array.last?.product_price ?? 0.0
//            view_CustomSlider.lowerValue =  transferList_array.last?.product_price ?? 0.0
//        }
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
        lbl_priceAmt.text = String(format: "%@ %@ - %@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.minimumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator()," - ", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(view_CustomSlider.maximumValue) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        
        
        view_CustomSlider.addTarget(self, action: #selector(rangeSliderValueChanged),
                                    for: .valueChanged)
    }
    
    @objc func rangeSliderValueChanged(rangeSlider: RangeSlider){
        print("Range slider value changed: (\(rangeSlider.lowerValue) , \(rangeSlider.upperValue))")
        self.isPriceRangeFilterApplied = true
        let min = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", Float(rangeSlider.lowerValue).formattedWithSeparator())
        let max = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", Float(rangeSlider.upperValue).formattedWithSeparator())
        DispatchQueue.main.async {
            self.lbl_priceAmt.text = min + " - " + max
        }
        
    }

    // MARK:- Button Actions
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterApply_Clicked(_ sender: Any) {
        DTransfersFiltersModel.txt_Name = txt_name.text
        print("tf\(txt_name.text)")
        print(DTransfersFiltersModel.txt_Name)
        DTransfersFiltersModel.btn_Offer = isOffersClicked
        
        delegate?.filtersApplied(isPriceRangeFilterApplied: self.isPriceRangeFilterApplied, min_Price: view_CustomSlider.lowerValue, max_Price: view_CustomSlider.upperValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterClear_Clicked(_ sender: Any) {
        delegate?.resetFilters()
        self.navigationController?.popViewController(animated: true)
    }
    
    ///Sort
    @IBAction func sort_price_Low_Clicked(_ sender: UIButton) {
        
            DTransfersFiltersModel.lowest_Price  = true
            DTransfersFiltersModel.highest_Price  = false

        initSort()
    }
    
    @IBAction func sort_price_High_Clicked(_ sender: UIButton) {
            DTransfersFiltersModel.highest_Price  = true
            DTransfersFiltersModel.lowest_Price  = false

        initSort()
    }
    
    @IBAction func sort_star_Low_Clicked(_ sender: UIButton) {
            DTransfersFiltersModel.lowest_Star  = true
            DTransfersFiltersModel.highest_Star  = false

        initSort()
    }
    
    @IBAction func sort_star_High_Clicked(_ sender: UIButton) {
            DTransfersFiltersModel.highest_Star  = true
            DTransfersFiltersModel.lowest_Star  = false
        
        initSort()
    }
    
    @IBAction func sort_name_Low_Clicked(_ sender: UIButton) {
        DTransfersFiltersModel.lowest_Name  = true
        DTransfersFiltersModel.highest_Name  = false
        
        initSort()
    }
    
    @IBAction func sort_name_High_Clicked(_ sender: UIButton) {
        DTransfersFiltersModel.highest_Name  = true
        DTransfersFiltersModel.lowest_Name  = false
        initSort()
    }
    //New
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
