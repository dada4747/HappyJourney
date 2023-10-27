//
//  PromoCodesViewController.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 17/05/21.
//

import UIKit
protocol PromoCodeSelection:class {
    func promocodeSelected(obj: [String: Any])
}
class PromoCodesViewController: UIViewController {
    @IBOutlet weak var tbl_PromoCodesList: UITableView!
    
    
    var promoCodesList: [[String: Any]] = []
   weak var delegate: PromoCodeSelection?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tbl_PromoCodesList.register(UINib(nibName: "PromocodesTVCell", bundle: .main), forCellReuseIdentifier: "PromocodesTVCell")
        getPromoCodesAPICall()
    }
    
    func getPromoCodesAPICall(){
                
        VKAPIs.shared.getRequestFormdata(params: nil, file: "general/all_promo", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("flightSearch Response: \(String(describing: resultObj))")
                
                if let result_dict = resultObj as? [String: Any] {
                    if let data = result_dict["data"] as? [[String: Any]]{
                        self.promoCodesList = data
                        self.tbl_PromoCodesList.reloadData()
                    }
                } else {
                    print("flightSearch Response: formate : \(String(describing: resultObj))")
                }
            } else {
                print("flightSearch Response error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            SwiftLoader.hide()
        }
    }
    
    @IBAction func back_Clicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension PromoCodesViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promoCodesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromocodesTVCell", for: indexPath as IndexPath) as! PromocodesTVCell
        cell.selectionStyle = .none
        
        cell.displayData(obj: promoCodesList[indexPath.row])
        cell.btn_apply.tag = indexPath.row
        cell.btn_apply.addTarget(self, action: #selector(applyBtnAction), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    @objc func applyBtnAction(sender:UIButton){
      
        delegate?.promocodeSelected(obj: self.promoCodesList[sender.tag])
        self.navigationController?.popViewController(animated: true)
    }
}
