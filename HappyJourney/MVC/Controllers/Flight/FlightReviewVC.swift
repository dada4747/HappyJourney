//
//  FlightReviewVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class FlightReviewVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var tbl_flightDetails: UITableView!
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    @IBOutlet weak var hei_flightConstraint: NSLayoutConstraint!
    
    // booking info...
    @IBOutlet weak var lbl_handBaggage: UILabel!
    @IBOutlet weak var lbl_checkInBaggage: UILabel!
    @IBOutlet weak var lbl_baseFare: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_gstFare: UILabel!
    @IBOutlet weak var lbl_extraService: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    
    var passenger_array: [DPassengerItem] = []
    var flight_details_array: [DFlightStopsItem] = []
    
    var paramString:[String:String] = [:]
    var SSRPaymentDict: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .appColor
        displayInformationAndDelegates()
        reloadInformation()
    }
    
    // MARK:- Helpers
    func displayInformationAndDelegates() {
        
        // display...
        lbl_mobile.text = DPassengerModel.mobile_no
        lbl_emailId.text = DPassengerModel.email_id
        
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        
        tbl_flightDetails.delegate = self
        tbl_flightDetails.dataSource = self
  
    }
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_baseFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupModel.baseFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_taxFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupModel.totalTax * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_totalFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupModel.totalFare + FinalBreakupModel.convenienceFare) -  FinalBreakupModel.discount) * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_gstFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupModel.gstFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_convenienceFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupModel.convenienceFare * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_discount.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupModel.discount * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_extraService.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (0.0 * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        lbl_checkInBaggage.text = DFlightStopsModel.flightTrip_array[0].baggage
        lbl_handBaggage.text = DFlightStopsModel.flightTrip_array[0].cabin_baggage

        
    }
    
    func reloadInformation() {
        
        flight_details_array = DFlightStopsModel.flightTrip_array
        
        for model in DPassengerModel.adultArray {
            if model.isSelected == true {
                passenger_array.append(model)
            }
        }
        
        for model in DPassengerModel.childArray {
            if model.isSelected == true {
                passenger_array.append(model)
            }
        }
        
        for model in DPassengerModel.infantArray {
            if model.isSelected == true {
                passenger_array.append(model)
            }
        }
        tbl_passengerDetails.reloadData()
        tbl_flightDetails.reloadData()
        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 35) + 66)
        hei_flightConstraint.constant = CGFloat((flight_details_array.count * 200) + 66)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        flightPreBooking_HTTPConnection()
    }
    
}

extension FlightReviewVC: UITableViewDataSource, UITableViewDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tbl_passengerDetails  {
            return passenger_array.count
        } else {
            return flight_details_array.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tbl_passengerDetails  {
            return 35
        } else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tbl_passengerDetails {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
            if cell == nil {
                tableView.register(UINib(nibName: "PassengerCell", bundle: nil), forCellReuseIdentifier: "PassengerCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell") as? PassengerCell
            }
            cell?.view_display.isHidden = false
            
            // display information...
            if tableView == tbl_passengerDetails {
                let model = passenger_array[indexPath.row]
                cell?.lbl_displayName.text = String(format: "%d. %@ %@ %@", indexPath.row+1, model.title_name!, model.first_name!,  model.last_name!)
            }
            else {}
            
            cell?.selectionStyle = .none
            return cell!
            
        } else {
            
            // cell creation...
            var cell = tableView.dequeueReusableCell(withIdentifier: "FStopsDetailsCell") as? FStopsDetailsCell
            if cell == nil {
                tableView.register(UINib(nibName: "FStopsDetailsCell", bundle: nil), forCellReuseIdentifier: "FStopsDetailsCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "FStopsDetailsCell") as? FStopsDetailsCell
            }
            
            // display information...
            cell?.displayStops_information(stopModel: flight_details_array[indexPath.row])
            cell?.bg_view.layer.borderWidth = 0
            cell?.bg_view.layer.borderColor = UIColor.clear.cgColor
            cell?.topleftseparatorview.isHidden = true
            cell?.toprightseparatorview.isHidden = true
            cell?.selectionStyle = .none
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
//
//extension FlightReviewVC {
//
//    // MARK:- API's
//    func flightPreBooking_HTTPConnection() {
//        if let payment_url = SSRPaymentDict["retun_url"] as? String {
//
////            // move to payment...
////            let pay_vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentGatewayVC") as! PaymentGatewayVC
////            pay_vc.payment_url = payment_url
////            self.navigationController?.pushViewController(pay_vc, animated: true)
//        }
//        else {
//
//            CommonLoader.shared.startLoader(in: view)
//            // calling apis...
//            VKAPIs.shared.getRequestXwwwform(params: paramString, file: "flight/pre_booking_mobile", httpMethod: .POST)
//            { (resultObj, success, error) in
//
//                // success status...
//                if success == true {
//                    print("Flight Pre Book success: \(String(describing: resultObj))")
//
//                    if let result = resultObj as? [String: Any] {
//                        if result["status"] as? Bool == true {
//
//                            // response date...
//                            if let data_dict = result["data"] as? [String: Any] {
//
//                                // move to payment...
//                                let pay_vc = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightPaymentVC") as! FlightPaymentVC
//                                pay_vc.payment_url = data_dict["return_url"] as? String
//                                self.navigationController?.pushViewController(pay_vc, animated: true)
//                            }
//                        } else {
//                            // error message...
//                            if let message_str = result["message"] as? String {
//                                self.view.makeToast(message: message_str)
//                            }
//                        }
//                    } else {
//                        print("Flight Pre Book formate : \(String(describing: resultObj))")
//                    }
//                } else {
//                    print("Flight Pre Book error : \(String(describing: error?.localizedDescription))")
//                    self.view.makeToast(message: error!.localizedDescription)
//                }
//                CommonLoader.shared.stopLoader()
//            }
//        }
//    }
//}

extension FlightReviewVC {
    
    // MARK:- API's
    func flightPreBooking_HTTPConnection() {

        if let payment_url = SSRPaymentDict["retun_url"] as? String {
            
//            // move to payment...
//            let pay_vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentGatewayVC") as! PaymentGatewayVC
//            pay_vc.payment_url = payment_url
//            self.navigationController?.pushViewController(pay_vc, animated: true)
        }
        else {
            
            CommonLoader.shared.startLoader(in: view)
            // calling apis...
            VKAPIs.shared.getRequestFormdata(params: paramString, file: FLIGHT_PreBooking, httpMethod: .POST)
            { (resultObj, success, error) in
                
                // success status...
                if success == true {
                    print("Flight Pre Book success: \(String(describing: resultObj))")
                    
                    if let result = resultObj as? [String: Any] {
                        if result["status"] as? Bool == true {
                            
                            // response date...
                            if let data_dict = result["data"] as? [String: Any] {
                                
                                // move to payment...
                                let pay_vc = FLIGHT_STORYBOARD.instantiateViewController(withIdentifier: "FlightPaymentVC") as! FlightPaymentVC
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
                        print("Flight Pre Book formate : \(String(describing: resultObj))")
                    }
                } else {
                    print("Flight Pre Book error : \(String(describing: error?.localizedDescription))")
                }
                CommonLoader.shared.stopLoader()
            }
        }
    }
}
