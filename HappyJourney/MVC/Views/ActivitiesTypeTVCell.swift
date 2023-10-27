//
//  ActivitiesTypeTVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 26/08/21.
//

import UIKit

class ActivitiesTypeTVCell: UITableViewCell {
    @IBOutlet weak var lbl_categoryName: UILabel!
    @IBOutlet weak var btn_checkBox: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func displayData(obj: ActivitiesTypeModel) {
        lbl_categoryName.text = obj.category_name
        if obj.isSelected ?? false{
            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
        }else{
            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
//    func displayData(obj: RegionsModel) {
//        lbl_categoryName.text = obj.regionName
//        if obj.isSelected ?? false{
//            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
//        }else{
//            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//        }
//    }
//    func displayData(obj: CountrysModel) {
//        lbl_categoryName.text = obj.countryName
//        if obj.isSelected ?? false{
//            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
//        }else{
//            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//        }
//    }
//    func displayData(obj: DurationsModel) {
//        lbl_categoryName.text = obj.duration
//        if obj.isSelected ?? false{
//            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
//        }else{
//            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//        }
//    }
//    func displayData(obj: ActivitiesModel) {
//        lbl_categoryName.text = obj.name
//        if obj.isSelected ?? false{
//            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
//        }else{
//            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//        }
//    }
//    func displayData(obj: ThemeModel) {
//        lbl_categoryName.text = obj.name
//        if obj.isSelected ?? false{
//            btn_checkBox.setImage(UIImage(named: "checked"), for: .normal)
//        }else{
//            btn_checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
//        }
//    }
}
