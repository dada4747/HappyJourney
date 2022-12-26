//
//  TMXExtensions.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import Foundation
import UIKit

extension DateFormatter {
    
    // convert date string to date...
    class func getDate(formate: String, date: String) -> Date {
        
        // date formatter...
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        
        // set date formate and send date...
        formatter.dateFormat = formate
        return formatter.date(from: date) ?? Date()
    }
    
    // convert date to date string...
    class func getDateString(formate: String, date: Date) -> String {
        
        // date formatter...
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "en_US")
        
        // set date formate and send date...
        formatter.dateFormat = formate
        return formatter.string(from: date)
    }
    
    class func getDaysBetweenTwoDates(startDate: Date, endDate: Date) -> Int {
        
        let timeInterval = endDate.timeIntervalSince(startDate)
        let timeInt = Int(timeInterval / (60 * 60 * 24 ))
        
        return timeInt
    }
    
    class func getHoursMinsBetweenDates(fromDate: Date, toDate: Date) -> String {
        
        let difference = Calendar.current.dateComponents([.hour, .minute], from: fromDate, to: toDate)
        let formattedString = String(format: "%02ld H %02ld M", difference.hour!, difference.minute!)
        
        print(formattedString)
        return formattedString
    }
}

extension UIView {
    
    func viewShadow() {
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addGradientToView()  {
        
        //gradient layer
        let gradientLayer = CAGradientLayer()
        
        //define colors
        gradientLayer.colors = [UIColor.init(red: 15.0/255.0, green: 12.0/255.0, blue: 41.0/255.0, alpha: 1.0).cgColor, UIColor.init(red: 48.0/255.0, green: 43.0/255.0, blue: 99.0/255.0, alpha: 1.0).cgColor]
        
        //define locations of colors as NSNumbers in range from 0.0 to 1.0
        //if locations not provided the colors will spread evenly
        gradientLayer.locations = [0.0, 0.6]
        
        //define frame
        gradientLayer.frame = self.layer.bounds
        
        //insert the gradient layer to the view layer
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        
        // getting attributed string...
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func isValidIntergerSet() -> Bool {
        
        // filtering existed string as interger set or not...
        let cs = CharacterSet.init(charactersIn: "0123456789").inverted
        let filtered: String = self.components(separatedBy: cs).joined(separator: "")
        if self == filtered {
            return true
        }
        return false
    }
   
    func isValidInput() -> Bool {
        
        let nameRegex = "^[A-Za-z\\s]{3,18}$"//"\\A\\w{3,18}\\z"
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return validateName.evaluate(with: self)
        
        //return Input.range(of: "\\A\\w{3,18}\\z", options: .regularExpression) != nil
    }
    func isValidEmailAddress() -> Bool {
        
        // create a regex string...
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        // create predicate with format matching your regex string...
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return predicateTest.evaluate(with: self)
    }
    func isValidPhone() -> Bool {
        
        let phoneRegex = "[0-9]{5,16}$" //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidString() -> Bool {
        
        // string validation without space...
        let whitespace = CharacterSet.whitespacesAndNewlines
        if self.count == 0 || self.trimmingCharacters(in: whitespace).count == 0 {
            return false
        }
        return true
    }
    
    
    func getUserId() -> String {
        
        let profile_dict: [String: Any] = DEFAULTS.value(forKey: TMXUser_Profile) as? [String: Any] ?? [:]
        let userID = profile_dict["user_id"] as? String ?? ""
        return userID
    }
    func getUUID() -> String {
        let profile_dict: [String: Any] = DEFAULTS.value(forKey: TMXUser_Profile) as? [String: Any] ?? [:]
        let uuID = profile_dict["auth_user_pointer"] as? String ?? ""
        return uuID
    }
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}

extension UIImageView {
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
            
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        let cgrect = CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight)
        image.draw(in: cgrect, blendMode: CGBlendMode.copy, alpha: 1.0)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension NSObject {
    
    public func debug_print<T>(Item: T) {
        #if DEBUG
        print(Item)
        #endif
    }
}




extension UIColor {
    static var primInteraciaPink =  UIColor(hexString: "#CC3270") //pink
    static var secInteraciaBlue  = UIColor(hexString: "#494AFF") //blue
    static var placeholder  = UIColor(hexString: "#dddddd") //gray
}


extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
