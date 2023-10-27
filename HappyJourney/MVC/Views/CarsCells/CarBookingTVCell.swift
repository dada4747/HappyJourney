//
//  CarBookingTVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 26/07/21.
//

import UIKit

class CarBookingTVCell: UITableViewCell {
    @IBOutlet weak var lbl_pickupDate: UILabel!
    @IBOutlet weak var lbl_dropDate: UILabel!
    @IBOutlet weak var lbl_carName: UILabel!
    @IBOutlet weak var lbl_bookingID: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_pickup_Loc: UILabel!
    @IBOutlet weak var lbl_drop_Loc: UILabel!
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
    
    func displayHotelBooking(model: DCarHistoryItem){
        lbl_pickupDate.text = model.car_from_Date
        lbl_dropDate.text = model.car_to_Date
        lbl_bookingID.text = model.booking_id
        lbl_carName.text = model.car_name
        lbl_price.text = model.total_fare
        lbl_pickup_Loc.text = model.pickup_Loc
        lbl_drop_Loc.text = model.drop_Loc
        
        lbl_status.text = model.booking_status
        if model.booking_status == "BOOKING_CONFIRMED" {
            btn_cancel.isHidden = false
        }else{
            btn_cancel.isHidden = true
        }
        lbl_price.text = String(format: "%@ %@",DCurrencyModel.currency_saved?.currency_symbol ?? "", (Float(model.total_fare!)! * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String(format: "%@ %.2f", model.currency!, model.total_fare!)

    }
    
}
