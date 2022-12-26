//
//  HSearchListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol hSearchListCellDelegate {
    func hotelBooking_Action(sender: UIButton, cell: UITableViewCell)
    func hotelAddWishlist_Action(sender: UIButton, cell: UITableViewCell)
}


// class...
class HSearchListCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var img_hotel: UIImageView!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    
    @IBOutlet weak var img_wifi: UIImageView!
    @IBOutlet weak var img_breakfast: UIImageView!
    @IBOutlet weak var img_parking: UIImageView!
    @IBOutlet weak var img_swim: UIImageView!
    @IBOutlet weak var rating_view: FloatRatingView!
    @IBOutlet weak var lbl_price: UILabel!
    //@IBOutlet weak var lbl_refundStatus: UILabel!
    
    @IBOutlet weak var btn_wishlist: UIButton!
    var delegate: hSearchListCellDelegate?
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        rating_view.type = .floatRatings
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_hotelsearchInformation(hModel: DHotelSearchItem) {
        
        // display information...
        img_hotel .sd_setImage(with: URL.init(string: hModel.hotel_img!))
        lbl_hotelName.text = hModel.hotel_name
        lbl_hotelAddress.text = hModel.hotel_address
        
        //amenities...
        img_wifi.alpha = 0.3
        img_breakfast.alpha = 0.3
        img_parking.alpha = 0.3
        img_swim.alpha = 0.3
        if hModel.wifi == true {
            img_wifi.alpha = 1.0
        }
        if hModel.breakfast == true {
            img_breakfast.alpha = 1.0
        }
        if hModel.parking == true {
            img_parking.alpha = 1.0
        }
        if hModel.swim == true {
            img_swim.alpha = 1.0
        }
        rating_view.rating = Double(hModel.hotel_rating)
        
        lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", (hModel.hotel_price + hModel.hotel_gst)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", hModel.hotel_currency, hModel.hotel_price)
        //lbl_refundStatus.text = "Not refundable"
        btn_wishlist.setImage(UIImage(named: "ic_wishlist"), for: .normal)
        if hModel.isWishlisted == true {
            btn_wishlist.setImage(UIImage(named: "ic_wishlist_sel"), for: .normal)
        }
    }
//    func displayWishData(hModel: DWishlistItem) {
//        
//        // display information...
//        img_hotel.sd_setImage(with: URL.init(string: (hModel.wishkey?.hotel_img)!))
//        lbl_hotelName.text = hModel.wishkey?.hotel_name
//        lbl_hotelAddress.text = hModel.wishkey?.hotel_address
//        
//        //amenities...
//        img_wifi.alpha = 0.3
//        img_breakfast.alpha = 0.3
//        img_parking.alpha = 0.3
//        img_swim.alpha = 0.3
//        rating_view.rating = 0// Double(hModel.wishkey.hotel_rating)!
//        
//        lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", hModel.wishkey!.hotel_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", hModel.hotel_currency, hModel.hotel_price)
//        //lbl_refundStatus.text = "Not refundable"
//    }
    
    // MARK:- ButtonAction
    @IBAction func bookingButtonClicked(_ sender: UIButton) {
        delegate?.hotelBooking_Action(sender: sender, cell: self)
    }
    @IBAction func addWishlistButtonClicked(_ sender: UIButton) {
        delegate?.hotelAddWishlist_Action(sender: sender, cell: self)
    }
}


