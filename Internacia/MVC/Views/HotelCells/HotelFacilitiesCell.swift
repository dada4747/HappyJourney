//
//  HotelFacilitiesCell.swift
//  Internacia
//
//  Created by Admin on 01/12/22.
//

import UIKit
protocol ShowMoreFacilitiesDelegate {
    func showMorwFacilities()
}
class HotelFacilitiesCell: UITableViewCell {

    @IBOutlet weak var btn_show_more: UIButton!
    @IBOutlet weak var tlb_facility: UITableView!
    var facility_array : [String] = []
    
    @IBOutlet weak var tblHConstraint: NSLayoutConstraint!
    var delegate : ShowMoreFacilitiesDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addDelegate()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addDelegate(){
        tlb_facility.delegate = self
        tlb_facility.dataSource = self
        tlb_facility.rowHeight = UITableView.automaticDimension
        tlb_facility.estimatedRowHeight = 45
//        tlb_facility.frame.size.height = 180
    }
    
    @IBAction func showMoreFacilityAction(_ sender: Any) {
        delegate?.showMorwFacilities()
    }
    
    func displayInfo(){
        print(facility_array.count)
        tblHConstraint.constant = CGFloat(facility_array.count * 45)
        
        tlb_facility.reloadData()

    }
    
}
extension HotelFacilitiesCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facility_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
        if cell == nil {
            tableView.register(UINib(nibName: "FacilityCell", bundle: nil), forCellReuseIdentifier: "FacilityCell")
        cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
        }
        cell?.selectionStyle = .none
        cell?.lbl_facility.text = facility_array[indexPath.row]
        return cell!
    }
}
