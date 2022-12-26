//
//  TopDestinationCVCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
class TopDestinationCVCell: UICollectionViewCell {
    
    @IBOutlet weak var image_hotel: UIImageView!
    @IBOutlet weak var lbl_hotelCity: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var img_loc: UIImageView!
    @IBOutlet weak var lbl_exp: UILabel!
    @IBOutlet weak var view_dest: RoundedView!
    //    var topDestinationHotelsDelegate: TopDestinationHotelProtocol?
    @IBOutlet weak var lbl_fromTo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    // MARK:- Helpers
    func displayTrendingHotelInformation(model: DCommonTrendingHotelItems) {
        // display information...
        image_hotel.sd_setImage(with: URL.init(string: model.hotel_img_url!))
        lbl_hotelCity.text = model.cityName
        lbl_exp.text = "( " + model.hotelCount! + " hotels )"
    }
    func displayFlightInfo(model: DCommonTrendingFlightItem) {
        // display information...
        image_hotel.sd_setImage(with: URL.init(string: model.image!))
        view_dest.isHidden = true
        lbl_fromTo.text = "\(model.from_airport_name ?? "") - \(model.to_airport_name ?? "")"
    }
    func displaybusInfo(model: DCommonTrendingBusesItem) {
        image_hotel.sd_setImage(with: URL.init(string: model.imageStr!))
        view_dest.isHidden = true
        lbl_fromTo.text = "\(model.from_bus_name ?? "") - \(model.to_bus_name ?? "")"
    }
}
