//
//  TopHolidayDestCell.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

class TopHolidayDestCell: UITableViewCell {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var coll_dest: UICollectionView!
    @IBOutlet weak var hei_adsConstraint: NSLayoutConstraint!
    
    var trendingHotel_Array: [DCommonTrendingHotelItems] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addDelegates()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addDelegates() {
        
        // delegate...
        coll_dest.delegate = self
        coll_dest.dataSource = self
        
        // register...
        coll_dest.register(UINib.init(nibName: "TopDestinationCVCell", bundle: nil), forCellWithReuseIdentifier: "TopDestinationCVCell")
    }
    
    func displayTopHotelDestination(dest_array: [DCommonTrendingHotelItems]) {
        
        trendingHotel_Array = dest_array
        
        bg_view.backgroundColor = UIColor.init(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        
        var hei_count = 1
        let arrayCount = trendingHotel_Array.count
        if trendingHotel_Array.count%2 != 0 {
            hei_count = arrayCount / 2  + 1
        } else {
            hei_count = arrayCount / 2
        }
        
        hei_adsConstraint.constant = CGFloat(155 * hei_count)
        lbl_title.text = "Budget Hotels"
        
        coll_dest.reloadData()
    }

}

extension TopHolidayDestCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK:- UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let loWidth = (collectionView.frame.size.width - 5)/2
        return CGSize(width: loWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return trendingHotel_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // cell creation...
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopDestinationCVCell", for: indexPath as IndexPath) as! TopDestinationCVCell
        
        //display information...
        cell.displayTrendingHotelInformation(model: trendingHotel_Array[indexPath.row])

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
        
    }
    
}

