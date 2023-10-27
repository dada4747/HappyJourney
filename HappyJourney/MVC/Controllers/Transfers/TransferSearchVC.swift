//
//  TransferSearchVC.swift
//  ExtactTravel
//
//  Created by Admin on 22/08/22.
//

import UIKit

class TransferSearchVC: UIViewController {
    
    // Outlets...
    @IBOutlet weak var txt_city: UITextField!
    
    // Localization...
    @IBOutlet weak var lbl_transferLoc: UILabel!
//    @IBOutlet weak var lbl_enterLoc: UILabel!
    
    var city_dict:[String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .appColor
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ButtonAciton
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func citySearchBtnClicked(_ sender: Any) {
        
        let searchObj = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransferSearchCititesVC") as! TransferSearchCititesVC
        searchObj.delegate = self
        self.navigationController?.pushViewController(searchObj, animated: true)
    }
    
    @IBAction func searchBtnClicked(_ sender: Any) {
//print(city_dict)
        if city_dict.isEmpty == true {
            view.makeToast(message: "Please enter city")
        } else {
            let listObj = TRANSFER_STORYBOARD.instantiateViewController(withIdentifier: "TransferSearchListVC") as! TransferSearchListVC
            
            //        listObj.city_dict["label"] = "Bangalore" as? Any
            //        listObj.city_dict["id"] = "1262"
            listObj.city_dict = city_dict
            self.navigationController?.pushViewController(listObj, animated: true)
        }
    }
    
}

extension TransferSearchVC : transferSearchCitiesDelegate {
    
    // MARK: - transferSearchCitiesDelegate
    func transferSearchCities_info(cityInfo: [String : Any]) {
        
        txt_city.text = cityInfo["city_name"] as? String ?? ""
        city_dict = cityInfo
    }
}
