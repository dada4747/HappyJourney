//
//  BusReviewVC.swift
//  Internacia
//
//  Created by Admin on 20/11/22.
//

import UIKit

class BusReviewVC: UIViewController {
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    
    @IBOutlet weak var lbl_pickUpCity: UILabel!
    @IBOutlet weak var lbl_pickUpDate: UILabel!
    @IBOutlet weak var lbl_pickUpTime: UILabel!
    
    @IBOutlet weak var lbl_dropOffCity : UILabel!
    @IBOutlet weak var lbl_dropOffDate : UILabel!
    @IBOutlet weak var lbl_dropOffTime : UILabel!
    
    @IBOutlet weak var lbl_noOfSeats : UILabel!
    @IBOutlet weak var lbl_seatsNumbers : UILabel!
    
    @IBOutlet weak var lbl_total_Fare : UILabel!
    @IBOutlet weak var lbl_discount : UILabel!
    @IBOutlet weak var lbl_finalFare : UILabel!
    @IBOutlet weak var lbl_gst: UILabel!
    
    @IBOutlet weak var lbl_convenience_fee: UILabel!
    
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    
    var passenger_array: [Int : String] = [:]
    
    var paramString:[String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayInformationAndDelegates()
        reloadInformation()

        // Do any additional setup after loading the view.
    }
    func displayInformationAndDelegates() {
        self.lbl_emailId.text = PassengerInfo.email ?? ""
        self.lbl_mobile.text = PassengerInfo.mobileNumber ?? ""
        self.lbl_pickUpCity.text = DBusResultModel.selectedBus?.From
        let destinDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: (DBusResultModel.selectedBus?.DeptTime)!)
        self.lbl_pickUpDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: destinDate)
        self.lbl_pickUpTime.text = DBusResultModel.selectedBus?.DepartureTime
        self.lbl_dropOffCity.text = DBusResultModel.selectedBus?.To
        let arrDate = DateFormatter.getDate(formate: "yyyy-MM-dd HH:mm:ss", date: (DBusResultModel.selectedBus?.ArrTime)!)
        
        self.lbl_dropOffDate.text = DateFormatter.getDateString(formate: "dd MMM yyyy", date: arrDate)
        self.lbl_dropOffTime.text = DBusResultModel.selectedBus?.ArrivalTime
        self.lbl_noOfSeats.text = "\(DBusResultModel.bus_Selected_Seats_list.count)"
        let count = DBusResultModel.bus_Selected_Seats_list.map{$0.seatNo}
        
        self.lbl_seatsNumbers.text = count.joined(separator: ",")
        self.lbl_total_Fare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", DBusResultModel.bus_final_total_price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_discount.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", DBusResultModel.bus_discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_finalFare.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", ((DBusResultModel.bus_final_total_price + DBusResultModel.convenienceFee + DBusResultModel.gst) - DBusResultModel.bus_discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_gst.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", DBusResultModel.gst * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        self.lbl_convenience_fee.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", DBusResultModel.convenienceFee * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))
        
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        
    }
    func reloadInformation() {
        
        passenger_array = PassengerInfo.firstName
        
        tbl_passengerDetails.reloadData()
        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 35) + 40)
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        BusPreBooking_HTTPConnection()
    }
}
extension BusReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return passenger_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        if cell == nil {
            tableView.register(UINib(nibName: "HPassengerCell", bundle: nil), forCellReuseIdentifier: "HPassengerCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "HPassengerCell") as? HPassengerCell
        }
        cell?.view_display.isHidden = false
        
        // display information...
        if tableView == tbl_passengerDetails {
            let model = passenger_array[indexPath.row]
            let title = PassengerInfo.nameTitle[indexPath.row]
            cell?.lbl_displayName.text = String(format: "%d.  %@ %@", indexPath.row+1, title!, model!)
        }
        else {}
        
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK:- API's
extension BusReviewVC {
func BusPreBooking_HTTPConnection() {
    SwiftLoader.show(animated: true)
    // calling apis...
    VKAPIs.shared.getRequestXwwwform(params: paramString, file: "bus/pre_booking_mobile", httpMethod: .POST)
    { (resultObj, success, error) in
        
        // success status...
        if success == true {
            print("Bus Pre Book success: \(String(describing: resultObj))")
            
            if let result = resultObj as? [String: Any] {
                if result["status"] as? Bool == true {
                    
                    // response date...
                    if let data_dict = result["data"] as? [String: Any] {
                        
                        // move to payment...
                        let pay_vc = HOTEL_STORYBOARD.instantiateViewController(withIdentifier: "HotelPaymentVC") as! HotelPaymentVC
                        pay_vc.payment_url = data_dict["return_url"] as? String
                        self.navigationController?.pushViewController(pay_vc, animated: true)
                    }
                } else {
                    // error message...
                    if let message_str = result["message"] as? String {
                        self.view.makeToast(message: message_str)
                    }
                }
            } else {
                print("Bus Pre Book formate : \(String(describing: resultObj))")
            }
        } else {
            print("Bus Pre Book error : \(String(describing: error?.localizedDescription))")
        }
        SwiftLoader.hide()
    }
}
}
