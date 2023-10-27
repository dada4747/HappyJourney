//
//  FBookingCell.swift
//  CheapToGo
//
//  Created by Anand S on 30/11/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

class FBookingCell: UITableViewCell {
    
    @IBOutlet weak var lbl_journeyDate: UILabel!
    @IBOutlet weak var lbl_bookingDate: UILabel!
    @IBOutlet weak var lbl_refID: UILabel!
    @IBOutlet weak var lbl_arrivalCity: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_tripType: UILabel!
    @IBOutlet weak var lbl_bookingStatus: UILabel!
    @IBOutlet weak var lbl_leadName: UILabel!

    @IBOutlet weak var btn_cancel: UIButton!

    @IBOutlet weak var btn_voucher: GradientButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayFlightHistory_List(historyModel: DFlightHistoryItem) {
        
        let attributedText = NSMutableAttributedString(string: "Lead Pax: ", attributes: [NSAttributedString.Key.font: UIFont(name: "Aeonik-Medium", size: 15),NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        if let profile_dict = UserDefaults.standard.value(forKey: TMXUser_Profile) as? [String: Any]{
            let username = profile_dict["user_name"] as? String ?? ""
            attributedText.append(NSAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont(name: "Aeonik-Medium", size: 15),NSAttributedString.Key.foregroundColor: UIColor.black]))
            lbl_leadName.attributedText = attributedText
        }

        if let city = historyModel.arrival_city {
            lbl_arrivalCity.text = ((historyModel.depart_city ?? "") + (" TO ") + (historyModel.arrival_city ?? ""))
        }
        if let bookingDate = historyModel.bookingDate {
            let attributedText = NSMutableAttributedString(string: "Booked on: ", attributes: [NSAttributedString.Key.font: UIFont(name: "Aeonik-Medium", size: 15), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            attributedText.append(NSAttributedString(string: bookingDate, attributes: [NSAttributedString.Key.font: UIFont(name: "Aeonik-Medium", size: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))
            lbl_bookingDate.attributedText = attributedText
        }
        
        lbl_journeyDate.text = historyModel.journeyDate
        lbl_refID.text = historyModel.booking_id
        
        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (historyModel.flight_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//(historyModel.currency_symbol ?? "") + " " + String(format: "%.2f", historyModel.flight_price)
        lbl_tripType.text = historyModel.tripType
        lbl_bookingStatus.text = historyModel.booking_status
        if historyModel.booking_status == "BOOKING_CONFIRMED" {
            btn_cancel.alpha = 1
        }else{
            btn_cancel.alpha = 0
        }
    }
    
}
