//
//  CarsListCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 12/07/21.
//

import UIKit

class CarsListCell: UITableViewCell {
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var view_more: UIView!
    @IBOutlet weak var btn_book: UIButton!
    @IBOutlet weak var btn_moreDetails: UIButton!
    @IBOutlet weak var hei_moreDetialsConstraint: NSLayoutConstraint!

    @IBOutlet weak var img_car: UIImageView!
    @IBOutlet weak var lbl_vehicleName: UILabel!
    @IBOutlet weak var lbl_vehicleClass: UILabel!
    @IBOutlet weak var lbl_vehicleCategory: UILabel!
    @IBOutlet weak var lbl_vehicleFuelType: UILabel!
    @IBOutlet weak var lbl_passengerCount: UILabel!
    @IBOutlet weak var lbl_baggageCount: UILabel!
    @IBOutlet weak var lbl_doorCount: UILabel!

    @IBOutlet weak var lbl_ageLimitLoc: UILabel!
    @IBOutlet weak var lbl_silverPackageLoc: UILabel!
    @IBOutlet weak var lbl_moreDetailsLoc: UILabel!

    @IBOutlet weak var lbl_gear: UILabel!
    @IBOutlet weak var lbl_ac: UILabel!
    @IBOutlet weak var lbl_mileage: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_ageLimit: UILabel!
    @IBOutlet weak var btn_cancelPolicy: UIButton!
    @IBOutlet weak var tbl_silverPackage: UITableView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var silverPackageList:[PricedCoverage_Model] = [PricedCoverage_Model]()
    
    func displayData(obj: CarsListModel){
        lbl_vehicleName.text = obj.Name
        img_car.sd_setImage(with: URL.init(string: obj.PictureURL ?? ""))
        lbl_vehicleClass.text = obj.VendorCarType
        lbl_vehicleCategory.text = obj.VehicleCategoryName
        lbl_vehicleFuelType.text = obj.FuelType
        lbl_passengerCount.text = obj.PassengerQuantity
        lbl_baggageCount.text = obj.BaggageQuantity
        lbl_doorCount.text = obj.DoorCount
        lbl_gear.text = obj.TransmissionType
        if obj.AirConditionInd == "true"{
            lbl_ac.text = "A/C"
        }else{
            lbl_ac.text = "Non-A/C"
        }
        if obj.PricedCoverage.count > 0 {
            lbl_mileage.text = obj.PricedCoverage[0].CoverageType
        }
        lbl_silverPackageLoc.text = obj.RateComments
                
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue = (obj.TotalCharge?.EstimatedTotalAmount ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//        }
        lbl_price.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "$", (Float((obj.TotalCharge?.EstimatedTotalAmount)!)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        
        ///silver package
        self.silverPackageList = obj.PricedCoverage
        
    }
    


    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CarsListCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.silverPackageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "SilverPackageCell") as? SilverPackageCell
        if cell == nil {
            tableView.register(UINib(nibName: "SilverPackageCell", bundle: nil), forCellReuseIdentifier: "SilverPackageCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SilverPackageCell") as? SilverPackageCell
        }
        
        cell?.lbl_title.text = self.silverPackageList[indexPath.row].CoverageType
        cell?.lbl_description.text = self.silverPackageList[indexPath.row].Desscription
        cell?.selectionStyle = .none
        return cell!
    }
    
    
}
