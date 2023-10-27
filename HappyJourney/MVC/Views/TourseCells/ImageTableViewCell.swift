//
//  ImageTableViewCell.swift
//  ExtactTravel
//
//  Created by Admin on 04/10/22.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var img_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
