//
//  PassengerCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol passengerCellDelegate {
    func selectionButton_Action(sender: UIButton, cell: UITableViewCell)
    func editButton_Action(sender: UIButton, cell: UITableViewCell)
}

// class...
class PassengerCell: UITableViewCell {

    // variables...
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_checkMark: UIButton!
    
    @IBOutlet weak var view_display: UIView!
    @IBOutlet weak var lbl_displayName: UILabel!
    
    var delegate: passengerCellDelegate?
    
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayPassenger_information(model: DPassengerItem) {
        
        lbl_name.text = String(format: "%@ %@ %@", model.title_name!, model.first_name!,  model.last_name!)
        btn_checkMark.setImage(UIImage.init(named: "ic_square_check"), for: .normal)
        if model.isSelected == true {
            btn_checkMark.setImage(UIImage.init(named: "ic_square_checked"), for: .normal)
        }
    }
    
    
    // MARK:- ButtonActions
    @IBAction func selectionButtonClicked(_ sender: UIButton) {
        delegate?.selectionButton_Action(sender: sender, cell: self)
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        delegate?.editButton_Action(sender: sender, cell: self)
    }
    
}


