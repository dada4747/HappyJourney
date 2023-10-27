//
//  HomeAdsCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
protocol TopDestinationsProtocol {
    func selectToDestHotels(index: Int)
    func selectFlightDest(index: Int)
    func selectBusesDest(index: Int)
    func selectTopHolidays(index: Int)
}

class HomeAdsCell: UITableViewCell, TopPackageCellProtocol{
    func topSelectedPAckage(index: Int, cell: UICollectionViewCell) {
        topDestinationsDelegate?.selectTopHolidays(index: index)
    }
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bg_view: GradientView!
    @IBOutlet weak var coll_ads: UICollectionView!
//    @IBOutlet weak var hei_adsConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var view_title: CRView!
    
    var adsType = ""
    var topOffer_Array: [DCommonTopOfferItems] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
    var trendingBuses_Array: [DCommonTrendingBusesItem] = []
    var topDestinationsDelegate: TopDestinationsProtocol?
    var topHolidayDestinationArray: [DCommonTrendingPackageItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addDelegates()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse(){
        super.prepareForReuse()
        
    }
    func addDelegates() {
        
        // delegate...
        coll_ads.delegate = self
        coll_ads.dataSource = self
        
        // register...
        coll_ads.register(UINib.init(nibName: "TopDestinationCVCell", bundle: nil), forCellWithReuseIdentifier: "TopDestinationCVCell")
        coll_ads.register(UINib.init(nibName: "RecommendHotelsCVCell", bundle: nil), forCellWithReuseIdentifier: "RecommendHotelsCVCell")
        
        coll_ads.register(UINib.init(nibName: "TopFlightCVCell", bundle: nil), forCellWithReuseIdentifier: "TopFlightCVCell")
        coll_ads.register(UINib.init(nibName: "TopPackageCVCell", bundle: nil), forCellWithReuseIdentifier: "TopPackageCVCell")

    }
    
    
    func displayTopHotelDestination(dest_array: [DCommonTrendingHotelItems]) {
        
        trendingHotel_Array = dest_array
        lbl_title.text = "RECOMMENDED HOTELS FOR YOU"
//        bg_view.backgroundColor = .white//UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
//        hei_adsConstraint.constant = 150
        
        reloadCollection()
        
    }
    func dispayTopPopularDestination(){
        lbl_title.text = "POPULAR DESTINATION"
        reloadCollection()
    }
    func displayHotelAroundTheWorld(){
        lbl_title.text = "HOTELS AROUND THE WORLD"
        reloadCollection()
    }
    func dispayExperienceInSpotlight(){
        lbl_title.text = "EXPERIENCE IN THE SPOTLIGHT"
        reloadCollection()
    }
    func displayTopFlighDestination(trendingFlight_Array: [DCommonTrendingFlightItem]){
        self.trendingFlight_Array = trendingFlight_Array
        
//        bg_view.backgroundColor = .white// UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
//        hei_adsConstraint.constant = 150
        lbl_title.text = "POPULAR FLIGHT"
        reloadCollection()
        
    }
    func topHolidayDestination(trendingHolidayPackage: [DCommonTrendingPackageItem]){
        lbl_title.text = "POPULAR HOLIDAY DESTINATION"
        topHolidayDestinationArray = trendingHolidayPackage
        reloadCollection()
    }
    func displayTopBusesDestination(trendingBuses_Array: [DCommonTrendingBusesItem]){
        self.trendingBuses_Array = trendingBuses_Array
        
//        bg_view.backgroundColor = .white// UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
//        hei_adsConstraint.constant = 150
        lbl_title.text = "Top Buses"
        reloadCollection()
    }
    func reloadCollection(){
        DispatchQueue.main.async {
            self.coll_ads.reloadData()

        }

    }
}


extension HomeAdsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if adsType == "Offers" {
            return CGSize(width:(coll_ads.frame.size.width)/1.4, height: 170)
        }else if adsType == "Buses" {
//            let loWidth = (coll_ads.frame.size.width)/2
            return CGSize(width: 130, height: 160)
        }else if adsType == "Flight" {
            return CGSize(width: 190, height: 230)
        } else if adsType == "POPULAR DESTINATION" {
            return CGSize(width: 185, height: 242)
        }else if adsType == "Hotel"{
            return CGSize(width: 190, height: 230)

        }else if adsType == "Holidays"{
         return CGSize(width: 230, height: 195)
        }
        else {
            let loWidth = (coll_ads.frame.size.width)/2
            return CGSize(width: 240, height: 243)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if adsType == "Offers" {
            return topOffer_Array.count
        }else if adsType == "Buses" {
            return trendingBuses_Array.count
        }else if adsType == "Flight" {
            return trendingFlight_Array.count
        }else if adsType == "POPULAR DESTINATION" {
            return 4
        }else if adsType == "Hotel" {
            return trendingHotel_Array.count
        }else if adsType == "Holidays"{
            return topHolidayDestinationArray.count
        }
        else {
            return 7//trendingHotel_Array.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if adsType == "Hotel" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
            cell.displayTrendingHotelInformation(model: trendingHotel_Array[indexPath.row])
            return cell
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendHotelsCVCell", for: indexPath as IndexPath) as! RecommendHotelsCVCell //best holiday cell
//
//            //display information...
////            cell.displayFlightInfo(model: trendingFlight_Array[indexPath.row])
////            cell.index = indexPath.row
////            cell.topPackageCellDelegate = self
//            return cell
        }
        if adsType == "Flight" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopFlightCVCell", for: indexPath as IndexPath) as! TopFlightCVCell //best holiday cell
            
            //display information...
            cell.displayFlightInfo(model: trendingFlight_Array[indexPath.row])
//            cell.index = indexPath.row
//            cell.topPackageCellDelegate = self
            return cell
        }else if adsType == "POPULAR DESTINATION" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
//            cell.displaybusInfo(model: trendingBuses_Array[indexPath.row])
            return cell
        }else if adsType == "HOTELS AROUND THE WORLD" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendHotelsCVCell", for: indexPath as IndexPath) as! RecommendHotelsCVCell
            cell.lbl_reviews.isHidden = true
            cell.view_rating.isHidden = true
            cell.lbl_hotelNames.font = UIFont(name: "Helvetica", size: 12.0)

            cell.rating_HConstraint.constant  = 0
            cell.review_HConstraint.constant  = 0
            cell.lbl_city.isHidden = true
            cell.view_rating_review.isHidden = false
