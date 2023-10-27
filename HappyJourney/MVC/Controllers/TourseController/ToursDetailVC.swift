//
//  NewToursDetailVC.swift
//  ExtactTravel
//
//  Created by Admin on 27/09/22.
//

import UIKit

class ToursDetailVC: UIViewController {
    
    @IBOutlet weak var img_package: UIImageView!
    @IBOutlet weak var lbl_productName: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    @IBOutlet weak var lbl_duration: UILabel!
//    @IBOutlet weak var lbl_description: UILabel!

    //    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    //
//    @IBOutlet weak var lbl_earlierDate: UILabel!
    
    @IBOutlet weak var star_rating: FloatRatingView!
//    @IBOutlet weak var lbl_CancelationDays: UILabel!
//    @IBOutlet weak var lbl_instantConfirmation: UILabel!
    
    //
    @IBOutlet weak var view_detailsMenu: UIView!
    @IBOutlet weak var tbl_details: UITableView!
    @IBOutlet weak var tbl_HContraint: NSLayoutConstraint!
    @IBOutlet weak var tbl_ratings: UITableView!
    @IBOutlet weak var tbl_HRatingContraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    
    @IBOutlet weak var view_header: UIView!
    
    // popup...
//    @IBOutlet var view_availabilityPopUp: UIView!
    @IBOutlet weak var view_addTraveller: UIView!
    @IBOutlet weak var txt_date: UITextField!
//    @IBOutlet weak var lbl_travellerCount: UILabel!
//    @IBOutlet weak var tbl_addTraveller: UITableView!
    
    @IBOutlet weak var tbl2_HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tbl2_reviews: UITableView!
    // MARK:- Variables
//    var transfer_dict: DTransferSearchItem?
//    var additionalInfo_Array: [Any] = []
//    var adultCount = 1
    var packageID : String!

    var menuTab = tablesList.overview
    
    var height = 0.0
    
    enum tablesList {
        case overview
        case details
        case impInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDetailsOfTour()
//        displayInformation()
//        view.backgroundColor = .appColor
        // Do any additional setup after loading the view.

//        view_addTraveller.isHidden = true
        
        view_header.viewShadow()
        
        tbl_details.delegate = self
        tbl_details.dataSource = self
        
        tbl2_reviews.delegate = self
        tbl2_reviews.dataSource = self
        tbl_details.estimatedRowHeight = UITableView.automaticDimension
        tbl2_reviews.estimatedRowHeight = UITableView.automaticDimension
        
