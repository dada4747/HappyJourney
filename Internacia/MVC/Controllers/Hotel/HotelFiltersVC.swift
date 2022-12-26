//
//  HotelFiltersVC.swift
//  Internacia
//
//  Created by Admin on 31/10/22.
//

import UIKit

// protocol...
protocol hotelFiltersDelegate {
    func hotelsFiltersApply_removeIntimation()
}

// class...
class HotelFiltersVC: UIViewController {

    // MARK:- Outlets
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_sort: UIButton!
    
    // MARK:- filter
    @IBOutlet weak var scroll_filters: UIScrollView!
    @IBOutlet weak var lbl_priceAmt: UILabel!
    @IBOutlet weak var view_silderMain: UIView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var view_starRating: UIView!
    @IBOutlet weak var btn_wifi: UIButton!
    @IBOutlet weak var btn_breakfast: UIButton!
    @IBOutlet weak var btn_parking: UIButton!
    @IBOutlet weak var btn_swimPool: UIButton!
    
    
    // MARK:- sort
    @IBOutlet weak var scroll_sortView: UIScrollView!
    @IBOutlet weak var btn_priceLow: UIButton!
    @IBOutlet weak var btn_priceHigh: UIButton!
    
    @IBOutlet weak var btn_starLow: UIButton!
    @IBOutlet weak var btn_starHigh: UIButton!
    
    @IBOutlet weak var btn_AZ: UIButton!
    @IBOutlet weak var btn_ZA: UIButton!
    
    
    // variables...
    var delegate: hotelFiltersDelegate?
    var defaultColor = UIColor.secInteraciaBlue
    let rangeSlider = RangeSlider(frame: CGRect.zero)
    
    var onePort_value: Float = 0.0
    var final_min: Float = 0.0
    var final_max: Float = 1.0
    
    var star_rating: [Int] = [0, 0, 0, 0, 0]
    var amenities: [Int] = [0, 0, 0, 0]
    var sort_number: Int = -1
    
    
    // MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // bottom shadow...
        view_header.viewShadow()
        
        defaultColor = .secInteraciaBlue// btn_filter.backgroundColor!
        addDelegatesAndElements()
        
