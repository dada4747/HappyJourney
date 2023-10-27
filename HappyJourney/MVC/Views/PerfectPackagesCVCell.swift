//
//  PerfectPackagesCVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 30/08/21.
//

import UIKit

class PerfectPackagesCVCell: UICollectionViewCell {
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_bg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    func displayData(obj: DCommonPerfectCarsItems_Packages) {
////        lbl_name.text = "Holidays"
//        lbl_name.text = obj.airportName
//        img_bg.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
//    func displayData(obj: DCommonPerfectHolidaysItems_Packages) {
////        lbl_name.text = "Holidays"
//        lbl_name.text = obj.package_name
//        img_bg.sd_setImage(with: URL.init(string: obj.image_activity!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
    func displayData(obj: DCommonPerfectActivitiesItems_Packages) {
        lbl_name.text = "Activities"
        img_bg.sd_setImage(with: URL.init(string: obj.banner_image!), placeholderImage: UIImage.init(named: "DummyBG2"))
    }
//    func displayData(obj: DCommonPerfectTransfersItems_Packages) {
//        lbl_name.text = "Transfers"
//        img_bg.sd_setImage(with: URL.init(string: obj.banner_image!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
//    func displayData(obj: DCommonPerfectHotelsItems_Packages) {
//        lbl_name.text = "Hotels"
//        img_bg.sd_setImage(with: URL.init(string: obj.banner_image!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
//    func displayData(obj: DCommonPerfectFlightsItems_Packages) {
//        lbl_name.text = "Flights"
//        img_bg.sd_setImage(with: URL.init(string: obj.banner_image!), placeholderImage: UIImage.init(named: "DummyBG2"))
//    }
}
