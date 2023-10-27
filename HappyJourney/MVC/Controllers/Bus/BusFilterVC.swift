//
//  BusFilterVC.swift
//  Internacia
//
//  Created by Admin on 29/11/22.
//

import UIKit
protocol BusFilterDelegate {
    func filterApply_removeIntimation()
}
class BusFilterVC: UIViewController {
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_sort: UIButton!
    @IBOutlet weak var view_header: UIView!

    // MARK:- filter
    @IBOutlet weak var scroll_filters: UIScrollView!
    @IBOutlet weak var lbl_priceAmt: UILabel!
    @IBOutlet weak var view_silderMain: UIView!
    
    @IBOutlet weak var view_noofStops: UIView!
    @IBOutlet weak var view_departTime: UIView!
    @IBOutlet weak var view_arrivalTime: UIView!
    @IBOutlet weak var tbl_airlines: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    var delegate: BusFilterDelegate?
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    var defaultColor = UIColor.blue
    
    var onePort_value: Float = 0.0
    var final_min: Float = 0.0
    var final_max: Float = 1.0
    
    var noofStops: [Int] = [0, 0, 0, 0]
    var depart: [Int] = [0, 0, 0, 0]
    var arrival: [Int] = [0, 0, 0, 0]
    var flightSel_array: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bottom shadow...
//        view_header.viewShadow()
        
        defaultColor = .secInteraciaBlue// btn_filter.backgroundColor!
        addDelegatesAndElements()
        
