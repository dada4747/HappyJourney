//
//  OpeningHoursCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 13/07/21.
//

import UIKit

class OpeningHoursCell: UITableViewCell {
    @IBOutlet weak var lbl_pick_openingHrs: UILabel!
    @IBOutlet weak var lbl_drop_openingHrs: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
