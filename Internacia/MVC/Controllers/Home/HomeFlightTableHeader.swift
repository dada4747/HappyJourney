//
//  HomeFlightTableHeader.swift
//  Internacia
//
//  Created by Admin on 29/10/22.
//

import UIKit

class HomeFlightTableHeader: UIView {
    // MARK:- Outlets
    @IBOutlet weak var view_flightTripType: UIView!
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var view_oneWayRound: UIView!
    @IBOutlet weak var tf_sourceCity: UITextField!
    @IBOutlet weak var tf_destinationCity: UITextField!
    
    @IBOutlet weak var lbl_class: UILabel!
    @IBOutlet weak var view_multiCity: UIView!
    @IBOutlet weak var tbl_multiCity: UITableView!
    @IBOutlet weak var btn_addCity: UIButton!
    @IBOutlet weak var addCities_HConstraint: NSLayoutConstraint!
    
    // dates lables...
    @IBOutlet weak var lbl_departDate: UILabel!
//    @IBOutlet weak var lbl_departDay: UILabel!
    
    @IBOutlet weak var view_returnDate: UIView!
    @IBOutlet weak var lbl_returnDate: UILabel!
//    @IBOutlet weak var lbl_returnDay: UILabel!
    
    // traveller detsil views...
    @IBOutlet weak var view_travellersType: UIView!
    
    // calendar popview...
    @IBOutlet weak var view_calendarPop: UIView!
    @IBOutlet weak var lbl_calendarTitle: UILabel!
    @IBOutlet weak var view_JBCalendar: JTHorizontalCalendarView!
    
    // class pop view...
    @IBOutlet var view_classPop: UIView!
    @IBOutlet weak var view_classPopSub: UIView!
//    @IBOutlet weak var btn_class: UIButton!
    @IBOutlet weak var btn_currency: UIButton!
    //var view_currencyPop: CurrencyView?
    
    // traveller pop view...
    @IBOutlet weak var view_travallerPop: UIView!
    @IBOutlet weak var lbl_adultCount: UILabel!
    @IBOutlet weak var lbl_childCount: UILabel!
    @IBOutlet weak var lbl_infantCount: UILabel!
    @IBOutlet weak var lbl_adult: UILabel!
    @IBOutlet weak var lbl_child: UILabel!
    @IBOutlet weak var lbl_infant: UILabel!
    
    @IBOutlet weak var tf_prefferedAirline: UITextField!
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func SourceButtonAction(_ sender: Any) {
        print("asdfghqwertyxcvbndfghj")
    }
}
