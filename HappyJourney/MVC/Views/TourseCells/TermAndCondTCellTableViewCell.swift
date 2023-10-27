//
//  TermAndCondTCellTableViewCell.swift
//  ExtactTravel
//
//  Created by Admin on 04/10/22.
//

import UIKit

class TermAndCondTCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_price_Includes: UILabel!
    @IBOutlet weak var lbl_price_Exclude: UILabel!
    @IBOutlet weak var lbl_cancellation_advance: UILabel!
    @IBOutlet weak var lbl_cancellation_penalty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(model: PackagePricePolicy){
        
        lbl_price_Includes.text = model.priceExcludes
        lbl_price_Exclude.text = model.priceExcludes
//        lbl_cancellation_advance.text = model.
//        lbl_cancellation_penalty.text = model.
    }
}
