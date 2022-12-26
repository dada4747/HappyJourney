//
//  HotelMapCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import MapKit

class HotelMapCell: UITableViewCell {
    
    // MARK:- Outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lbl_address: UILabel!
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

