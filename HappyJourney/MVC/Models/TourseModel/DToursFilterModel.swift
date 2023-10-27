//
//  DToursFilter.swift
//  ExtactTravel
//
//  Created by Admin on 22/09/22.
//

import Foundation
struct DToursFilterModel {
    
    static var sort_number = 0
    static var currency_code = "USD"
    
    static func clearAllFilter(){
        sort_number = 0
    }
    static func getPackagesAndPrice_fromResponce(){
        var toursPrice_array:[Float] = []
        
        for model in DTourPackageModel.packageArray {
            currency_code = "USD"
            toursPrice_array.append(model.price)
        }
        self.clearAllFilter()
    }
    static func applyAll_filterAndSorting(_tranfers: [TourPackageItem]) -> [TourPackageItem]{
        
        let transfer_sort = sorting_tours(_packages: _tranfers)
        return transfer_sort
    }
}

extension DToursFilterModel {
    
    // MARK:- Sorting
    static func sorting_tours(_packages: [TourPackageItem]) -> [TourPackageItem] {
        
        var packages_array = _packages
     
        // Price sort...
        if DToursFilterModel.sort_number == 0 {
            
            let results = packages_array.sorted(by: { $0.price < $1.price })
            packages_array = results
        }
        else if DToursFilterModel.sort_number == 1 {
            
            let results_1 = packages_array.sorted(by: { $0.price > $1.price })
            packages_array = results_1
        }
        // Star rating sort...
        else if DToursFilterModel.sort_number == 2 {
            
            let results = packages_array.sorted(by: { $0.rating! < $1.rating! })
            packages_array = results
        }
        else if DToursFilterModel.sort_number == 3 {
            
            let results = packages_array.sorted(by: { $0.rating! > $1.rating! })
            packages_array = results
        }
        // name sort...
        else if DToursFilterModel.sort_number == 4 {
            
            let results = packages_array.sorted(by: { $0.packageName.replacingOccurrences(of: " ", with: "").localizedCaseInsensitiveCompare($1.packageName) == ComparisonResult.orderedAscending })
            packages_array = results
        }
        else if DToursFilterModel.sort_number == 5 {
            
            let results = packages_array.sorted(by: { $0.packageName.replacingOccurrences(of: " ", with: "").localizedCaseInsensitiveCompare($1.packageName) == ComparisonResult.orderedDescending })
            packages_array = results
        }
        else {
            print("==>>There is no packages sorting")
        }
        
        return packages_array
    }
}
