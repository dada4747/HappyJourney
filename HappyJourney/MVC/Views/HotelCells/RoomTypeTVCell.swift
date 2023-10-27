//
//  RoomTypeTVCell.swift
//  HappyJourney
//
//  Created by Admin on 05/04/23.
//

import UIKit

class RoomTypeTVCell: UITableViewCell {

    @IBOutlet weak var lbl_room_type: UILabel!
    @IBOutlet weak var img_type: UIImageView!
    @IBOutlet weak var img_checkbox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class RoomTypeModel {
    var img_type: String? = ""
    var img_selected: Bool = true
    var roomType: String? = ""
    
    init() {
        
    }
}
