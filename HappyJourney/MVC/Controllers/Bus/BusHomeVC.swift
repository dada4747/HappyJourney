//
//  BusHomeVC.swift
//  Internacia
//
//  Created by Admin on 07/11/22.
//

import UIKit

class BusHomeVC: UIViewController {
//MARK: - IBOutlets
    
    @IBOutlet weak var view_header: CRView!
    
    @IBOutlet weak var coll_ads: UICollectionView!
    @IBOutlet weak var tf_source: UITextField!
    
    @IBOutlet weak var tf_destination: UITextField!
    
    @IBOutlet weak var lbl_selectedDate: UILabel!
    @IBOutlet weak var view_calendarPop: UIView!

    @IBOutlet weak var lbl_calendarTitle: UILabel!
    @IBOutlet weak var view_JBCalendar: JTHorizontalCalendarView!
    var calendarManager = JTCalendarManager()
    var calSelectedDate = Date()

    var cityIndex: Int = 0
    
    //MARK: - Variables
    var sourceCity : [String: String]?
    var destinationCity : [String: String]?
    var departDate = Date()

    var topOffer_Array: [DCommonTopOfferItems] = []

    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        DCommonModel.topOffer_Array.forEach({ item in
            if item.module == "bus" {
                topOffer_Array.append(item)
            }
        })
        //MARK: -
//        sourceCity = ["id": "6395", "city": "Bangalore", "state": "0"]
//        destinationCity = ["id": "2069", "city": "Chennai", "state": "0"]
        if DBTravelModel.sourceCity.isEmpty || DBTravelModel.destinationCity.isEmpty {
            sourceCity = ["id": "6395", "city": "Bangalore", "state": "0"]
            destinationCity = ["id": "2069", "city": "Chennai", "state": "0"]
            DBTravelModel.sourceCity = sourceCity!
            DBTravelModel.destinationCity = destinationCity!

        }else{
            sourceCity = DBTravelModel.sourceCity
            destinationCity = DBTravelModel.destinationCity
        }
        
        DBTravelModel.departDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        //MARK: -
        clearInfoAfterBooking()
        setUpDepartDate()
        addingCalendarPop()
        calendarManager.delegate = self
        calendarManager.contentView = self.view_JBCalendar
        calendarManager.setDate(Date())
        calendarTitleDisplay(sDate: Date())
        coll_ads.delegate = self
        coll_ads.dataSource = self
        coll_ads.register(UINib.init(nibName: "HomeOffersCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeOffersCVCell")
        showOffers()
        tf_source.text = sourceCity?["city"] ?? ""
        tf_destination.text = destinationCity?["city"] ?? ""

        
        // Do any additional setup after loading the view.
    }
    func showOffers(){
        coll_ads.reloadData()

    }
    func setUpDepartDate(){
        lbl_selectedDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: departDate)

    }
// MARK: - Fuctions
    func clearInfoAfterBooking(){
        tf_source.text = ""
        tf_destination.text = ""
        departDate = Date()
    }
    func moveToCitiesSelection(){
        let searchObj = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BSearchCitiesVC") as! BSearchCitiesVC
        searchObj.delegate = self
        self.present(searchObj, animated: true, completion: nil)
    }
    func addingCalendarPop(){
        for views in (UIApplication.shared.keyWindow?.subviews)! {
            if views.tag == 100 || view.tag == 101 || view.tag == 102 || view.tag == 103 {
                views.removeFromSuperview()
            }
        }
        self.view_calendarPop.isHidden = true
        self.view_calendarPop.tag = 100
        self.view_calendarPop.frame = self.view.frame
        UIApplication.shared.keyWindow?.addSubview(self.view_calendarPop)
    }
