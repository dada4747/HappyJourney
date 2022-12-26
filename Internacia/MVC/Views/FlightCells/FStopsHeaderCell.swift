//
//  FStopsHeaderCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FStopsHeaderCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var lbl_fromCity: UILabel!
    @IBOutlet weak var lbl_toCity: UILabel!
    
    @IBOutlet weak var lbl_journeyDate: UILabel!
    @IBOutlet weak var lbl_noofPassengers: UILabel!
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func display_information(headModel: DFlightStopsHeadItem) {
        
        lbl_fromCity.text = headModel.from_cityCode
        lbl_toCity.text = headModel.to_cityCode
        lbl_journeyDate.text = headModel.start_date
        lbl_noofPassengers.text = "\(headModel.noof_passengers) Passengers"
    }
    /*
    func displayHistory_information(headModel: DFHistoryStopsHeadItem) {
        
        lbl_fromCity.text = headModel.from_cityCode
        lbl_toCity.text = headModel.to_cityCode
        lbl_journeyDate.text = headModel.start_date
        lbl_noofPassengers.text = "\(headModel.noof_passengers) Passengers"
    } */
}


