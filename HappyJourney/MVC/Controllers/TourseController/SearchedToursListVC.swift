//
//  SearchedToursListVC.swift
//  ExtactTravel
//
//  Created by Admin on 12/08/22.
//

import UIKit

class SearchedToursListVC: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var header_View: UIView!
    @IBOutlet weak var tbl_toursList: UITableView!
    
    
    @IBOutlet weak var img_nameFilter: UIImageView!
    
    @IBOutlet weak var img_ratingFilter: UIImageView!
    
    @IBOutlet weak var img_priceFilter: UIImageView!
    //MARK: - Variables
    var packageSearchParam: [String: Any] = [:]
    var packageArray: [TourPackageItem] = []
    var tourseMainArray: [TourPackageItem] = []
    var sort_number : Int = 0
    var sortByName = true
    var sortByRating = true
    var sortByPrice = true
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        header_View.viewShadow()
//        view.backgroundColor = .appColor
        tbl_toursList.delegate = self
        tbl_toursList.dataSource = self
        tbl_toursList.rowHeight = UITableView.automaticDimension;
            
        tbl_toursList.estimatedRowHeight = 200
            
        getSearchedTourse()
    }
    //MARK:- Custom Function
    func reloadInfo() {
        tourseMainArray = DToursFilterModel.applyAll_filterAndSorting(_tranfers:  DTourPackageModel.packageArray)
        packageArray = tourseMainArray
        
//                            DispatchQueue.main.async {
            self.tbl_toursList.reloadData()
//                            }
        let indexPath = IndexPath.init(row: 0, section: 0)
        if packageArray.count != 0 {
            tbl_toursList.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    //MARK: - IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nameFilterAction(_ sender: Any) {
        if DTourPackageModel.packageArray.count == 0 {
            self.view.makeToast(message: "Tours list not available. Please try again")
            return
        }
        if sortByName {
            // sort by A to Z...
            sortByName = false
            sort_number = 5
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_nameFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByName = true
            sort_number = 4
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_nameFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DToursFilterModel.sort_number = sort_number
        self.reloadInfo()
    }
    
    @IBAction func ratingFilterAction(_ sender: Any) {
        if DTourPackageModel.packageArray.count == 0 {
            self.view.makeToast(message: "Tours list not available. Please try again")
            return
        }
        if sortByRating {
            // sort by A to Z...
            sortByRating = false
            sort_number = 3
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_ratingFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByRating = true
            sort_number = 2
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_ratingFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DToursFilterModel.sort_number = sort_number
        self.reloadInfo()
    }
    @IBAction func priceFilterAction(_ sender: Any) {
        if DTourPackageModel.packageArray.count == 0 {
            self.view.makeToast(message: "Tours list not available. Please try again")
            return
        }
        if sortByPrice {
            // sort by A to Z...
            sortByPrice = false
            sort_number = 1
            
            UIView.animate(withDuration: 0.3) { () -> Void in
              self.img_priceFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        } else  {
            // sort by Z to A...
            sortByPrice = true
            sort_number = 0
            
            UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
              self.img_priceFilter.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
            }, completion: nil)
        }
        DToursFilterModel.sort_number = sort_number
        self.reloadInfo()
    }
}
//MARK: - UITableViewDelegates and DataSource
extension SearchedToursListVC: UITableViewDelegate, UITableViewDataSource, viewDetailButtonDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return packageArray.count//packageArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchToursCell") as? SearchToursCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchToursCell", bundle: nil), forCellReuseIdentifier: "SearchToursCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "SearchToursCell") as? SearchToursCell
        }
        cell?.imageView?.clipsToBounds = true
        cell?.setInfo(model: packageArray[indexPath.row])
        cell?.viewDetailDelegate = self
        return cell!
    }
    func selectCell(selected: String) {
//        if let id  = selected {
            let vc = TOURS_STORYBOARD.instantiateViewController(withIdentifier: "NewToursDetailVC") as! ToursDetailVC
            vc.packageID =  selected //packageArray[indexPath.row].packageID

            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
//MARK: - Api Call
extension SearchedToursListVC {
    func getSearchedTourse() -> Void {
        CommonLoader.shared.startLoader(in: view)
        let paramString: [String: String] = ["package_search": VKAPIs.getJSONString(object: packageSearchParam)]
        
            
            VKAPIs.shared.getRequestFormdata(params: paramString, file: Tours_search_mobile, httpMethod: .POST) { (resultObj, success, error) in
                if success == true {
                    print("Tours search success: \(String(describing: resultObj))")
                    if let result = resultObj as? [String: Any] {
                        if let r = result["data"] as? [[String: Any]] { //packages
                            DTourPackageModel.createToursModel(result: r )
                            self.reloadInfo()

//                            self.packageArray = PackageModel.packageArray

                        }
                      
                    } else {

                        print("Tours List formate : \(String(describing: resultObj))")
                    }
                } else {
                    self.view.makeToast(message: error?.localizedDescription ?? "")

                print("Tours list error : \(String(describing: error?.localizedDescription))")
            }
                CommonLoader.shared.stopLoader()
        }
    }
}
