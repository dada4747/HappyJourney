//
//  SearchHotelCitiesVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

// protocol
@objc protocol searchHotelCitiesDelegate {
    @objc optional func searchHotel_info(hotelInfo: [String: String])
}

// class...
class SearchHotelCitiesVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tbl_search: UITableView!
    @IBOutlet weak var view_header: UIView!
    
    // variables
    var searchMainArray: [[String: String]] = []
    var searchDisplayArray: [[String: String]] = []
   
    var delegate: searchHotelCitiesDelegate?
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_header.viewShadow()
        // textfield...
        tf_search.delegate = self
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // table deleagtes...
        tbl_search.delegate = self
        tbl_search.dataSource = self
        tbl_search.rowHeight = UITableView.automaticDimension
        tbl_search.estimatedRowHeight = 48
        
        gettingDisplayInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helpers
    func gettingDisplayInformation() {
        
        // getting airline...
        tf_search.placeholder = "Please enter city"
        if DStorageModel.hotelCitiesArray.count == 0 {
            DStorageModel.gettingHotelCitiesList()
        }
        searchMainArray = DStorageModel.hotelCitiesArray
        textFieldDidChange(tf_search)
        
//        tbl_search.reloadData()
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
    
}

extension SearchHotelCitiesVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {

            // search predicate...
            let predicate: NSPredicate = NSPredicate(format: "(country contains[c] %@) OR (city contains[c] %@)", textField.text!, textField.text!)
            let loArray = (searchMainArray as NSArray).filtered(using: predicate) as NSArray
            searchDisplayArray = loArray as! [[String: String]]
        }
//        else {
//            searchDisplayArray = searchMainArray
//        }
        tbl_search.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension SearchHotelCitiesVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDisplayArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchCitiesCell", bundle: nil), forCellReuseIdentifier: "SearchCitiesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        }
        
        // display information...
        cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["city"]! + ", " + searchDisplayArray[indexPath.row]["country"]!
     
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchHotel_info!(hotelInfo: searchDisplayArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

