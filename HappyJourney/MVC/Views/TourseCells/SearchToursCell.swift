//
//  SearchToursCell.swift
//  ExtactTravel
//
//  Created by Admin on 12/08/22.
//

import UIKit
protocol viewDetailButtonDelegate {
    func selectCell(selected: String)
}
class SearchToursCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet weak var view_cell: UIView!
    @IBOutlet weak var lbl_packageName: UILabel!
    @IBOutlet weak var lbl_packageCode: UILabel!
    @IBOutlet weak var lbl_packagePrice: UILabel!
    @IBOutlet weak var lbl_packageDuration: UILabel!
    @IBOutlet weak var lbl_packageLocation: UILabel!
    @IBOutlet weak var lbl_packageTypeId: UILabel!
    @IBOutlet weak var imageView_pakageImage: UIImageView!
    @IBOutlet weak var star_rating: FloatRatingView!
    var packageModel: TourPackageItem?
    var viewDetailDelegate : viewDetailButtonDelegate?
    //MARK: - lifecycle methods
    override func awakeFromNib() {
        super.awakeFromNib()
        view_cell.viewShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - set information method
    func setInfo(model: TourPackageItem){
        self.packageModel = model
        self.lbl_packageName.text = model.packageName
        self.lbl_packageCode.text = model.packageCode
        self.lbl_packagePrice.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", ((model.price) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// model.price
        self.lbl_packageDuration.text = String(format: "%@ %@", String(model.duration!), "Days")
        self.lbl_packageLocation.text = model.packageLocation
        self.lbl_packageTypeId.text = model.packageType
        let url = URL.init(string: model.image)
        imageView_pakageImage.sd_setImage(with: url, completed: nil)// sd_setImage(with: url )
        self.star_rating.rating = Double(model.rating!)

    }
    @IBAction func viewDetailClicked(_ sender: Any) {
        self.viewDetailDelegate?.selectCell(selected: packageModel!.packageID)
    }
    
}
