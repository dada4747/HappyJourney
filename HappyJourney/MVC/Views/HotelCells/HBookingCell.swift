//
//  HBookingCell.swift
//  Travelomatix
//
//  Created by Anand S on 17/08/21.
//

import UIKit
protocol HBookingCellDelegate {
    func viewHotelVoucher(model: DHotelHistoryItem )
    func cancelBooking(model: DHotelHistoryItem)
}
class HBookingCell: UITableViewCell {
    
    @IBOutlet weak var img_hotel: UIImageView!
    @IBOutlet weak var lbl_checkIn: UILabel!
    @IBOutlet weak var lbl_checkOut: UILabel!
    @IBOutlet weak var lbl_bookingId: UILabel!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var lbl_nights: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_refund: UILabel!

    @IBOutlet weak var btn_viewVoucher: CRButton!
    
    @IBOutlet weak var btn_cancelBooking: CRButton!
    
    @IBOutlet weak var lbl_status: UILabel!
    var hbookingModel : DHotelHistoryItem?
    var delegate : HBookingCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayHotelBooking(model: DHotelHistoryItem) {
        hbookingModel = model
        lbl_refund.isHidden = true
        // display information...
        //img_hotel.sd_setImage(with: URL.init(string: model.hotel_img!))
        lbl_checkIn.text = model.hotel_check_in
        lbl_checkOut.text = model.hotel_check_out
        lbl_bookingId.text = model.booking_id
        lbl_hotelName.text = model.hotel_name
        lbl_hotelAddress.text = model.address
        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "$",(Float(model.total_fare) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
//        lbl_nights.text = String(format: "%d Days", model.)
        if model.booking_status == "BOOKING_CONFIRMED" {
            btn_cancelBooking.isHidden = false
            lbl_status.textColor = .systemGreen
        }else{
            btn_cancelBooking.isHidden = true
            lbl_status.textColor = .black
        }
        lbl_status.text = model.booking_status
        
        
    }
    @IBAction func viewVoucherAction(_ sender: UIButton) {
        delegate?.viewHotelVoucher(model: hbookingModel!)
    }
    
    @IBAction func cancelBookingAction(_ sender: UIButton) {
        delegate?.cancelBooking(model: hbookingModel!)
    }
    
}
