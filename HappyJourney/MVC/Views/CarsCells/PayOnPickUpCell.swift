//
//  PayOnPickUpCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 16/07/21.
//

import UIKit

class PayOnPickUpCell: UITableViewCell {
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func displayData(model: PricedEquip_Model){
        if model.seatCount ?? 0 > 0{
            lbl_title.text = model.Description
            let multipliedAmount = ((model.Amount ?? 0.0) * Double(model.seatCount ?? 0))
//            if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                let value =  currencyConversion["value"] as? String
//                let multipliedValue = (multipliedAmount) * (Double(value ?? "0.0") ?? 0.0)
//                lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//            }
            lbl_price.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(multipliedAmount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        }else{
            lbl_title.text = model.Description
//            if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//                let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//                let value =  currencyConversion["value"] as? String
//                let multipliedValue = (model.Amount ?? 0.0) * (Double(value ?? "0.0") ?? 0.0)
//                lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//            }
            lbl_price.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model.Amount!) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())

        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