//            cell.lbl_reviews.frame.size.height = 0
//            cell.view_rating.frame.size.height = 0
            return cell
        }else if adsType == "Holidays" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopPackageCVCell", for: indexPath as IndexPath) as! TopPackageCVCell //best holiday cell
            
            //display information...
            cell.displayTrendingPackageInfo(model: topHolidayDestinationArray[indexPath.row])
            cell.index = indexPath.row
            cell.topPackageCellDelegate = self
            return cell
        }else if adsType == "Buses" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopFlightCVCell", for: indexPath as IndexPath) as! TopFlightCVCell //best holiday cell
            
            //display information...
            let model = trendingBuses_Array[indexPath.row]
            cell.from_dest.text = "\(model.from_bus_name ?? "")"
            cell.image.sd_setImage(with: URL.init(string: (model.imageStr?.replacingOccurrences(of: " ", with: "%20"))!), completed: nil)
//            cell.displayFlightInfo(model: trendingFlight_Array[indexPath.row])
//            cell.index = indexPath.row
//            cell.topPackageCellDelegate = self
            return cell
        }
        else {
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendHotelsCVCell", for: indexPath as IndexPath) as! RecommendHotelsCVCell //best holiday cell
            
            //display information...
//            cell.displayTrendingHotelInformation(model: trendingHotel_Array[indexPath.row])

            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adsType == "Hotel" {
            print("this is selected hotel")
            topDestinationsDelegate?.selectToDestHotels(index:  indexPath.row)
        } else if adsType == "Flight" {
            topDestinationsDelegate?.selectFlightDest(index: indexPath.row)
        } else if adsType == "Buses" {
            topDestinationsDelegate?.selectBusesDest(index: indexPath.row)
        }else if adsType == "Holidays" {
            print(indexPath.row)
//            topDestinationsDelegate?.selectTopHolidays(index: indexPath.row)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        
    }
    
}