        tbl_ratings.delegate = self
        tbl_ratings.dataSource = self
        tbl_ratings.rowHeight = UITableView.automaticDimension
        tbl_ratings.estimatedRowHeight = 30.0
        
        
        // getting transfer info...
    }
    
    
    
    
    // MARK: - Helpers
    func displayInformation() {
        
        let model = DToursDetailsModel.tourDetails.package
        lbl_productName.text = model.packageName
        lbl_code.text = model.packageCode
        lbl_duration.text = "Duration: \(model.duration! - 1) Night's / \(model.duration ?? 1) Days"
//        lbl_description.text = ""// "<div align=\"justify\">\(String(describing: model.packageDescription))</div>".htmlToAttributedString
        lbl_price.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "Rs", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        star_rating.rating = Double(model.rating!)
        
        let urlStr = String.init(format: "%@%@", Holiday_Image_URL, model.image)
        print("Package url: - \(urlStr)")
        img_package.sd_setImage(with: URL.init(string: urlStr), completed: nil)
        lbl_grandTotal.text = String(format: "%@ %@", DCurrencyModel.currency_saved?.currency_symbol ?? "Rs", (model.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0)).formattedWithSeparator())
        reloadTransferDetails_Information()
    }
    
    func reloadTransferDetails_Information() {
        
        self.view.isUserInteractionEnabled = false
        tbl_details.reloadData()
        tbl2_reviews.reloadData()
        tbl_ratings.reloadData()
//        tableHeightCalculation()
        table2HeightCalculation()
        
    }
    
    func table2HeightCalculation(){
            let frame = tbl2_reviews.rectForRow(at: IndexPath(row: 0, section: 0))
            height += frame.size.height

//        tbl2_HConstraint.constant = height + 50
        
        tbl_HContraint.constant = tbl_details.contentSize.height
        tbl2_HConstraint.constant = tbl2_reviews.contentSize.height
        tbl_HRatingContraint.constant = tbl_ratings.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - ButtonAction
    @IBAction func backBtnClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func menuButtonsClicked(_ sender: UIButton) {
        // selection tabs...
        for subView in view_detailsMenu.subviews {
            subView.alpha = 0.5
        }
        sender.alpha = 1.0
        
        // buttonActions...
        if sender.tag == 10 {
            menuTab = .overview
        }
        else if sender.tag == 11 {
            menuTab = .details
            tbl_HContraint.constant = 140
            tbl_details.reloadData()
            tbl2_reviews.reloadData()
        }
        else if sender.tag == 12 {
            menuTab = .impInfo
            tbl_HContraint.constant = 190
        }
        else {}
        tbl_details.reloadData()
        
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 0.5)
    }
    @objc func tableHeightCalculation() {
//        tbl_HContraint.constant = 40
        tbl_HContraint.constant = tbl_details.contentSize.height
        tbl2_HConstraint.constant = tbl2_reviews.contentSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            
            self.view.isUserInteractionEnabled = true
        }
    }
    @IBAction func clickBooked(_ sender: Any) {
        let vc = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "EnquiryFormVC") as! EnquiryFormVC
        vc.packgeID = DToursDetailsModel.tourDetails.package.packageID
        vc.packageName = DToursDetailsModel.tourDetails.package.packageName //packageID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}


