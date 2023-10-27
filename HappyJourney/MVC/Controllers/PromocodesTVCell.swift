//
//  PromocodesTVCell.swift
//  Alkhaleej Tours
//
//  Created by venugopal kollu on 17/05/21.
//

import UIKit

class PromocodesTVCell: UITableViewCell {
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_minimumValuePrice: UILabel!
    @IBOutlet weak var lbl_code: UILabel!
    @IBOutlet weak var lbl_savedPrice: UILabel!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var btn_apply: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func displayData(obj: [String: Any]){
        lbl_description.text = obj["description"] as? String
        lbl_code.text = obj["promo_code"] as? String
        if let min = obj["minimum_amount"] as? String{
            lbl_minimumValuePrice.text = "valid on order with booking " + min + " or more"
        }
        if let saved = obj["value"] as? String{
            lbl_savedPrice.text = "You will save " + saved + " with this code"
        }
        
        //self.loadImages(imagePath: obj["promo_code_image"] as? String ?? "")
//        if let url = URL(string: obj["promo_code_image"] as? String ?? ""){
//            self.downloadImage(from: url)
//        }

    }
    
    func loadImages(imagePath: String){
        if let imageURL = URL(string: imagePath){
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.img_logo.image = image
                }
            }
        }
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.img_logo.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension UIImageView{
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() {
                    //self.img_logo.image = image
                }
            }.resume()
        }
}
