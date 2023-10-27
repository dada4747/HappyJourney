//
//  FilterCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 19/07/21.
//

import UIKit

class FilterCell: UITableViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_checkBox: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
