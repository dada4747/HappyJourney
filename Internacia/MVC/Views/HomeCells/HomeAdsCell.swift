//
//  HomeAdsCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit
protocol TopDestinationHotelProtocol {
    func selectToDestHolidays(index: Int)
    func selectFlightDest(index: Int)
    func selectBusesDest(index: Int)
}

class HomeAdsCell: UITableViewCell{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var coll_ads: UICollectionView!
    @IBOutlet weak var hei_adsConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var view_title: CRView!
    
    @IBOutlet weak var lbl_title2: UILabel!
    var adsType = ""
    var topOffer_Array: [DCommonTopOfferItems] = []
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []
    var trendingFlight_Array: [DCommonTrendingFlightItem] = []
    var trendingBuses_Array: [DCommonTrendingBusesItem] = []
    var topDestHotelDelegate: TopDestinationHotelProtocol?
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
        

    }
    
    
    func displayTopHotelDestination(dest_array: [DCommonTrendingHotelItems]) {
        
        trendingHotel_Array = dest_array
        
//        bg_view.backgroundColor = .white//UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        hei_adsConstraint.constant = 150
        lbl_title2.text = "Popular Hotels"
        view_title.isHidden = false
        lbl_title.isHidden = true
        
        reloadCollection()
        
    }
    
    func displayTopFlighDestination(trendingFlight_Array: [DCommonTrendingFlightItem]){
        self.trendingFlight_Array = trendingFlight_Array
        
//        bg_view.backgroundColor = .white// UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        hei_adsConstraint.constant = 150
        lbl_title.text = "Top Flight"
        lbl_title.isHidden = true
        view_title.isHidden = false
        lbl_title2.text = "Top Flight Destinations"
        reloadCollection()
        
    }
    func displayTopBusesDestination(trendingBuses_Array: [DCommonTrendingBusesItem]){
        self.trendingBuses_Array = trendingBuses_Array
        
//        bg_view.backgroundColor = .white// UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        hei_adsConstraint.constant = 150
        lbl_title.text = "Top Buses"
        lbl_title.isHidden = true
        view_title.isHidden = false
        lbl_title2.text = "Top Bus Destinations"
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
        }else if adsType == "buses" {
//            let loWidth = (coll_ads.frame.size.width)/2
            return CGSize(width: 120, height: 150)
        }else if adsType == "Flight" {
            return CGSize(width: 120, height: 150)
        }
        else {
//            let loWidth = (coll_ads.frame.size.width)/2
            return CGSize(width: 120, height: 150)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if adsType == "Offers" {
            return topOffer_Array.count
        }else if adsType == "buses" {
            return trendingBuses_Array.count
        }else if adsType == "Flight" {
            return trendingFlight_Array.count
        }
        else {
            return trendingHotel_Array.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        if adsType == "Flight" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
            cell.displayFlightInfo(model: trendingFlight_Array[indexPath.row])
//            cell.index = indexPath.row
//            cell.topPackageCellDelegate = self
            return cell
        }else if adsType == "buses" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
            cell.displaybusInfo(model: trendingBuses_Array[indexPath.row])
            return cell
        }
        else {
            // cell creation...
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell //best holiday cell
            
            //display information...
            cell.displayTrendingHotelInformation(model: trendingHotel_Array[indexPath.row])

            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adsType == "Hotel" {
            print("this is selected hotel")
            topDestHotelDelegate?.selectToDestHolidays(index:  indexPath.row)
        } else if adsType == "Flight" {
            topDestHotelDelegate?.selectFlightDest(index: indexPath.row)
        } else if adsType == "buses" {
            topDestHotelDelegate?.selectBusesDest(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
    
}
