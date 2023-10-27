//
//  BestTransferCVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 30/08/21.
//

import UIKit

class BestTransferCVCell: UICollectionViewCell {
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_banner: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func displayData(obj: DCommonTrendingActivitiesItems) {
        lbl_Name.text = obj.destination_name
        img_banner.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
    }
    
//    func displayData(obj: DCommonTrendingTransferItems) {
//        lbl_Name.text = obj.destination_name
//        img_banner.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
//    func displayData(obj: DCommonTrendingHolidaysItems) {
//        lbl_Name.text = obj.package_name
//        img_banner.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
//    func displayData(obj: DCommonTrendingCarItems) {
//        lbl_Name.text = obj.airportName
//        img_banner.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
}