extension ToursDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tbl2_reviews || tableView == tbl_ratings {
            let headerView = GradientView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
//            headerView.backgroundColor = .secInteraciaBlue
            headerView.startColor = .primInteraciaPink
            headerView.endColor = .secInteraciaBlue
            headerView.layer.cornerRadius = 5
            headerView.layer.borderWidth = 0
//            headerView.layer.borderColor = UIColor.systemGray.cgColor
            let label = UILabel()
            label.frame = CGRect.init(x: 15, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            
            if tableView == tbl_ratings {
                label.text = "Rating"
            } else if tableView == tbl2_reviews {
                label.text = "Terms and Condition"
            } else {}
            label.font = .systemFont(ofSize: 16)
            label.textColor = .white
            headerView.addSubview(label)
            return headerView
        }else {
            return nil//UIView()
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tbl2_reviews || tableView == tbl_ratings {
            return 40
        }else {
            return 0
            
        }
    }
    //    tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         if tableView == tbl2_reviews || tableView == tbl_ratings {
             return 1// DToursDetailsModel.tourDetails.packagePricePolicy
        } else {
            if menuTab == .overview {
                return 1
            } else if menuTab == .details {
                return DToursDetailsModel.tourDetails.packageItinerary.count
            } else {
                return DToursDetailsModel.tourDetails.packageTravellerPhotos.count// 1//additionalInfo_Array.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tbl_details {
            if menuTab == .details {
                return UITableView.automaticDimension
            }else if menuTab == .overview {
                return UITableView.automaticDimension
            }else{
                return CGFloat(240)
            }
        }else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tbl_ratings {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            if cell == nil {
                tableView.register(UINib(nibName: "CommonCell", bundle: nil), forCellReuseIdentifier: "CommonCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "CommonCell") as? CommonCell
            }
            cell?.lbl_title.text = String.init(format: "%d Star User Rating", DToursDetailsModel.tourDetails.package.rating ?? 0)
            
            cell?.backgroundColor = .white
            
            cell?.selectionStyle = .none
            return cell!
        }
        else if tableView == tbl2_reviews {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "TermAndCondTCellTableViewCell") as? TermAndCondTCellTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "TermAndCondTCellTableViewCell", bundle: nil), forCellReuseIdentifier: "TermAndCondTCellTableViewCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TermAndCondTCellTableViewCell") as? TermAndCondTCellTableViewCell
            }
            
            cell?.lbl_price_Includes.attributedText = "<div align=\"justify\">\(DToursDetailsModel.tourDetails.packagePricePolicy.priceIncludes)</div>".htmlToAttributedString
            cell?.lbl_price_Exclude.attributedText = "<div align=\"justify\">\(DToursDetailsModel.tourDetails.packagePricePolicy.priceExcludes)</div>".htmlToAttributedString
            cell?.lbl_cancellation_advance.attributedText = "<div align=\"justify\">\(DToursDetailsModel.tourDetails.packageCancelPolicy.cancellationAdvance)</div>".htmlToAttributedString
            cell?.lbl_cancellation_penalty.attributedText = "<div align=\"justify\">\(DToursDetailsModel.tourDetails.packageCancelPolicy.cancellationPenality)</div>".htmlToAttributedString
            
            cell?.selectionStyle = .none
            return cell!
            
        } else if menuTab == .overview || menuTab == .details {
            var cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
            if cell == nil {
                tableView.register(UINib(nibName: "TransferItineraryCell", bundle: nil), forCellReuseIdentifier: "TransferItineraryCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "TransferItineraryCell") as? TransferItineraryCell
            }
                if menuTab == .overview {
                    
                    cell?.lbl_title.text = DToursDetailsModel.tourDetails.package.packageName// String.init(format: "%@", "Overview")
                    let final_descript = "<div align=\"justify\">\(String(describing: DToursDetailsModel.tourDetails.package.packageDescription ?? ""))</div>"
                    cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
                    
                } else {
                    cell?.lbl_title.text = "Day \(DToursDetailsModel.tourDetails.packageItinerary[indexPath.row].day) \(DToursDetailsModel.tourDetails.packageItinerary[indexPath.row].place)"// String.init(format: "%@", "Details")
                    let final_descript = "<div align=\"justify\">\(DToursDetailsModel.tourDetails.packageItinerary[indexPath.row].itineraryDescription)</div>"
                    cell?.lbl_description.attributedText = final_descript.htmlToAttributedString
                }
                
                cell?.selectionStyle = .none
                return cell!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            if cell == nil {
                tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
                cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            }
            
//            let img_url = String.init(format: "%@", DToursDetailsModel.tourDetails .packageTravellerPhotos[indexPath.row].travellerImage)
            let urlStr = String.init(format: "%@%@", Holiday_Image_URL, DToursDetailsModel.tourDetails .packageTravellerPhotos[indexPath.row].travellerImage)
            var urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            cell?.img_image.sd_setImage(with: URL.init(string: urlString), completed: nil)
            
//            DToursDetailsModel.tourDetails.packageTravellerPhotos
//            cell?.imageView?.init(image: UIImage(named: "ic_bg"))
            return cell!

        }
    }
    }
extension ToursDetailVC {
func getDetailsOfTour() -> Void {
    CommonLoader.shared.startLoader(in: view)
    let paramString: [String: String] = ["package_id": packageID]
    // calling apis...
    VKAPIs.shared.getRequestFormdata(params: paramString, file: Tours_DetailMobile, httpMethod: .POST)
    { (resultObj, success, error) in
        // success status...
        if success == true {
                            print("Tour details success: \(String(describing: resultObj))")
            if let result = resultObj as? [String: Any] {
                DToursDetailsModel.createTourModel(result: result)
//                self.tourModel = DToursDetailsModel.tourDetails
                
            } else {
                print("Tour details formate : \(String(describing: resultObj))")
            }
        } else {
            print("Tour details error : \(String(describing: error?.localizedDescription))")
            self.view.makeToast(message: error?.localizedDescription ?? "")
        }
        self.displayInformation()
//        self.reloadTransferDetails_Information()
        CommonLoader.shared.stopLoader()
    }
//        DispatchQueue.main.async {
//        }


}
}
