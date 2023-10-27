//
//  TransferListCVCell.swift
//  CheapToGo
//
//  Created by Provab1151 on 29/01/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

class ActivityListCVCell: UICollectionViewCell {
    
    @IBOutlet weak var width_Constraint: NSLayoutConstraint!
    @IBOutlet weak var height_Constraint: NSLayoutConstraint!
    @IBOutlet weak var img_URL: UIImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_destCity: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var rating_view: FloatRatingView!

    @IBOutlet weak var lbl_reviews: UILabel!
    
    @IBOutlet weak var lbl_refundable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rating_view.type = .floatRatings

        
    }
    
    func dispalyTransferList(model: DTransferSearchItem) {
        
        
        img_URL.sd_setImage(with: URL.init(string: String(format: "%@",model.product_image!)), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        
        lbl_productName.text = model.product_name
        lbl_destCity.text = model.destination_city
        //lbl_duration.text = String.init(format: "Duration : %@", model.duration!)
        var duration = String.init(format: "Duration : %@", model.duration!)
        var myMutableString = NSMutableAttributedString(string: duration)
        myMutableString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Aeonik-Regular", size: 13.0),
                                       NSAttributedString.Key.foregroundColor: UIColor.lightGray],
                                      range: NSMakeRange(0, 10))
        
        lbl_duration.attributedText = myMutableString
        
        
        lbl_rating.text = "\(model.star_rating)"
        
        //lbl_price.text = "USD \(model.product_price)"
        
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] ?? ""
//            let value =  currencyConversion["value"]
//            let multipliedValue = (model.product_price) * (Float(value ?? "0.0") ?? 0.0)
//            //lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//            var myString = symbol + " " + String(format: "%.2f", multipliedValue)
//            var myMutableString = NSMutableAttributedString(string: "Price: " + myString)
//            myMutableString.setAttributes([NSAttributedString.Key.font: UIFont(name: "Aeonik-Medium", size: 14.0),
//                                           NSAttributedString.Key.foregroundColor: UIColor.lightGray],
//                                          range: NSMakeRange(0, 6))
//
//
//
//        }
        lbl_price.text = String(format: "%@ %0.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model.product_price ) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).rounded())
    }
    
    func dispalyTransferList(model: DActivitySearchItem) {
        
        img_URL.sd_setImage(with: URL.init(string: String(format: "%@",model.ImageUrl!)), placeholderImage: UIImage.init(named: "holiday_dummy.jpg"))
        lbl_productName.text = model.ProductName
        lbl_destCity.text = model.DestinationName
        lbl_duration.text = String.init(format: "Duration : %@", model.Duration)
        lbl_rating.text = "\(model.StarRating!)"
        
        rating_view.rating = Double(model.StarRating!)
        lbl_reviews.text = "\(model.ReviewCount)"
        lbl_refundable.text =  "Non-Refundable"
        lbl_reviews.text = String(format: "%d %@ ", model.ReviewCount!, "Reviews")
        if (model.Cancellation_available!) {
            lbl_refundable.text =  "Refundable"
        }else {
            lbl_refundable.text =  "Non-Refundable"
        }
        //lbl_price.text = "USD \(model.product_price)"
        
//        if let currencyConversion = UserDefaults.standard.object(forKey: CTG_CurrencyConversion) as? [String: String]{
//            let symbol = currencyConversion["currency_symbol"] as? String ?? ""
//            let value =  currencyConversion["value"] as? String
//            let multipliedValue = (model.TotalDisplayFare) * (Double(value ?? "0.0") ?? 0.0)
//            lbl_price.text = symbol + " " + String(format: "%.2f", multipliedValue)
//        }
        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (Float(model.TotalDisplayFare) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
    }
    
}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
