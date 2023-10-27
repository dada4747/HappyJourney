//
//  DetailsToursVC.swift
//  ExtactTravel
//
//  Created by Admin on 16/08/22.
//

import UIKit
import WebKit
//MARK: - Enums
enum tablesList {
    case Overview
    case Details
    case Gallary
}
class DetailsToursVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var view_headerView: UIView!
    @IBOutlet weak var pg_pageControll: UIPageControl!
    @IBOutlet weak var c_coursol: iCarousel!
    @IBOutlet weak var lbl_tourName: UILabel!
    @IBOutlet weak var lbl_packagCode: UILabel!
    @IBOutlet weak var flt_star_Rating: FloatRatingView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_perRoom: UILabel!
    @IBOutlet weak var lbl_dayNight: UILabel!
    @IBOutlet weak var view_detailsMEnu: UIView!
    @IBOutlet weak var tbl_detailView: UITableView!
    //    @IBOutlet weak var tblh_constraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_grandTotal: UILabel!
    @IBOutlet weak var btn_backButton: UIButton!
    @IBOutlet weak var collectionView_gallary: UICollectionView!
    @IBOutlet weak var lbl_totalPrice: UILabel!
    //MARK: - Variables
    var tourModel : TourDetailsItem = TourDetailsItem()
    var menuTab = tablesList.Overview
    var heighforCell : CGFloat?
    var packageID : String!
    var contentHeights : [CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var overviewContentHeight : [CGFloat] = [0.0]
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .appColor
        getDetailsOfTour()
        collectionView_gallary.isHidden = true
        view_headerView.viewShadow()
        //carsoul
        c_coursol.delegate = self
        c_coursol.dataSource = self
        c_coursol.isPagingEnabled = true
        c_coursol.type = iCarouselType.linear
        //table
        tbl_detailView.delegate = self
        tbl_detailView.dataSource = self
        tbl_detailView.rowHeight = UITableView.automaticDimension;
        
                tbl_detailView.estimatedRowHeight = 105
        collectionView_gallary.delegate = self
        collectionView_gallary.dataSource = self
        collectionView_gallary.register(UINib.init(nibName: "GallaryImageCVCell", bundle: nil), forCellWithReuseIdentifier: "GallaryImageCVCell")
    }
    //MARK: - IBActions
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func menuButtonsClick(_ sender: UIButton) {
        for subView in view_detailsMEnu.subviews {
            subView.alpha = 0.5
        }
        sender.alpha = 1.0
        if sender.tag == 10 {
            tbl_detailView.isHidden = false
            collectionView_gallary.isHidden = true
            menuTab = .Overview
            tbl_detailView.reloadData()
            
        } else if sender.tag == 11 {
            tbl_detailView.isHidden = false
            collectionView_gallary.isHidden = true
            menuTab = .Details
            tbl_detailView.reloadData()
        } else if sender.tag == 12 {
            tbl_detailView.isHidden = true
            collectionView_gallary.isHidden = false
            menuTab = .Gallary
            collectionView_gallary.reloadData()
        } else {}
        self.view.isUserInteractionEnabled = false
        self.perform(#selector(tableHeightCalculation), with: nil, afterDelay: 0.5)
    }
    
    @IBAction func clickBooked(_ sender: Any) {
        let vc = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "EnquiryFormVC") as! EnquiryFormVC
        vc.packgeID = tourModel.package.packageID
        vc.packageName = tourModel.package.packageName //packageID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //MARK: - OBJC function
    @objc func tableHeightCalculation() {
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.view.isUserInteractionEnabled = true
        }
    }
    //MARK: - Functions
    func displayInformation(){
        print("Number of Photoes  --- --- -- --  \(tourModel.packageTravellerPhotos.count)")
        for content in 0..<tourModel.packageItinerary.count {
            print(content)
            contentHeights.append(0.0)
        }
        print(contentHeights)
        self.pg_pageControll.numberOfPages = tourModel.packageTravellerPhotos.count
        self.c_coursol.reloadData()
        flt_star_Rating.rating = Double(tourModel.package.rating!)// cost

        lbl_price.text =  String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "Rs", tourModel.package.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// "\(tourModel.currencyObj.toCurrency) \(tourModel.package.price)"
        lbl_perRoom.text = "Per Person"
        lbl_tourName.text = tourModel.package.packageName
        lbl_dayNight.text = "0 Night / \(tourModel.package.duration ) Days"
        lbl_packagCode.text = tourModel.package.packageCode
        lbl_totalPrice.text = String(format: "%@ %.2f", DCurrencyModel.currency_saved?.currency_symbol ?? "Rs", tourModel.package.price * (DCurrencyModel.currency_saved?.currency_value ?? 1.0))// "\(tourModel.currencyObj.toCurrency) \(tourModel.package.price)"
        tbl_detailView.reloadData()
    }
}
//MARK: -  Custom Delegates
//extension DetailsToursVC : cellHeightDelegate{
//    func cellheight(height: CGFloat) {
//        DispatchQueue.main.async {
//            self.heighforCell = height
////            self.tbl_detailView.rowHeigh
////            self.tbl_detailView.beginUpdates()
////            self.tbl_detailView.endUpdates()
//        }
//        print("____________________\(height)_____________")
//    }
//}
//MARK: - UITableViewDelegate & DataSource
extension DetailsToursVC : UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuTab == .Overview {
            return 1
        } else if menuTab == .Details {
            return tourModel.packageItinerary.count
        } else if menuTab == .Gallary {
            return tourModel.packageTravellerPhotos.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
            let htmlEnd = "</BODY></HTML>"
        var cell = tableView.dequeueReusableCell(withIdentifier: "DetailWebViewCell") as? DetailWebViewCell
        if cell == nil {
            tableView.register(UINib(nibName: "DetailWebViewCell", bundle: nil), forCellReuseIdentifier: "DetailWebViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "DetailWebViewCell") as? DetailWebViewCell
        }
        
        cell?.wbView_Details.scrollView.isScrollEnabled = false
        cell?.wbView_Details.isUserInteractionEnabled = false
        cell?.wbView_Details.scrollView.isPagingEnabled = false
        cell?.layer.cornerRadius = 5
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        if menuTab == .Overview {
            heighforCell = 0

            cell?.wbView_Details.loadHTMLString(htmlStart + tourModel.package.packageDescription! + htmlEnd, baseURL: nil)
            cell?.lbl_Day.isHidden = true
            let htmlHeight = overviewContentHeight[indexPath.row]
            cell?.wbView_Details.tag = indexPath.row
            cell?.wbView_Details.navigationDelegate = self
            cell?.wbView_Details.frame = CGRect(x: 0, y: 0, width: (cell?.frame.size.width)!, height: htmlHeight)

            cell?.lbl_name.text = tourModel.package.packageName
            cell?.wbView_Details.scrollView.isScrollEnabled = false
            cell?.selectionStyle = .none
            return cell!
        } else {
            heighforCell = 0

            cell?.wbView_Details.loadHTMLString("\(htmlStart)\(tourModel.packageItinerary[indexPath.row].itineraryDescription)\(htmlEnd)", baseURL: Bundle.main.bundleURL)
            cell?.lbl_Day.isHidden = false
            cell?.lbl_Day.text = "Day \(tourModel.packageItinerary[indexPath.row].day)"
            cell?.lbl_name.text = tourModel.packageItinerary[indexPath.row].place
            let htmlHeight = contentHeights[indexPath.row]
            cell?.wbView_Details.tag = indexPath.row
            cell?.wbView_Details.navigationDelegate = self
            cell?.wbView_Details.frame = CGRect(x: 0, y: 0, width: (cell?.frame.size.width)!, height: htmlHeight)

            cell?.selectionStyle = .none
            
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuTab == .Overview {
            return overviewContentHeight[indexPath.row]
        }else{
            return contentHeights[indexPath.row]
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                   if complete != nil {
                       webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                           guard let heightT = height as? CGFloat else { return }
                           DispatchQueue.main.async {
                            if self.menuTab == .Details {
                                
                                 if (self.contentHeights[webView.tag] != 0.0)
                                 {
                                     return
                                 }
                                 self.contentHeights[webView.tag] = heightT + 60// webView.scrollView.contentSize.height
                                 self.tbl_detailView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: .automatic)
                            }else {
                                if (self.overviewContentHeight[webView.tag] != 0.0)
                                {
                                    return
                                }
                                self.overviewContentHeight[webView.tag] = heightT + 60// webView.scrollView.contentSize.height
                                self.tbl_detailView.reloadRows(at: [IndexPath(row: webView.tag, section: 0)], with: .automatic)
                            }
                           }
                       })
                   }
               })
        
    }
}
//MARK: -  UICollectionView
extension DetailsToursVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(collectionView.frame.size.width)
        let loWidth = (collectionView.frame.size.width - 10) / 2
        print(loWidth)
        return CGSize(width: loWidth , height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tourModel.packageTravellerPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GallaryImageCVCell", for: indexPath as IndexPath) as? GallaryImageCVCell
        cell?.img_gallaryimg.sd_setImage(with: URL.init(string: "\(tourModel.packageTravellerPhotos[indexPath.row].travellerImage)"), completed: nil)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5

    }
    
}
//MARK: - iCarouselDelegate
extension DetailsToursVC : iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        tourModel.packageTravellerPhotos.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        //create view
        let tempView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height))
        tempView.backgroundColor = UIColor.clear
        // add image view...
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 0, y: 0, width: carousel.frame.size.width, height: carousel.frame.size.height)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        tempView.addSubview(imgView)
        let urlStr = "\(tourModel.packageTravellerPhotos[index].travellerImage)"
        imgView.sd_setImage(with: URL.init(string: urlStr), completed: nil)
        return tempView
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if option == iCarouselOption.spacing {
            return value * 1.01
        }
        return value
    }
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pg_pageControll.currentPage = carousel.currentItemIndex
    }
}

//MARK:- API Call
extension DetailsToursVC {
    
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
                    self.tourModel = DToursDetailsModel.tourDetails
                    
                } else {
                    print("Tour details formate : \(String(describing: resultObj))")
                }
            } else {
                print("Tour details error : \(String(describing: error?.localizedDescription))")
                self.view.makeToast(message: error?.localizedDescription ?? "")
            }
            self.displayInformation()
            CommonLoader.shared.stopLoader()
        }
//        DispatchQueue.main.async {
//        }


    }
}

