//
//  DetailWebViewCell.swift
//  ExtactTravel
//
//  Created by Admin on 16/08/22.
//

import UIKit
import WebKit

class DetailWebViewCell: UITableViewCell, WKNavigationDelegate {
    //MARK: - IBOutlet
//    @IBOutlet weak var view_contentView: UIView!
    @IBOutlet weak var wbView_Details: WKWebView!
    @IBOutlet weak var lbl_Day: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var wb_height: NSLayoutConstraint!
    //MARK: - Variables
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
         wbView_Details.scrollView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
