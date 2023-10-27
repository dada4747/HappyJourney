//
//  TransferSearchCititesVC.swift
//  CheapToGo
//
//  Created by Provab1151 on 29/01/20.
//  Copyright © 2020 Provab Technosoft Pvt Ltd. All rights reserved.
//

import UIKit

// protocol
@objc protocol transferSearchCitiesDelegate {
    
    @objc optional func transferSearchCities_info(cityInfo: [String: Any])
}

class TransferSearchCititesVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var tbl_search: UITableView!
    
    // variables
    var searchMainArray: [[String: Any]] = []
    var searchDisplayArray: [[String: Any]] = []
    
    var delegate: transferSearchCitiesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // textfield...
        tf_search.delegate = self
        tf_search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // table deleagtes...
        tbl_search.delegate = self
        tbl_search.dataSource = self
        tbl_search.rowHeight = UITableView.automaticDimension
        tbl_search.estimatedRowHeight = 30.0
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension TransferSearchCititesVC: UITextFieldDelegate {
    
    // MARK:- UITextFieldDelegate
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            
            // search city api
            gettingTransferCitiesList(cityText: textField.text!)
        }
        else {
            searchDisplayArray = searchMainArray
        }
        tbl_search.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TransferSearchCititesVC: UITableViewDataSource, UITableViewDelegate {
    
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
        cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["city_name"]  as? String

        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.transferSearchCities_info?(cityInfo: searchDisplayArray[indexPath.row])
        self.navigationController?.popViewController(animated: false)
    }
}

extension TransferSearchCititesVC {
    
    // MARK:- API's
//    func gettingTransferCitiesList(cityText: String) -> Void {
//
//        // params...
//        let params: [String: String] = ["char": cityText]
//
//        // calling api...
//        VKAPIs.shared.getRequestXwwwform(params: params, file: TRANSFER_Get_City_List, httpMethod: .POST)
//        { (resultObj, success, error) in
//
//            // success status...
//            if success == true {
//                print("Transfer City List: \(String(describing: resultObj))")
//
//                // response date...
//                if let result_dict = resultObj as? [String: Any] {
//
//                    if let data_array = result_dict["list"] as? [[String: String]] {
//                        self.searchMainArray = data_array
//                        self.searchDisplayArray = data_array
//                        self.tbl_search.reloadData()
//                    }
//                }
//            } else {
//                print("Transfer City error : \(String(describing: error?.localizedDescription))")
//            }`
//        }
//    }
    func gettingTransferCitiesList(cityText: String) -> Void {
        
        // params...
        let params: [String: String] = ["char": cityText] //char
        
        // calling api...
        VKAPIs.shared.getRequestXwwwform(params: params, file: TRANSFER_Get_City_List, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Transfer City List: \(String(describing: resultObj))")
                
                // response date...
                if let result_dict = resultObj as? [String: Any] {
                    
                    if let data_array = result_dict["list"] as? [[String: Any]] {
                        self.searchMainArray = data_array
                        self.searchDisplayArray = data_array
                        self.tbl_search.reloadData()
                    }
                }
            } else {
                print("Transfer City error : \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
