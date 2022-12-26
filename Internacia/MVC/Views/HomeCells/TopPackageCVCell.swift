//
//  TopPackageCVCell.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit
protocol TopPackageCellProtocol {
    func topSelectedPAckage(index: Int, cell: UICollectionViewCell)
}
class TopPackageCVCell: UICollectionViewCell {
    @IBOutlet weak var view_image: RoundedImageView!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_packageName: UILabel!
    @IBOutlet weak var lbl_packageAmount: UILabel!
    var index : Int?
    var topPackageCellDelegate: TopPackageCellProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayTrendingPackageInfo(model: DCommonTrendingPackageItem) {
        view_image.sd_setImage(with: URL.init(string: model.image!))
        lbl_location.text = model.package_location
        lbl_packageName.text = model.package_name
        lbl_packageAmount.text = model.price
    }
    
    @IBAction func viewDetailsAction(_ sender: Any) {
        topPackageCellDelegate?.topSelectedPAckage(index: index! , cell: self)
    }
}
