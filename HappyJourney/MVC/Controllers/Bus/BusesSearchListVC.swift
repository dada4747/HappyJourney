//
//  BusesSearchListVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
import AVFoundation
class BusesSearchListVC: UIViewController, BusFilterDelegate {
    func filterApply_removeIntimation() {
        let allfilter = DBusFilters.applyAll_filterAndSorting(_depart: DBusSearchModel.busSearch_array)
        busesSearchList_array = allfilter
        self.lbl_busesCount.text = "\(busesSearchList_array.count) Buses Found / \(DBusSearchModel.busSearch_array.count)"
        if busesSearchList_array.count == 0 {
            self.lbl_emptyMessage.isHidden = false
        } else {
            self.lbl_emptyMessage.isHidden = true
        }
        tbl_buses_list.reloadData()
        
    }
    
    @IBOutlet weak var lbl_emptyMessage: UILabel!

    @IBOutlet weak var lbl_from_city: UILabel!
    @IBOutlet weak var lbl_to_city: UILabel!
    @IBOutlet weak var lbl_travel_date: UILabel!
    @IBOutlet weak var lbl_busesCount: UILabel!
    @IBOutlet weak var tbl_buses_list: UITableView!
    var busesSearchList_array : [DBusesSearchItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        displayInfo()
        addDelegates()
        self.lbl_from_city.text = DBTravelModel.sourceCity["city"]
        self.lbl_to_city.text = DBTravelModel.destinationCity["city"]
        self.lbl_travel_date.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DBTravelModel.departDate)
        gettingBusesListAPI()

    }
    
    //MARK: - IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Function
    func displayInfo(){
        
        lbl_emptyMessage.isHidden = true
//        self.lbl_from_city.text = DBTravelModel.sourceCity["city"]
//        self.lbl_to_city.text = DBTravelModel.destinationCity["city"]
//        self.lbl_travel_date.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DBTravelModel.departDate)
        busesSearchList_array = DBusSearchModel.busSearch_array
        self.lbl_busesCount.text = "\(busesSearchList_array.count) Buses Found / \(busesSearchList_array.count)"
//        tbl_buses_list.reloadData()
        
//        var uniqueStrings = [String]()

//        busesSearchList_array.forEach { item in
////            print(item.BusTypeName!)
//            if !uniqueStrings.contains(item.BusTypeName!) {
//                uniqueStrings.append(item.BusTypeName!)
//            }
//        }
//        print(uniqueStrings)
        DBusFilters.getOperatorAndPrice_fromResponse()
        filterApply_removeIntimation()

    }
    func addDelegates(){
        tbl_buses_list.delegate = self
        tbl_buses_list.dataSource = self
        tbl_buses_list.rowHeight = UITableView.automaticDimension
        tbl_buses_list.estimatedRowHeight = 150
    }
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        
        // if data not available...
        if DBusSearchModel.busSearch_array.count == 0 {
           
            self.view.makeToast(message: "Flights information not available.")
            return
        }
        
        
        // move to filters screen...
        let filterObj = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusFilterVC") as! BusFilterVC
        filterObj.delegate = self
        self.navigationController?.pushViewController(filterObj, animated: true)
    }
    
}
//MARK: - UITableviewDelagate And DataSource
extension BusesSearchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busesSearchList_array.count
        //hotelsList_array.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "BSearchListCell") as? BSearchListCell
        if cell == nil {
            tableView.register(UINib(nibName: "BSearchListCell", bundle: nil), forCellReuseIdentifier: "BSearchListCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "BSearchListCell") as? BSearchListCell
        }
        cell?.displayBusInfo(model: busesSearchList_array[indexPath.row])
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DBTravelModel.selectdBus = busesSearchList_array[indexPath.row]
        
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusDetailsVC") as! BusDetailsVC
        vc.selectedBus = busesSearchList_array[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//https://www.spotatrip.com/index.php/bus/search/445?bus_station_from=Bangalore&from_station_id=6395&bus_station_to=Chennai&to_station_id=2069&bus_date_1=18-05-2023
//MARK: - API Call's
extension BusesSearchListVC {
    func gettingBusesListAPI() {
        DBusSearchModel.clearModels()

        CommonLoader.shared.startLoader(in: view)
        let params: [String: Any] = ["bus_station_from": DBTravelModel.sourceCity["city"]!,"from_station_id":DBTravelModel.sourceCity["id"]!,"bus_station_to":DBTravelModel.destinationCity["city"]!,"to_station_id":DBTravelModel.destinationCity["id"]!,"bus_date_1": DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DBTravelModel.departDate)]
        let paramString: [String: String] = ["bus_search" : VKAPIs.getJSONString(object: params)]
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: "general/pre_bus_search_mobile", httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Bus search list success: \(String(describing: resultObj))")
                if let result = resultObj as? [String: Any] {
                    if result["status"] as? Bool == true {
                        // response data...
                        
                        DBusSearchModel.createModels(result_dict: result)
//                        .createModels(result_dict: result)
                    } else {
                        // error message...
                        if let message_str = result["message"] as? String {
                            self.view.makeToast(message: message_str)
                        }
                    }
                } else {
                    print("Bus search list formate : \(String(describing: resultObj))")
                }
            } else {
                print("Bus search list error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayInfo()
            CommonLoader.shared.stopLoader()
        }
    }
}