        displayFilters_information()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func displayFilters_information() {
        
        // min and max values...
        final_min = DBusFilters.price_selection.0
        final_max = DBusFilters.price_selection.1
        if final_min == final_max {
            final_max = final_min + 1
        }
        
        // price information...
        rangeSlider.lowerValue = Double((final_min - DBusFilters.price_default.0)/(onePort_value * 10))
        rangeSlider.upperValue = Double((final_max - DBusFilters.price_default.0)/(onePort_value * 10))
        lbl_priceAmt.text = "\(String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())) - \(String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())) "
//        lbl_priceAmt.text = "\(DBusFilters.currency_code) \(final_min) - \(DBusFilters.currency_code) \(final_max)"
        
        
        // stops information display...
        noofStops = DBusFilters.noofStops
        for i in 0 ..< noofStops.count {
            if noofStops[i] != 0 {
                
                // color changes...
                for childView in view_noofStops.subviews {
                    if childView.tag == (i + 10) {
                        numberofStopsDefaultColor(childView: childView as! GradientView, indexS: i)
                    }
                }
            }
        }
        
        
        // Depart information...
        depart = DBusFilters.depart
        for i in 0 ..< depart.count {
            if depart[i] != 0 {

                // color changes...
                for childView in view_departTime.subviews {
                    if childView.tag == (i + 10) {
                        departureDefaultColorImages(childView: childView as! GradientView, indexS: i)
                    }
                }
            }
        }
        
        // arrival information...
        arrival = DBusFilters.arrival
        for i in 0 ..< arrival.count {
            if arrival[i] != 0 {
                
                // color changes...
                for childView in view_arrivalTime.subviews {
                    if childView.tag == (i + 10) {
                        arrivalDefaultColorImages(childView: childView as! GradientView, indexS: i)
                    }
                }
            }
        }
        
        // selected airlines...
        flightSel_array = DBusFilters.flightSelection_array
        tbl_airlines.reloadData()
    }
    // MARK:- Helpers
    func addDelegatesAndElements() {
        
        // delegates...
        tbl_airlines.delegate = self
        tbl_airlines.dataSource = self
        tbl_HContraint.constant = CGFloat(DBusFilters.operator_array.count * 30)
        
        // Range slider adding...
        rangeSlider.frame = CGRect.init(x: 0, y: 5, width: (self.view.frame.size.width-30), height: 20)
        
        rangeSlider.thumbBorderWidth = 0
        rangeSlider.thumbTintColor = defaultColor
        rangeSlider.trackTintColor = .gray
        rangeSlider.trackHighlightTintColor = defaultColor
        rangeSlider.lowerValue = 0
        rangeSlider.upperValue = 1
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(slider:)), for: .valueChanged)
        view_silderMain.addSubview(rangeSlider)
        
        // min and max...
        onePort_value = (DBusFilters.price_default.1 - DBusFilters.price_default.0) / 10
        if onePort_value == 0 {
            onePort_value = 0.1
        }
        rangeSliderValueChanged(slider: rangeSlider)
        print("One part : \(onePort_value)")
    }
    @objc func rangeSliderValueChanged(slider: RangeSlider) {
        
        // min and max...
        final_min = DBusFilters.price_default.0 + (onePort_value * Float(slider.lowerValue * 10))
        final_max = DBusFilters.price_default.0 + (onePort_value * Float(slider.upperValue * 10))

        // display price...
        lbl_priceAmt.text = "\(String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())) - \(String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "USD", (final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())) "
//        lbl_priceAmt.text = "\(DBusFilters.currency_code) \(final_min) - \(DBusFilters.currency_code) \(final_max)"
    }
    //MARK:- ColorChnages
    func numberofStopsDefaultColor(childView: GradientView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = .black
                childView.startColor = UIColor.white
                childView.endColor = .white
                childView.layer.borderColor = UIColor.clear.cgColor
                // select color...
                if noofStops[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.startColor = UIColor(hexString: "#E28A58")
                    childView.endColor = UIColor(hexString: "#D03373")
                    childView.layer.borderColor = UIColor(hexString: "#FE9C5E").cgColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    func departureDefaultColorImages(childView: GradientView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                // default image...
                let img_subChild = subChild as! UIImageView
                if childView.tag == 10 {
                    
                    img_subChild.image = UIImage.init(named: "ic_earlyMorn")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_earlyMornH")
                    }
                }
                else if childView.tag == 11 {
                    
                    img_subChild.image = UIImage.init(named: "ic_morning")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_morningH")
                    }
                }
                else if childView.tag == 12 {
                    
                    img_subChild.image = UIImage.init(named: "ic_midday")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_middayH")
                    }
                }
                else if childView.tag == 13 {
                    
                    img_subChild.image = UIImage.init(named: "ic_evening")
                    if depart[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_eveningH")
                    }
                }
                else {}
            }
            
            // text color
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = .black
                childView.startColor = .white// UIColor(hexString: "#E28A58")
                childView.endColor = .white//
                childView.layer.borderColor = UIColor.clear.cgColor

                // select color...
                if depart[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.startColor = UIColor(hexString: "#E28A58")
                    childView.endColor = UIColor(hexString: "#D03373")
                    childView.layer.borderColor = UIColor(hexString: "#FE9C5E").cgColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    func arrivalDefaultColorImages(childView: GradientView, indexS: Int) {
        
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                // default image...
                let img_subChild = subChild as! UIImageView
                if childView.tag == 10 {
                    
                    img_subChild.image = UIImage.init(named: "ic_earlyMorn")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_earlyMornH")
                    }
                }
                else if childView.tag == 11 {
                    
                    img_subChild.image = UIImage.init(named: "ic_morning")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_morningH")
                    }
                }
                else if childView.tag == 12 {
                    
                    img_subChild.image = UIImage.init(named: "ic_midday")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_middayH")
                    }
                }
                else if childView.tag == 13 {
                    
                    img_subChild.image = UIImage.init(named: "ic_evening")
                    if arrival[indexS] == 1 {
                        img_subChild.image = UIImage.init(named: "ic_eveningH")
                    }
                }
                else {}
            }
            
            // text color...
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = .black// UIColor.init(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0)
                childView.startColor = .white// UIColor(hexString: "#E28A58")
                childView.endColor = .white//UIColor(hexString: "#D03373")
                childView.layer.borderColor = UIColor.clear.cgColor
                // select color...
                if arrival[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.startColor = UIColor(hexString: "#E28A58")
                    childView.endColor = UIColor(hexString: "#D03373")
                    childView.layer.borderColor = UIColor(hexString: "#FE9C5E").cgColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveAndCancelButtonsClicked(_ sender: UIButton) {
        
        // move to back screen...
        if sender.tag == 10 {

            // sort...
//            DBusFilters.sort_number = sort_number
            
            // price filter added...
            if (rangeSlider.lowerValue > Double(DBusFilters.price_default.0)) || (rangeSlider.upperValue < Double( DBusFilters.price_default.1)) {
                DBusFilters.price_selection = (final_min, final_max)
            }
            
            // stops..
            DBusFilters.noofStops = noofStops
            DBusFilters.depart = depart
            DBusFilters.arrival = arrival
            DBusFilters.flightSelection_array = flightSel_array
            
            // delegates...
            delegate?.filterApply_removeIntimation()
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    // MARK:- Filter_Button
    @IBAction func noofStopsButtonsClicked(_ sender: UIButton) {
        print(sender.tag)
        // selection index changings...
        if noofStops[sender.tag - 10] == 1 {
            noofStops[sender.tag - 10] = 0
        } else {
            noofStops[sender.tag - 10] = 1
        }
        print("Noof stops : \(noofStops)")
        
        
        // color changes...
        for childView in view_noofStops.subviews {
            if childView.tag == sender.tag {
                numberofStopsDefaultColor(childView: childView as! GradientView, indexS: (sender.tag - 10))
            }
        }
    }
    
    @IBAction func departTimeButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if depart[sender.tag - 10] == 1 {
            depart[sender.tag - 10] = 0
        } else {
            depart[sender.tag - 10] = 1
        }
        print("Depart :\(depart)")
        
        
        // color changes...
        for childView in view_departTime.subviews {
            if childView.tag == sender.tag {
                departureDefaultColorImages(childView: childView as! GradientView, indexS:(sender.tag - 10))
            }
        }
    }
    
    @IBAction func arrivalTimeButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if arrival[sender.tag - 10] == 1 {
            arrival[sender.tag - 10] = 0
        } else {
            arrival[sender.tag - 10] = 1
        }
        print("Arrival \(arrival)")
        
        
        // color changes...
        for childView in view_arrivalTime.subviews {
            if childView.tag == sender.tag {
                arrivalDefaultColorImages(childView: childView as! GradientView, indexS:(sender.tag - 10))
            }
        }
    }
    
}
extension BusFilterVC : UITableViewDataSource, UITableViewDelegate, flitersAirlineCellDelegate {
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBusFilters.operator_array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // cell creation...
        var cell = tableView.dequeueReusableCell(withIdentifier: "FFlitersAirlineCell") as? FFlitersAirlineCell
        if cell == nil {
            tableView.register(UINib(nibName: "FFlitersAirlineCell", bundle: nil), forCellReuseIdentifier: "FFlitersAirlineCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "FFlitersAirlineCell") as? FFlitersAirlineCell
        }
        cell?.delegate = self
        
        // display information...
        cell?.displayAirline_infomration(airline_name: (DBusFilters.operator_array[indexPath.row]), selection_array: flightSel_array)
        cell?.selectionStyle = .none
        return cell!
    }

    // MARK:- CellActions
    func selectAirlineButton_Action(sender: UIButton, cell: UITableViewCell) {
        
        // get index path...
        let indexPath = tbl_airlines .indexPath(for: cell)
        let airline_name = DBusFilters.operator_array[(indexPath?.row)!]
        
        // check airline existed or not...
        var existIndex = -1
        for i in 0 ..< flightSel_array.count {
            
            let airline = flightSel_array[i]
            if airline_name == airline {
                existIndex = i
                break
            }
        }
        
        // add or remove element...
        if existIndex == -1 {
            flightSel_array.append(airline_name)
        } else {
            flightSel_array.remove(at: existIndex)
        }
        tbl_airlines.reloadData()
    }
}


