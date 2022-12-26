//
//  HotelRoomsListCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// protocol...
protocol hRoomsListCellDelegate {
    func roomSeletion_Action(sender: UIButton, cell: UITableViewCell)
    func cancelPolicy_Action(sender: UIButton, cell: UITableViewCell)
}


// class...
class HotelRoomsListCell: UITableViewCell {

    // MARK:- Outlet
    @IBOutlet weak var lbl_roomName: UILabel!
    @IBOutlet weak var lbl_amenties: UILabel!
    @IBOutlet weak var lbl_refundStatus: UILabel!

    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_noofNights: UILabel!
    
    @IBOutlet weak var view_selected: UIView!
    @IBOutlet weak var img_selectImg: UIImageView!
    @IBOutlet weak var lbl_select: UILabel!
    @IBOutlet weak var lblSelect_XConstrint: NSLayoutConstraint! // default 32... 25
    
    var delegate: hRoomsListCellDelegate?
    var defaultColor = UIColor.init(red: 237.0/255.0, green: 28.0/255.0, blue: 35.0/255.0, alpha: 1.0)
    
    // MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultColor = lbl_price.textColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
    func displayRooms_information(rModel: DHotelRoomItem) {
        
        // room info...
        lbl_roomName.text = rModel.room_name
        lbl_amenties.text = ""
        if rModel.amenities_array.count != 0 {
            lbl_amenties.text = "♨ " + rModel.amenities_array.joined(separator: "\n♨ ")
        }
        
        // selection buttons...
        view_selected.backgroundColor = UIColor.white
        lbl_select.textColor = .secInteraciaBlue// defaultColor
        img_selectImg.isHidden = true
        lblSelect_XConstrint.constant = 25
        
        // price info....
        lbl_price.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", rModel.room_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))//String(format: "%@ %.2f", rModel.currency, rModel.room_price)
        lbl_noofNights.text = "( \(DHTravelModel.noof_nights) Nights )"
        
        lbl_refundStatus.text = "Not Refundable"
        if rModel.is_refundable == true {
            lbl_refundStatus.text = "Refundable"
        }
    }
    
    // MARK:- ButtonActions
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        delegate?.roomSeletion_Action(sender: sender, cell: self)
    }
    
    @IBAction func cancelPolicyButtonClicked(_ sender: UIButton) {
        delegate?.cancelPolicy_Action(sender: sender, cell: self)
    }
}


