//
//  HomeOffersCVCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class HomeOffersCVCell: UICollectionViewCell {
    
    // Outlets...
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_promoCode: UILabel!
    @IBOutlet weak var img_url_promo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:- Helper
    func displayTopOffersInformation(model: DCommonTopOfferItems){
        
        // display information...
        
        img_url_promo .sd_setImage(with: URL.init(string: model.promo_img_url!))
        lbl_description.text = model.promoDescription
        lbl_promoCode.text = model.promoCode
        
    }

}
