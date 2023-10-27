//
//  CancellationPolicyCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 13/07/21.
//

import UIKit

class CancellationPolicyCell: UITableViewCell {
    @IBOutlet weak var lbl_content: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func displayContent(obj: CancellationPolicy_Model){
        let amt = obj.Amount ?? ""
        let currency = obj.CurrencyCode ?? ""
        let from = obj.FromDate ?? ""
        let to = obj.ToDate ?? ""
        let text = " Amount would be charged between "
        self.lbl_content.text = amt + currency + text + from + " to " + to
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
