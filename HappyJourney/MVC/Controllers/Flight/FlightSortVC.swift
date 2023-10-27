//
//  FlightSortVC.swift
//  HappyJourney
//
//  Created by Admin on 09/05/23.
//

import UIKit
protocol flightSortingDelegate{
    func sortingApply()
}
class FlightSortVC: UIViewController {
    @IBOutlet weak var scroll_sortView: UIScrollView!
    //    @IBOutlet weak var btn_priceLow: UIButton!
    //    @IBOutlet weak var btn_priceHigh: UIButton!
    //
    //    @IBOutlet weak var btn_departEarly: UIButton!
    //    @IBOutlet weak var btn_deaprtLate: UIButton!
    //
    //    @IBOutlet weak var btn_durationShort: UIButton!
    //    @IBOutlet weak var btn_durationLong: UIButton!
    //
    //    @IBOutlet weak var btn_arrivalEarly: UIButton!
    //    @IBOutlet weak var btn_arrivalLate: UIButton!
    //
    //    @IBOutlet weak var btn_popularityHigh: UIButton!
    //    @IBOutlet weak var btn_ : UIButton!
    
    
    @IBOutlet weak var img_priceLow: UIImageView!
    @IBOutlet weak var img_priceHigh: UIImageView!
    @IBOutlet weak var img_departEarly: UIImageView!
    @IBOutlet weak var img_deaprtLate: UIImageView!
    @IBOutlet weak var img_durationShort: UIImageView!
    @IBOutlet weak var img_durationLong: UIImageView!
    @IBOutlet weak var img_arrivalEarly: UIImageView!
    @IBOutlet weak var img_arrivalLate: UIImageView!
    @IBOutlet weak var img_popularityHigh: UIImageView!
    
    
    
    var sort_number = -1
    
    
    var delegate: flightSortingDelegate?
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DFlightFilters.sort_number)
        sort_number = DFlightFilters.sort_number
        
        displaySort_information()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func displaySort_information() {
        
        // sort...
        //        sort_number = DFlightFilters.sort_number
        print(sort_number)
        // clear images...
        img_priceLow.image = UIImage(named: "ic_check")
        img_priceHigh.image = UIImage(named: "ic_check")
        img_departEarly.image = UIImage(named: "ic_check")
        img_deaprtLate.image = UIImage(named: "ic_check")
        img_durationShort.image = UIImage(named: "ic_check")
        img_durationLong.image = UIImage(named: "ic_check")
        img_arrivalEarly.image = UIImage(named: "ic_check")
        img_arrivalLate.image = UIImage(named: "ic_check")
        img_popularityHigh.image = UIImage(named: "ic_check")
        
        
        //        btn_priceLow.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //        btn_priceHigh.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //
        //        btn_departEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //        btn_deaprtLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //
        //        btn_durationShort.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //        btn_durationLong.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //
        //        btn_arrivalEarly.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //        btn_arrivalLate.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //
        
        // actions...
        if sort_number == 0 {
            img_priceLow.image = UIImage(named: "ic_checked")
            //            btn_priceLow.setImage(, for: .normal)
        }
        else if sort_number == 1 {
            img_priceHigh.image = UIImage(named: "ic_checked")
            //            btn_priceHigh.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 2 {
            img_departEarly.image = UIImage(named: "ic_checked")
            //            btn_departEarly.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 3 {
            img_deaprtLate.image = UIImage(named: "ic_checked")
            //            btn_deaprtLate.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 4 {
            img_durationShort.image = UIImage(named: "ic_checked")
            //            btn_durationShort.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 5 {
            img_durationLong.image = UIImage(named: "ic_checked")
            //            btn_durationLong.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 6 {
            img_arrivalEarly.image = UIImage(named: "ic_checked")
            //            btn_arrivalEarly.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 7 {
            img_arrivalLate.image = UIImage(named: "ic_checked")
            //            btn_arrivalLate.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        }
        else if sort_number == 8 {
            img_popularityHigh.image = UIImage(named: "ic_checked")
        }
        else {}
    }
    @IBAction func allSortingButtonsClicked(_ sender: UIButton) {
        
        // clear images...
        img_priceLow.image = UIImage(named: "ic_check")
        img_priceHigh.image = UIImage(named: "ic_check")
        img_departEarly.image = UIImage(named: "ic_check")
        img_deaprtLate.image = UIImage(named: "ic_check")
        img_durationShort.image = UIImage(named: "ic_check")
        img_durationLong.image = UIImage(named: "ic_check")
        img_arrivalEarly.image = UIImage(named: "ic_check")
        img_arrivalLate.image = UIImage(named: "ic_check")
        img_popularityHigh.image = UIImage(named: "ic_check")
        
        
        
        // actions...
        if sort_number == (sender.tag - 10 ) {
            sort_number = -1
            
        }else{
            sort_number = (sender.tag - 10)
            
        }
        displaySort_information()
        //        if sort_number == 0 {
        //            img_priceLow
        //        }else if sort_number == 1{
        //            img_priceHigh
        //        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        //        if sort_number == (sender.tag - 10) {
        //
        //            sender.setImage(UIImage.init(named: "ic_check"), for: .normal)
        //            sort_number = -1
        //        } else {
        //            sender.setImage(UIImage.init(named: "ic_checked"), for: .normal)
        //            sort_number = (sender.tag - 10)
        //        }
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func applySortAction(_ sender: Any) {
        DFlightFilters.sort_number = sort_number
        print(sort_number)
        print(DFlightFilters.sort_number)
        delegate?.sortingApply()
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
