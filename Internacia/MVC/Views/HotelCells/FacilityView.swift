//
//  ToursPackageType.swift
//  ExtactTravel
//
//  Created by Admin on 11/08/22.
//

import UIKit
//MARK: - Enums

class FacilitiesView: UIView {
    //MARK: - IBOutlets
    @IBOutlet weak var btn_hideView: UIButton!
    @IBOutlet weak var view_packageView: CRView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var tbl_pakage: UITableView!
    @IBOutlet weak var tbl_HConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!

    //MARK: - Variables

    var facilitiesArray: [String] = []
    //MARK: - Override Methods
    override func draw(_ rect: CGRect) {
        print("called : %@", self)
        self.tbl_pakage.delegate = self
        self.tbl_pakage.dataSource = self
    }
    
    class func loadViewFromNib() -> UIView {
        // load xib view...
        let view = Bundle.main.loadNibNamed("FacilitiesView", owner: self, options: nil)?.first as? FacilitiesView
        view?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        return view!
    }
    
    //MARK: - IB Actions
    @IBAction func hide_viewButton(_ sender: UIButton) {
        self.isHidden = true
    }
    //MARK: - Display Information
    func displayInfo() {
        var maxHeight: Float = Float(UIScreen.main.bounds.size.height)
        maxHeight = maxHeight - 100
        lbl_title.text = "Hotel Facilities"
    
        // current table height...
        var tblHeight = 0
        tblHeight = (facilitiesArray.count * 45) + 50
        
        if maxHeight >= Float(tblHeight) {
            tbl_HConstraint.constant = CGFloat(tblHeight)
            tbl_pakage.isScrollEnabled = false
        }
        else {
            tbl_HConstraint.constant = CGFloat(maxHeight)
            tbl_pakage.isScrollEnabled = true
        }
        
        tbl_pakage.reloadData()
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension FacilitiesView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int = 1
        
        return facilitiesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
        if cell == nil {
            tableView.register(UINib(nibName: "FacilityCell", bundle: nil), forCellReuseIdentifier: "FacilityCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FacilityCell") as? FacilityCell
        }
        
        cell?.lbl_facility.text = facilitiesArray[indexPath.row]
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
