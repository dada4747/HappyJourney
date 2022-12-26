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

    @IBOutlet weak var img_depart: UIImageView!
    @IBOutlet weak var img_arrivel: UIImageView!
    @IBOutlet weak var img_duration: UIImageView!
    @IBOutlet weak var img_price: UIImageView!

    var sortByPrice = true
    var sortByDepart = true
    var sortByArrivel = true
    var sortByDuration = true
    var sort_number: Int = 0

    
    var audioPlayer : AVAudioPlayer?
    var lendingPlay: AVQueuePlayer = {
        let url1 = Bundle.main.url(forResource: "landing-load", withExtension: "mp3")!
        let url2 = Bundle.main.url(forResource: "bus-pre-load", withExtension: "mp3")!
        let item1 = AVPlayerItem(url: url1)
        let item2 = AVPlayerItem(url: url2)

        let queue = AVQueuePlayer(items: [item1, item2])
        return queue
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lendingPlay.play()
//        displayInfo()
        addDelegates()
        
        gettingBusesListAPI()

    }
    func playSound(sound: String) {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        guard let soundURL = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK: - IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - Function
    func displayInfo(){
        lbl_emptyMessage.isHidden = true
        self.lbl_from_city.text = DBTravelModel.sourceCity["city"]
        self.lbl_to_city.text = DBTravelModel.destinationCity["city"]
        self.lbl_travel_date.text = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: DBTravelModel.departDate)
//        busesSearchList_array = DBusSearchModel.busSearch_array
        self.lbl_busesCount.text = "\(busesSearchList_array.count) Buses Found / \(busesSearchList_array.count)"
//        tbl_buses_list.reloadData()
        DBusFilters.getOperatorAndPrice_fromResponse()
        filterApply_removeIntimation()

    }
    func addDelegates(){
        tbl_buses_list.delegate = self
        tbl_buses_list.dataSource = self
        tbl_buses_list.rowHeight = UITableView.automaticDimension
        tbl_buses_list.estimatedRowHeight = 120
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
    
    
    @IBAction func departFilterButtonAction(_ sender: Any) {
        if sortByDepart {
            sortByDepart = false
            sort_number = 2
            UIView.animate(withDuration: 0.2) { () -> Void in
              self.img_depart.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
        } else {
            sortByDepart = true
            sort_number = 3
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_depart.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DBusFilters.sort_number = sort_number
        filterApply_removeIntimation()
    }
    @IBAction func arrivelButtonFilterApply(_ sender: Any) {
        if sortByArrivel {
            sortByArrivel = false
            sort_number = 7
            UIView.animate(withDuration: 0.2) { () -> Void in
              self.img_arrivel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
        } else {
            sortByArrivel = true
            sort_number = 6
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_arrivel.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DBusFilters.sort_number = sort_number
        filterApply_removeIntimation()
    }
    
    @IBAction func durationFilterButtonAction(_ sender: Any) {
        if sortByDuration {
            sortByDuration = false
            sort_number = 5
            UIView.animate(withDuration: 0.2) { () -> Void in
              self.img_duration.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
        } else {
            sortByDuration = true
            sort_number = 4
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_duration.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DBusFilters.sort_number = sort_number
        filterApply_removeIntimation()
    }
    
    @IBAction func pricingFilterButtonAction(_ sender: Any) {
        if sortByPrice {
            sortByPrice = false
            sort_number = 1
            UIView.animate(withDuration: 0.2) { () -> Void in
              self.img_price.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
        } else {
            sortByPrice = true
            sort_number = 0
            
            UIView.animate(withDuration: 0.2, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_price.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DBusFilters.sort_number = sort_number
        filterApply_removeIntimation()
    }
    
    
    
    
    
    
    
    
    
    
}
//MARK: - UITableviewDelagate And DataSource
extension BusesSearchListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120//UITableView.automaticDimension
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
//MARK: - API Call's
extension BusesSearchListVC {
    func gettingBusesListAPI() {
        DBusSearchModel.clearModels()

        SwiftLoader.show(animated: true)
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
                        self.lendingPlay.pause()
                        self.playSound(sound: "bus-post-load")
                        // response data...
                        
                        DBusSearchModel.createModels(result_dict: result)
//                        .createModels(result_dict: result)
                    } else {
                        // error message...
                        self.lendingPlay.pause()
                        self.playSound(sound: "all-empty-result")
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
            SwiftLoader.hide()
        }
    }
}
