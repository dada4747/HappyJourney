//
//  TransferBookingTVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 05/08/21.
//

import UIKit

class TransferBookingTVCell: UITableViewCell {
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_bookingDate: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_bookingID: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    
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
    func displayTransferBooking(model: DTransferHistoryItem ) {
        lbl_bookingID.text = model.booking_id
        lbl_title.text = model.product_name
        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (Float(model.total_fare!)! * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//((model.currency ?? "") + " " + (model.total_fare ?? ""))
        lbl_status.text = model.booking_status
        lbl_bookingDate.text = model.bookingDate
        if model.booking_status == "BOOKING_CONFIRMED" {
            btn_cancel.isHidden = false
        }else{
            btn_cancel.isHidden = true
        }
        //lbl_price.text = String(format: "%@ %.2f", model.currency!, model.total_fare!)
    }
    
    func displayActivitiesBooking(model: DActivitiesHistoryItem ) {
        lbl_bookingID.text = model.booking_id
        lbl_title.text = model.product_name
        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (Float(model.total_fare!)! * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//((model.currency ?? "") + " " + (model.total_fare ?? ""))
        lbl_status.text = model.booking_status
        lbl_bookingDate.text = model.bookingDate
        if model.booking_status == "BOOKING_CONFIRMED" {
            btn_cancel.isHidden = false
        }else{
            btn_cancel.isHidden = true
        }
        //lbl_price.text = String(format: "%@ %.2f", model.currency!, model.total_fare!)
    }
    func displayActivitiesBooking(model: DHolidaysHistoryItem ) {
        lbl_bookingID.text = model.holiday_bookingObj?.booking_id
        lbl_title.text = model.holiday_tourObj?.package_name
        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (Float((model.holiday_bookingObj?.total_fare)!)! * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//((model.holiday_bookingObj?.currency ?? "") + " " + (model.holiday_bookingObj?.total_fare ?? ""))
        lbl_status.text = model.holiday_bookingObj?.booking_status
        lbl_bookingDate.text = model.holiday_bookingObj?.bookingDate
        if model.holiday_bookingObj?.booking_status == "BOOKING_CONFIRMED" {
            btn_cancel.isHidden = false
        }else{
            btn_cancel.isHidden = true
        }
        //lbl_price.text = String(format: "%@ %.2f", model.currency!, model.total_fare!)
    }
}
