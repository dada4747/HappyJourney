//
//  TransferAgeBandsCell.swift
//  ExtactTravel
//
//  Created by Admin on 22/08/22.
//

import UIKit

protocol transferAgeBandDelegate {
    
    func addTraveller_Action(sender: UIButton, cell: UITableViewCell)
    func minusTraveller_Action(sender: UIButton, cell: UITableViewCell)
}

class TransferAgeBandsCell: UITableViewCell {

    @IBOutlet weak var lbl_travellerType: UILabel!
    @IBOutlet weak var lbl_travellerCount: UILabel!
    @IBOutlet weak var btn_plus: UIButton!
    @IBOutlet weak var btn_minus: UIButton!
    
    var delegate: transferAgeBandDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Button Action
    @IBAction func addBtnClicked(_ sender: UIButton) {
        delegate?.addTraveller_Action(sender: sender, cell: self)
    }
    
    @IBAction func minusBtnClicked(_ sender: UIButton) {
        delegate?.minusTraveller_Action(sender: sender, cell: self)
    }
}
