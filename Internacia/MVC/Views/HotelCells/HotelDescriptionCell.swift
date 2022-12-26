//
//  HotelDescriptionCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol
protocol hDescriptionCellDelegate {
    func showMoreButtonClicked(sender: UIButton, cell: UITableViewCell)
}

// class...
class HotelDescriptionCell: UITableViewCell {

    // MARK:- Outlet
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var btn_showMore: UIButton!
    var delegate: hDescriptionCellDelegate?
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK:- ButtonAction
    @IBAction func showMoreButtonClicked(_ sender: UIButton) {
        delegate?.showMoreButtonClicked(sender: sender, cell: self)
    }
}