        displayFilters_information()
        displaySort_information()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Display
    func displayFilters_information() {
        
        // price information...
        rangeSlider.lowerValue = Double((DHotelFilters.price_selection.0 - DHotelFilters.price_default.0)/(onePort_value * 10))
        rangeSlider.upperValue = Double((DHotelFilters.price_selection.1 - DHotelFilters.price_default.0)/(onePort_value * 10))
        
        final_min = DHotelFilters.price_selection.0
        final_max = DHotelFilters.price_selection.1
        lbl_priceAmt.text = "\(String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) - \(String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) "
//        lbl_priceAmt.text = String(format: "%@ %.2f - %@ %.2f", DHotelFilters.currency_code, final_min, DHotelFilters.currency_code, final_max)

        // stars color changes information...
        star_rating = DHotelFilters.star_rating
        for i in 0 ..< star_rating.count {
            if star_rating[i] != 0 {
                
                // color changes...
                for childView in view_starRating.subviews {
                    if childView.tag == (i + 10) {
                        starsDefaultColorImages(childView: childView, indexS: i)
                    }
                }
            }
        }
        
        
        // amenities images changing...
        amenities = DHotelFilters.amenities
        if amenities[0] == 1 {
            btn_wifi.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        if amenities[1] == 1 {
            btn_breakfast.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        if amenities[2] == 1 {
            btn_parking.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        if amenities[3] == 1 {
            btn_swimPool.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
    }
    
    func displaySort_information() {
        
        // sort...
        sort_number = DHotelFilters.sort_number
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        btn_starLow.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_starHigh.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        btn_AZ.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_ZA.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        
        // actions...
        if sort_number == 0 {
            btn_priceLow.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else if sort_number == 1 {
            btn_priceHigh.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else if sort_number == 2 {
            btn_starLow.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else if sort_number == 3 {
            btn_starHigh.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else if sort_number == 4 {
            btn_AZ.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else if sort_number == 5 {
            btn_ZA.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        else {}
    }
    
    func starsDefaultColorImages(childView: UIView, indexS: Int) {
        
        // default and selecion actions changing...
        for subChild in childView.subviews {
            
            // change images...
            if subChild is UIImageView {
                
                let img_subChild = subChild as! UIImageView
                img_subChild.image = UIImage.init(named: "ic_star")
                if star_rating[indexS] == 1 {
                    img_subChild.image = UIImage.init(named: "ic_star_grey") //childView.tag == 10 &&
                }
                
            }
            
            // text color
            if subChild is UILabel {
                
                // default color...
                let lbl_subChild = subChild as! UILabel
                lbl_subChild.textColor = UIColor.init(red: 195.0/255.0, green: 195.0/255.0, blue: 205.0/255.0, alpha: 1.0)
                childView.backgroundColor = UIColor.white
                
                // select color...
                if star_rating[indexS] == 1 && childView.tag == (indexS + 10) {
                    childView.backgroundColor = defaultColor
                    lbl_subChild.textColor = UIColor.white
                }
            }
        }
    }
    
    
    // MARK:- Helpers
    func addDelegatesAndElements() {
        
        // Range slider adding...
        rangeSlider.frame = CGRect.init(x: 0, y: 0, width: (self.view.frame.size.width-80), height: 20)
        rangeSlider.thumbBorderWidth = 0
        rangeSlider.thumbTintColor =  defaultColor
        rangeSlider.trackTintColor = .gray
        rangeSlider.trackHighlightTintColor = defaultColor
        rangeSlider.lowerValue = 0
        rangeSlider.upperValue = 1
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(slider:)), for: .valueChanged)
        view_silderMain.addSubview(rangeSlider)
        
        // min and max...
        onePort_value = (DHotelFilters.price_default.1 - DHotelFilters.price_default.0) / 10
        if onePort_value == 0 {
            onePort_value = 0.1
        }
        rangeSliderValueChanged(slider: rangeSlider)
        print("One part : \(onePort_value)")
    }
    
    @objc func rangeSliderValueChanged(slider: RangeSlider) {
        
        // min and max...
        final_min = DHotelFilters.price_default.0 + (onePort_value * Float(slider.lowerValue * 10))
        final_max = DHotelFilters.price_default.0 + (onePort_value * Float(slider.upperValue * 10))
        
        // display price...
        lbl_priceAmt.text = "\(String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", final_min * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) - \(String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_country ?? "USD", final_max * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))) "
//        lbl_priceAmt.text = String(format: "%@ %.2f - %@ %.2f", DHotelFilters.currency_code, final_min, DHotelFilters.currency_code, final_max)
    }
    
    
    // MARK:- ButtonActions
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterAndSortButtonsClicked(_ sender: UIButton) {
        
        // color changes...
        btn_filter.backgroundColor = UIColor.white
        btn_filter.setTitleColor(UIColor.black, for: .normal)
        
        btn_sort.backgroundColor = UIColor.white
        btn_sort.setTitleColor(UIColor.black, for: .normal)
        
        // selection color..
        sender.backgroundColor = defaultColor
        sender.setTitleColor(UIColor.white, for: .normal)
        
        // filter, sort views showing...
        scroll_filters.isHidden = true
        scroll_sortView.isHidden = true
        if sender.tag == 10 {
            scroll_filters.isHidden = false
        } else {
            scroll_sortView.isHidden = false
        }
    }
    
    @IBAction func saveAndCancelButtonsClicked(_ sender: UIButton) {
        
        // move to back screen...
        if sender.tag == 10 {
            // sort...
            DHotelFilters.sort_number = sort_number

            // price filter added...
            if (rangeSlider.lowerValue > Double(DHotelFilters.price_default.0)) || (rangeSlider.upperValue < Double( DHotelFilters.price_default.1)) {
                DHotelFilters.price_selection = (final_min, final_max)
            }

            // stops..
            DHotelFilters.star_rating = star_rating
            DHotelFilters.amenities = amenities
        }
        else {
            // reset filters...
            DHotelFilters.getHotelssAndPrice_fromResponse()
        }
        
        // delegates...
        delegate?.hotelsFiltersApply_removeIntimation()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:-
    @IBAction func starRatingButtonsClicked(_ sender: UIButton) {
        
        // selection index changings...
        if star_rating[sender.tag - 10] == 1 {
            star_rating[sender.tag - 10] = 0
        } else {
            star_rating[sender.tag - 10] = 1
        }
        print("Star rating :\(star_rating)")
        
        
        // color changes...
        for childView in view_starRating.subviews {
            if childView.tag == sender.tag {
                starsDefaultColorImages(childView: childView, indexS:(sender.tag - 10))
            }
        }
    }
    
    @IBAction func amenitiesButtonClicked(_ sender: UIButton) {
        
        // selection index changings...
        if amenities[sender.tag - 10] == 1 {
            amenities[sender.tag - 10] = 0
            sender.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        } else {
            amenities[sender.tag - 10] = 1
            sender.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
        }
        print("Amenities :\(amenities)")
        
    }
    
    @IBAction func allSortingButtonsClicked(_ sender: UIButton) {
        
        
        // clear images...
        btn_priceLow.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_priceHigh.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        btn_starLow.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_starHigh.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        btn_AZ.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        btn_ZA.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
        
        // actions...
        if sort_number == (sender.tag - 10) {
            sender.setImage(UIImage.init(named: "ic_check_p"), for: .normal)
            sort_number = -1
        } else {
            sender.setImage(UIImage.init(named: "checkmark.square.fill"), for: .normal)
            sort_number = (sender.tag - 10)
        }
    }
}
