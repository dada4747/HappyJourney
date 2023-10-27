//
//  RecommendHotelsCVCell.swift
//  HappyJourney
//
//  Created by Admin on 24/02/23.
//

import UIKit

class RecommendHotelsCVCell: UICollectionViewCell {

    @IBOutlet weak var review_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rating_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_rating: FloatRatingView!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var lbl_hotelNames: UILabel!
    
    @IBOutlet weak var lbl_city: UILabel!
    
    @IBOutlet weak var view_rating_review: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
