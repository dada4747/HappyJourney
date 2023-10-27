//
//  ExtraCoverageCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 14/07/21.
//

import UIKit

class ExtraCoverageCell: UITableViewCell {
    @IBOutlet weak var btn_check: UIButton!
    @IBOutlet weak var btn_dropDown: UIButton!
    @IBOutlet weak var img_coverageType: UIImageView!
    @IBOutlet weak var lbl_coverageType: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var tbl_coverage: UITableView!
    @IBOutlet weak var txt_dropDown: UITextField!
    @IBOutlet weak var view_dropDown: UIView!
    @IBOutlet weak var view_selection: UIView!
    @IBOutlet weak var hei_coverageConstraint: NSLayoutConstraint!

    var policy_description: policy_description_Model?
    var reloadMaintable : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let headerNib = UINib.init(nibName: "FullProtectionView", bundle: nil)
        tbl_coverage.register(headerNib, forHeaderFooterViewReuseIdentifier: "FullProtectionView")
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func displayData(model: PricedEquip_Model){
        self.policy_description = model.policy_description

        view_dropDown.isHidden = true
        view_selection.isHidden = true
        if model.name == "Child" || model.name == "Infant" || model.name == "Booster"{
            view_dropDown.isHidden = false
        }else{
            view_selection.isHidden = false
        }
        
        img_coverageType.image = UIImage(named: "driver_gray")
        if model.EquipType == "13" {
            img_coverageType.image = UIImage(named: "gps_gray")
        }
        
        txt_dropDown.text = "0" ///cell.txt_dropDown.text = elemtDict[@"ChildCount"];
        if model.seatCount ?? 0 > 0{
            txt_dropDown.text = String(model.seatCount!)
        }
        
        btn_check.setImage(UIImage(named: "unchecked"), for: .normal)
        if model.isSelected == true{
            btn_check.setImage(UIImage(named: "checked"), for: .normal)
        }
//        cell.lbl_description.text = @"";
//        cell.hei_coverageConstraint.constant = 0;
        lbl_description.text = ""
        hei_coverageConstraint.constant = 0
        
        
        let des = model.Description ?? ""
        let currency = model.CurrencyCode ?? ""
        let amt = String(model.Amount ?? 0)
        lbl_coverageType.text = String(format:"%@ %@ %@",des, currency, amt)

        
//        if ([elemtDict[@"policy_description"] isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *policyDict = elemtDict[@"policy_description"];
//            cell.lbl_description.text = [NSString stringWithFormat:@"%@",policyDict[@"Description"]];
//            if ([policyDict[@"InclusionsList"] isKindOfClass:[NSArray class]]) {
//                NSArray *policyArr = policyDict[@"InclusionsList"];
//                if (policyArr.count != 0) {
//                    [cell displayCoverageDataMethod:policyArr];
//                    cell.hei_coverageConstraint.constant = cell.tbl_coverage.contentSize.height;
//                }
//            }
//        }
//        [cell layoutIfNeeded];
        
        if self.policy_description != nil{
            lbl_description.text = self.policy_description?.Description
            if self.policy_description?.InclusionsList.count ?? 0 > 0{
                tbl_coverage.reloadData()
                hei_coverageConstraint.constant = tbl_coverage.contentSize.height
            }
        }
        self.layoutIfNeeded()
    }

}

extension ExtraCoverageCell: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.policy_description?.InclusionsList.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.policy_description?.InclusionsList[section].isExpanded == true {
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FullProtectionCell") as? FullProtectionCell
        if cell == nil {
            tableView.register(UINib(nibName: "FullProtectionCell", bundle: nil), forCellReuseIdentifier: "FullProtectionCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FullProtectionCell") as? FullProtectionCell
        }
        cell?.lbl_coverageType.text = self.policy_description?.InclusionsList[indexPath.section].Content
        return cell!
        
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section < self.policy_description?.InclusionsList.count ?? 0 {
//            return self.policy_description?.InclusionsList[section].Title
//        }
//
//        return nil
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FullProtectionView") as! FullProtectionView

        headerView.lbl_title.text = self.policy_description?.InclusionsList[section].Title
        
        headerView.btn_action.addTarget(self, action: #selector(expandCollapseSection), for: .touchUpInside)
        headerView.btn_action.tag = section

        return headerView
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    @objc func expandCollapseSection(sender:UIButton){
        if self.policy_description?.InclusionsList[sender.tag].isExpanded == true{
            self.policy_description?.InclusionsList[sender.tag].isExpanded = false
        }else{
            self.policy_description?.InclusionsList[sender.tag].isExpanded = true
        }
        tbl_coverage.reloadData()
        hei_coverageConstraint.constant = tbl_coverage.contentSize.height + 10
        self.layoutIfNeeded()
        
        if let reload = self.reloadMaintable{
            reload()
        }
    }
    
    
}
