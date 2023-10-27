//
//  TripListTVCell.swift
//  ExtactTravel
//
//  Created by Admin on 22/08/22.
//

import UIKit

class TripListTVCell: UITableViewCell {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_departureTime: UILabel!
    @IBOutlet weak var lbl_travellersCount: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var btn_book: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func displayData(model: TransferTripItem) {
//        
//        lbl_title.text = model.gradeTitle
//        lbl_description.text = ("Description: " + (model.gradeDescription))
//        lbl_departureTime.text = ("Departure Time: " + (model.bookingDate))
//        lbl_travellersCount.text = ("Total Travellers: " + (String(model.TotalPax)))
//        lbl_price.text =  String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (model.TotalDisplayFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())//"$ " + String(model.TotalDisplayFare)
////        if let currencyConversion = UserDefaults.standard.object(forKey: TMX_Currency) as? [String: String]{
////            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
////            let value =  currencyConversion["value"] as? String
////            let multipliedValue = (model.TotalDisplayFare) * (value ?? "0.0")
////            lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
////        }
//    }
    func displayData1(model: TripList){
        
        lbl_title.text = model.gradeTitle
        let final_descript = "<div align=\"justify\">\(model.gradeDescription)</div>"
        let formattedText = model.gradeDescription.replacingOccurrences(of: "<br/>", with: "\n")

        lbl_description.text = ("Description: " + (formattedText))
        lbl_departureTime.text = ("Departure Time: " + (model.bookingDate))
        lbl_travellersCount.text = ("Total Travellers: " + (String(model.TotalPax)))
        //lbl_price.text = "$ " + String(model.TotalDisplayFare)
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue = (model.TotalDisplayFare) * (Double(value ?? "0.0") ?? 0.0)
//            lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//        }
        lbl_price.text =  String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model.TotalDisplayFare) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
    }
}

