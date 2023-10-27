//
//  TMXDesignables.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// UIView Corner Radiuls Designable
@IBDesignable
class CRView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}


// UIButton Corner Radius Designable
@IBDesignable
class CRButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

// UIButton Corner Radius Designable
@IBDesignable
class CRLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

// UIImageView Corner Radios Designable
@IBDesignable
class CRImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}


@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.darkGray
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {

        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset =  CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
       layer.shadowOpacity = 0.5
        layer.shadowRadius = 4

//        layer.masksToBounds = false
//        layer.shadowColor = shadowColor?.cgColor
//        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
//        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}



@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            
            let sub_layer = layer
            sub_layer.shadowOpacity = 0.5
            sub_layer.shadowColor = shadowColor.cgColor
            sub_layer.shadowOffset = CGSize.zero
            sub_layer.shadowRadius = 5.5
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffSet: CGSize = CGSize(width: 0,height: 0) {
        didSet {
            layer.shadowOffset = shadowOffSet
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableLable: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}
@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
}

private extension RoundedImageView {
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}
@IBDesignable
public class RoundedView: UIView {

    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
}

private extension RoundedView {
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}
@IBDesignable
public class GradientButton: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }

    @IBInspectable public var startColor: UIColor = UIColor(hexString: "#E28A58") { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = UIColor(hexString: "#D03373") { didSet { updateColors() } }

    // expose startPoint and endPoint to IB

    @IBInspectable public var startPoint: CGPoint {
        get { gradientLayer.startPoint }
        set { gradientLayer.startPoint = newValue }
    }

    @IBInspectable public var endPoint: CGPoint {
        get { gradientLayer.endPoint }
        set { gradientLayer.endPoint = newValue }
    }

    // while we're at it, let's expose a few more layer properties so we can easily adjust them in IB

    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }

    // init methods

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
}

private extension GradientButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
@IBDesignable
public class GradientView: UIView {
    @IBInspectable var startColor:   UIColor = UIColor(hexString: "#E28A58") { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor(hexString: "#D03373") { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.0 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1.0 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  true { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    @IBInspectable var isShadow:    Bool =  false { didSet { updateGradShadow() }}

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.darkGray
    @IBInspectable var shadowOpacity: Float = 0.4
    @IBInspectable var cornerRadius: CGFloat = 0

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 1) : .init(x: 0, y: 1)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    func updateGradShadow(){
        if isShadow {
            let shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius)
            layer.masksToBounds = false
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset =  CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = cornerRadius
            layer.cornerRadius = cornerRadius
            layer.shadowPath = shadowPath.cgPath
            layer.masksToBounds = false
            
        }else{
            layer.cornerRadius = cornerRadius
        }
    }
//    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        updatePoints()
//        updateLocations()
//        updateColors()
//    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updatePoints()
        updateLocations()
        updateColors()
        updateGradShadow()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updatePoints()
        updateLocations()

        updateColors()
        updateGradShadow()
    }

}


@IBDesignable
public class GradientHeaderView: UIView {
    @IBInspectable var startColor:   UIColor = UIColor(hexString: "#E28A58") { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor(hexString: "#D03373") { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.0 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1.0 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  true { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 35  { didSet { updateCorners() } }

    
    
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 1) : .init(x: 0, y: 1)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
        
    }
//    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        updatePoints()
//        updateLocations()
//        updateColors()
//    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updatePoints()
        updateLocations()
        updateColors()
        updateCorners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updatePoints()
        updateLocations()

        updateColors()
        updateCorners()
    }

}
