//
//  HotelReviewVC.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class HotelReviewVC: UIViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_emailId: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_checkIn: UILabel!
    @IBOutlet weak var lbl_checkOut: UILabel!
    @IBOutlet weak var tbl_passengerDetails: UITableView!
    
    @IBOutlet weak var hei_passengerConstraint: NSLayoutConstraint!
    
    // booking info...
    @IBOutlet weak var lbl_noOfRooms: UILabel!
    @IBOutlet weak var lbl_hotelName: UILabel!
    @IBOutlet weak var lbl_hotelAddress: UILabel!
    @IBOutlet weak var lbl_roomType: UILabel!
    @IBOutlet weak var lbl_total: UILabel!
    @IBOutlet weak var lbl_taxFare: UILabel!
    @IBOutlet weak var lbl_convenienceFare: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_totalFare: UILabel!
    
    var passenger_array: [DHPassengerItem] = []
    
    var paramString:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayInformationAndDelegates()
        reloadInformation()
    }
    
    // MARK:- Helpers
    func displayInformationAndDelegates() {
//        view.backgroundColor = .appColor
        // display...
        lbl_mobile.text = DHPassengerModel.mobile_no
        lbl_emailId.text = DHPassengerModel.email_id
        
        lbl_checkIn.text = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkin_date)
        lbl_checkOut.text = DateFormatter.getDateString(formate: "yyyy-MM-dd", date: DHTravelModel.checkout_date)
        
        lbl_noOfRooms.text = "\(AddRoomModel.addRooms_array.count)"
        lbl_hotelName.text = DHPreBookingModel.hotelName
        lbl_hotelAddress.text = DHPreBookingModel.hotelAddress
        lbl_roomType.text = DHPreBookingModel.roomType
        
        displayBookingPriceInfo()
        
        // bottom shadow...
        view_header.viewShadow()
        
        // table delegates...
        tbl_passengerDetails.delegate = self
        tbl_passengerDetails.dataSource = self
        
    }
    func displayBookingPriceInfo() {
        
        // currency and total price...
        lbl_total.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.totalFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, FinalBreakupHotelModel.totalFare)
        lbl_convenienceFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.gst * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())  //String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, FinalBreakupHotelModel.convenienceFare)
        lbl_taxFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.convenienceFare  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())// String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, "0.00")
        lbl_totalFare.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (((FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.gst + FinalBreakupHotelModel.convenienceFare) - FinalBreakupHotelModel.discount)  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())//String.init(format: "%@ %.2f", FinalBreakupHotelModel.currency, (FinalBreakupHotelModel.totalFare + FinalBreakupHotelModel.convenienceFare))
        lbl_discount.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (FinalBreakupHotelModel.discount  * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
    }
    
    func reloadInformation() {
        
        for model in DHPassengerModel.adultArray {
            if model.isSelected == true {
                passenger_array.append(model)
            }
        }
        
        for model in DHPassengerModel.childArray {
            if model.isSelected == true {
                passenger_array.append(model)
            }
        }
        
        tbl_passengerDetails.reloadData()
        hei_passengerConstraint.constant = CGFloat((passenger_array.count * 35) + 40)
    }
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedToPaymentClicked(_ sender: Any) {
        hotelPreBooking_HTTPConnection()
    }
    
}

extension HotelReviewVC: UITableViewDataSource, UITableViewDelegate {
    
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
            cell?.lbl_displayName.text = String(format: "%d.  %@ %@ %@", indexPath.row+1, model.title_name!, model.first_name!,  model.last_name!)
        }
        else {}
        
        cell?.selectionStyle = .none
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension HotelReviewVC {
    
    // MARK:- API's
    func hotelPreBooking_HTTPConnection() {
print(paramString)

        CommonLoader.shared.startLoader(in: view)
        // calling apis...
        VKAPIs.shared.getRequestXwwwform(params: paramString, file: HOTEL_Pre_Booking, httpMethod: .POST)
        { (resultObj, success, error) in
            
            // success status...
            if success == true {
                print("Hotel Pre Book success: \(String(describing: resultObj))")
                
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
                    print("Hotel Pre Book formate : \(String(describing: resultObj))")
                }
            } else {
                print("Hotel Pre Book error : \(String(describing: error?.localizedDescription))")
            }
            CommonLoader.shared.stopLoader()
        }
    }
}
