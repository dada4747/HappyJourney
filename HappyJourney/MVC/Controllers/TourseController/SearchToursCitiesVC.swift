//
//  SearchToursCitiesVC.swift
//  ExtactTravel
//
//  Created by Admin on 11/08/22.
//

import UIKit
@objc protocol searchToursCitiesDelegate {
    @objc optional func searchCity(cityInfo: [String: Any
    ])
}
class SearchToursCitiesVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var uv_headerView: UIView!
    @IBOutlet weak var tbl_tourseListTable: UITableView!
    @IBOutlet weak var tf_searchCity: UITextField!
    //MARK: - Variables
    var searchMainArray: [[String: Any]] = []
    var searchDisplayArray: [[String: Any]] = []
    var delegate: searchToursCitiesDelegate?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        uv_headerView.viewShadow()
        setupTextfield()
        setupTableView()
        
        gettingHotelCitiesList(cityText: "")
    }
    //MARK: - Methods
    func setupTextfield(){
        tf_searchCity.delegate = self
        tf_searchCity.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    func  setupTableView(){
        tbl_tourseListTable.delegate = self
        tbl_tourseListTable.dataSource = self
        tbl_tourseListTable.rowHeight = 30.0
        gettingDisplayInfo()
    }
    //MARK:- IBActions
    @IBAction func backButtonclick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK:- Helpers
    func gettingDisplayInfo(){
        textFieldDidChange(tf_searchCity)
        
        tbl_tourseListTable.reloadData()
    }
}
//MARK: - TextField Delegates
extension SearchToursCitiesVC: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text?.count != 0 {
            gettingHotelCitiesList(cityText: textField.text!)
        } else {
            searchDisplayArray.removeAll()
        }
        tbl_tourseListTable.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
}
//MARK: - UITableviewDataSource and Delegates
extension SearchToursCitiesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDisplayArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchCitiesCell", bundle: nil), forCellReuseIdentifier: "SearchCitiesCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchCitiesCell") as? SearchCitiesCell
        }
        cell?.lbl_citiesName.text = searchDisplayArray[indexPath.row]["country_name"]! as? String
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchCity?(cityInfo: searchDisplayArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
}
//   MARK: - API's
extension SearchToursCitiesVC {
    
      func gettingHotelCitiesList(cityText: String) {
          

          let params = ["term":cityText]
          VKAPIs.shared.getRequestFormdata(params: params, file: Tourse_getPackageCountry, httpMethod: .POST)
          { (resultObj, success, error) in
              if success == true {
                  print("Holiday Cities: \(String(describing: resultObj))")
                  
                  if let result = resultObj as? [[String: Any]] {
                      
                      if self.tf_searchCity.text?.count == 0 {
                          
                          let elemtDict:[String: Any] = ["package_country": "",
                                                         "country_name":"All"]
                          
                          self.searchMainArray = result
                          self.searchDisplayArray = result
                          
                          self.searchMainArray.insert(elemtDict, at: 0)
                          self.searchDisplayArray.insert(elemtDict, at: 0)
                      }
                      else {
                          
                          self.searchMainArray = result
                          self.searchDisplayArray = result
                      }
                      
                      print(result)
                      self.tbl_tourseListTable.reloadData()
 
                  } else {
                      if let message = resultObj as? [String: String] {
                          self.view.makeToast(message: message["message"]!)
                          self.searchMainArray.removeAll()
                          self.searchDisplayArray.removeAll()
                          self.tbl_tourseListTable.reloadData()
                      }
                      
                  }
              }
          }
      }
}