//    func setUpDepartAndReturnDates(){
//        lbl_selectedDate.text = DateFormatter.getDateString(formate: "dd MMM, yyyy", date: departDate)
//    }
// MARK: - IBActions
    
    @IBAction func backButtonAction(_ sender: Any) {
        //back button
        self.navigationController?.popViewController(animated: true)

    }
    @IBAction func sourceButtonAction(_ sender: Any) {
        // selelect source city
        cityIndex = 1
        moveToCitiesSelection()
    }
    @IBAction func destinationButtonAction(_ sender: Any) {
        //select destination city
        cityIndex = 2
        moveToCitiesSelection()
    }
    
    @IBAction func switchLocationAction(_ sender: Any) {
        //switch loaction button action
        if tf_source.text?.isEmpty == true {
            self.view.makeToast(message: "Please Select Departure")
            
        } else if tf_destination.text?.isEmpty == true  {
            
            self.view.makeToast(message: "Please Select Destination")
            
        } else {
            let tempCity = tf_source.text
            tf_source.text = tf_destination.text
            tf_destination.text = tempCity
            let tempCities = sourceCity
            sourceCity = destinationCity
            destinationCity = tempCities
        }
    }
    @IBAction func calenderHiddenClicked(_ sender: UIButton) {
         view_calendarPop.isHidden = true
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        //select date of travel
        let calendar_popView = Bundle.main.loadNibNamed("CalendarPopView", owner: nil, options: nil)![0] as! CalendarPopView
        calendar_popView.delegate = self
        UIApplication.shared.keyWindow?.addSubview(calendar_popView)
        
//        calendar_popView.departDate = departDate
//        calendar_popView.calSelectedDate = departDate

    }
    @IBAction func dateSet_clicked(_ sender: Any) {
        departDate = calSelectedDate
//        setUpDepartDate()
        view_calendarPop.isHidden = true

    }
    @IBAction func searchBusesAction(_ sender: UIButton) {
        //search flight
        let whitespace = CharacterSet.whitespacesAndNewlines
        var messageStr = ""

        if tf_source.text?.count == 0 || tf_source.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please select departure city"

        }else if tf_destination.text?.count == 0 || tf_destination.text?.trimmingCharacters(in: whitespace).count == 0 {
            messageStr = "Please select destination city"
        }
        if messageStr.count != 0 {

            self.view.makeToast(message: messageStr)
        } else {
            moveToSearchBusses()
        }
    }
    
    func moveToSearchBusses(){
//        print(sourceCity)
//        print(destinationCity)
//        print(departDate)
        DBTravelModel.sourceCity =   sourceCity!
        DBTravelModel.destinationCity = destinationCity!
        DBTravelModel.departDate = departDate
        
        //movel to buses list....
        let vc = BUS_STORYBOARD.instantiateViewController(withIdentifier: "BusesSearchListVC") as! BusesSearchListVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension BusHomeVC : searchBusesCitiesDelegate {
    func searchBus_info(busInfo: [String : String]) {
        if cityIndex == 1 {
            
            // dispaly from city...
            sourceCity = busInfo
            tf_source.text = busInfo["city"]
        }
        else if cityIndex == 2 {
            
            // display to city...
            destinationCity = busInfo
            tf_destination.text = busInfo["city"]
        }

    }
}
extension BusHomeVC:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return CGSize(width:(coll_ads.frame.size.width)/2, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return topOffer_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeOffersCVCell", for: indexPath as IndexPath) as! HomeOffersCVCell

            //display information...
        

            cell.displayTopOffersInformation(model: topOffer_Array[indexPath.row])

            return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
        
    }
}
extension BusHomeVC : JTCalendarDelegate{
    // MARK:- JTCalendarDelegate
    func calendar(_ calendar: JTCalendarManager!, prepareDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        if calendarManager.dateHelper.date(Date(), isTheSameDayThan: loDayView.date) {
            
            // Today...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.red //UIColor.init(named: "#E3E3E3")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if calendarManager.dateHelper.date(calSelectedDate, isTheSameDayThan: loDayView.date) {
            
            // Selected date...
            loDayView.circleView.isHidden = false
            loDayView.circleView.backgroundColor = UIColor.lightGray //UIColor.init(named: "#2097D9")
            loDayView.dotView.backgroundColor = UIColor.white
            loDayView.textLabel.textColor = UIColor.white
        }
        else if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
            
            // Other month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else if calendarManager.dateHelper.date(Date(), isEqualOrAfter: loDayView.date) {
            
            // same month passed dates...
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.lightGray
        }
        else {
            
            // Another day of the current month
            loDayView.circleView.isHidden = true
            loDayView.dotView.backgroundColor = UIColor.red
            loDayView.textLabel.textColor = UIColor.black
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, didTouchDayView dayView: (UIView & JTCalendarDay)!) {
        
        // JTCalenarDayView type casting...
        let loDayView = dayView as! JTCalendarDayView
        
        // today date getting with formate...
        let todayDateStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: Date())
        let todayDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: todayDateStr)
        
        // select date gettign with formate...
        let dateSelectStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: loDayView.date)
        let selectDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: dateSelectStr)
        
        
        // user selected past date...
        if todayDate.compare(selectDate) == .orderedDescending {
            self.view.makeToast(message: "Date already past")
        }
        else {
            
            // choose selection date....
            calSelectedDate = loDayView.date
            
            // Animation for the circleView
            loDayView.circleView.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            UIView.transition(with: dayView, duration: 0.3, options: [], animations: {
                loDayView.circleView.transform = .identity
                self.calendarManager.reload()
            })
            
            // Don't change page in week mode because block the selection of days in first and last weeks of the month...
            if calendarManager.settings.weekModeEnabled {
                return
            }
            
            // Load the previous or next page if touch a day from another month...
            if !calendarManager.dateHelper.date(self.view_JBCalendar.date, isTheSameMonthThan: loDayView.date) {
                
                if self.view_JBCalendar.date.compare(loDayView.date) == .orderedAscending {
                    self.view_JBCalendar.loadNextPageWithAnimation()
                } else {
                    self.view_JBCalendar.loadPreviousPageWithAnimation()
                }
            }
        }
    }
    
    func calendar(_ calendar: JTCalendarManager!, canDisplayPageWith date: Date!) -> Bool {
        
        // Min date will be 2 month before today
        let minCalDate = calendarManager.dateHelper.add(to: Date(), months: 0)
        
        // Max date will be 2 month after today
        let maxCalDate = calendarManager.dateHelper.add(to: Date(), months: 24)
        
        return self.calendarManager.dateHelper.date(date, isEqualOrAfter: minCalDate, andEqualOrBefore: maxCalDate)
    }
    
    func calendarDidLoadNextPage(_ calendar: JTCalendarManager!) {
        // next month...
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarDidLoadPreviousPage(_ calendar: JTCalendarManager!) {
        // previous month...
        calendarTitleDisplay(sDate: calendar.date())
    }
    
    func calendarTitleDisplay(sDate: Date) {
        // calender month setup...
        lbl_calendarTitle.text = DateFormatter.getDateString(formate: "MMM yyyy", date: sDate)
    }
}


extension BusHomeVC : CalendarPopViewDelegate {
    
    // MARK:- CalendarDelegate
    func CalDatePickUpView(_calendar: CalendarPopView, selDate: Date) {
        
        calSelectedDate = selDate
        departDate = selDate
//        returnDate = departDate

        self.setUpDepartDate()

//                departDate = selDate
                
                // user selected past date...
                let loDepartStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: departDate)
                let loDepartDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loDepartStr)
                
                let loCalStr = DateFormatter.getDateString(formate: "dd-MM-yyyy", date: selDate)
                let loCalDate = DateFormatter.getDate(formate: "dd-MM-yyyy", date: loCalStr)
                
                if (loDepartDate.compare(loCalDate) == .orderedDescending)  {
                    appDel.window?.makeToast(message: "Please select return date greater than depart date !")
            
        }
    }
}


