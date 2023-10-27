//
//  TransferCustomerReviewCell.swift
//  ExtactTravel
//
//  Created by Admin on 22/08/22.
//

import UIKit
class TransferCustomerReviewCell: UITableViewCell {

    @IBOutlet weak var star_rating: FloatRatingView!
    @IBOutlet weak var lbl_customerName: UILabel!
    @IBOutlet weak var img_user: UIImageView!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func displayInfo(model: DTransDetailCustReviewItem){
        lbl_customerName.text = model.customer_name
        lbl_description.text = model.customer_review
        lblDate.text = model.published_date
        let imgUrl = model.customer_image
        if ((imgUrl?.isEmpty) != true) {
            img_user.sd_setImage(with: URL.init(string: imgUrl!) , completed: nil)
        }
//        star_rating.rating = model.customer_rating!
        
    }
}
