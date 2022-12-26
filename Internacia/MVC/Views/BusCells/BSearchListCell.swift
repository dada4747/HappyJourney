//
//  BSearchListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class BSearchListCell: UITableViewCell {

    @IBOutlet weak var lbl_bus_name: UILabel!
    @IBOutlet weak var lbl_bus_type: UILabel!
    
    @IBOutlet weak var lbl_depart_time: UILabel!
    
    @IBOutlet weak var lbl_arrival_time: UILabel!
    
    @IBOutlet weak var lbl_duration: UILabel!
    
    @IBOutlet weak var lbl_currency: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    
    @IBOutlet weak var lbl_seat_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayBusInfo(model: DBusesSearchItem){
        self.lbl_bus_name.text = model.CompanyName
        self.lbl_bus_type.text = model.BusTypeName
        self.lbl_depart_time.text = model.DepartureTime
        self.lbl_arrival_time.text = model.ArrivalTime
        self.lbl_duration.text = model.Duration
        self.lbl_currency.text = DCurrencyModel.currency_saved?.currency_country ?? ""
        self.lbl_price.text = String(format: "%.2f", model.Fare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_seat_count.text = "\(model.AvailableSeats)"
    }
}
