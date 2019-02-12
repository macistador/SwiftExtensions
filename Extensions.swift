//
//  Extensions.swift
//  Mentors
//
//  Created by Michel-Andre Chirita on 12/02/2019.
//  Copyright © 2019 croamac. All rights reserved.
//

import UIKit

// Combining a closure with its entry parameter
// Makes possible to use this closure later without using "self." anymore
// From @johnSundell
func combine<A, B>(_ value: A, with closure: @escaping (A) -> B) -> () -> B {
    return { closure(value) }
}

// Custom Colors
extension UIColor {
    struct Custom {
        static let purple = UIColor(red: 111/255, green: 21/255, blue: 208/255, alpha: 1.0)
        static let yellow = UIColor(red: 189/255, green: 208/255, blue: 31/255, alpha: 1.0)
        static let cyan = UIColor(red: 21/255, green: 208/255, blue: 158/255, alpha: 1.0)
        static let red = UIColor(red: 208/255, green: 34/255, blue: 21/255, alpha: 1.0)
        static let green = UIColor(red: 5/255, green: 127/255, blue: 0/255, alpha: 1.0)
        static let pink = UIColor(red: 208/255, green: 21/255, blue: 79/255, alpha: 1.0)
    }
}

// Degrées
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


// Rotation image
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.x, y: -origin.y,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }
        return self
    }

    func imageOverlay(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()

        color.setFill()

        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)

        context!.setBlendMode(CGBlendMode.hue)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.draw(self.cgImage!, in: rect)

        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.addRect(rect)
        context!.drawPath(using: CGPathDrawingMode.fill)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return coloredImage
    }

    func tint(with color: UIColor) -> UIImage? {
        let imageRect = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)

        let tintedImage = renderer.image { context in
            color.set()
            context.fill(imageRect)
            draw(in: imageRect, blendMode: .multiply, alpha: 0.9)
        }

        return tintedImage
    }

    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {

        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context: CGContext! = UIGraphicsGetCurrentContext()
        assert(context != nil)

        // correctly rotate image
        context.translateBy(x: 0, y: size.height);
        context.scaleBy(x: 1.0, y: -1.0);

        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

        draw(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func tint(_ tintColor: UIColor) -> UIImage {

        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(self.cgImage!, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(self.cgImage!, in: rect)
        }
    }

    // Black & White
    var withGrayscale: UIImage {
        guard let ciImage = CIImage(image: self, options: nil) else { return self }
        let paramsColor: [String: AnyObject] = [kCIInputBrightnessKey: NSNumber(value: 0.0), kCIInputContrastKey: NSNumber(value: 1.0), kCIInputSaturationKey: NSNumber(value: 0.0)]
        let grayscale = ciImage.applyingFilter("CIColorControls", parameters: paramsColor)
        guard let processedCGImage = CIContext().createCGImage(grayscale, from: grayscale.extent) else { return self }
        return UIImage(cgImage: processedCGImage, scale: scale, orientation: imageOrientation)
    }
}

extension UIImageView {
    func addOverlay(with color: UIColor) {
        //    self.image = self.image?.imageOverlay(with: color)
        self.image = self.image?.tint(color)
    }
}


// MARK: ImageView clone

extension UIImageView {
    convenience init(clone: UIImageView) {
        self.init(frame: clone.frame)
        self.image = clone.image
        self.contentMode = clone.contentMode
    }
}



// MARK: Layer fading

extension UIView {

    enum UIViewFadeStyle {
        case bottom
        case top
        case left
        case right

        case vertical
        case horizontal
    }

    func fadeView(style: UIViewFadeStyle = .bottom) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]

        switch style {
        case .bottom:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.93)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
        case .top:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.15)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.07)
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, 0.07, 0.93, 1.0]

        case .left:
            gradient.startPoint = CGPoint(x: 1, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.07, y: 0.5)
        case .right:
            gradient.startPoint = CGPoint(x: 0.93, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradient.locations = [0.0, 0.07, 0.93, 1.0]
        }

        layer.mask = gradient
    }

}


// MARK: CALayer

extension CALayer {

    func setCircleBorder(color: UIColor) {
        self.borderColor = color.cgColor
        self.borderWidth = 1.0
        self.cornerRadius = self.bounds.width / 2
    }

}


// MARK: ScrollView to top

extension UIScrollView {
    func resetScroll() {
        scrollRectToVisible(CGRect.zero, animated: false)
    }
}



// MARK : UIView

// Same size constraints <!> but the bottom for this moment need
extension UIView {
//    func constraintAnchors(to view: UIView, with offset: Edges) {
//        if let top = offset.top { link(anchor1: topAnchor, to: view.topAnchor, with: top) }
//        if let right = offset.right { link(anchor1: rightAnchor, to: view.rightAnchor, with: right) }
//        if let bottom = offset.bottom { link(anchor1: bottomAnchor, to: view.bottomAnchor, with: bottom) }
//        if let left = offset.left { link(anchor1: leftAnchor, to: view.leftAnchor, with: left) }
//    }
//
//    private func link<T: NSLayoutYAxisAnchor>(anchor1: T, to anchor2: T, with value: CGFloat) {
//        anchor1.constraint(equalTo: anchor2, constant: value).do{ $0.isActive = true }
//    }
//
//    private func link<T: NSLayoutXAxisAnchor>(anchor1: T, to anchor2: T, with value: CGFloat) {
//        anchor1.constraint(equalTo: anchor2, constant: value).do{ $0.isActive = true }
//    }
}

struct Edges {
    let top: CGFloat?
    let left: CGFloat?
    let bottom: CGFloat?
    let right: CGFloat?

    static var zero: Edges {
        return Edges(top: 0, left: 0, bottom: 0, right: 0)
    }
}


// MARK: Toolbar

extension UIToolbar {
    static func oneButtonBar(with selector: Selector, target: Any, title: String, size: CGSize) -> UIToolbar {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: title, style: .done, target: target, action: selector)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        return toolbar
    }
}


// MARK: CGPoint

extension CGPoint {

    func point(withOffset offset: CGPoint) -> CGPoint {
        return CGPoint(x: x + offset.x, y: y + offset.y)
    }

    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: CGSize

extension CGSize {
    static func +(lhs: CGSize, rhs: (x: CGFloat, y: CGFloat)) -> CGSize {
        return CGSize(
            width: lhs.width + rhs.x,
            height: lhs.height + rhs.y
        )
    }
}


// MARK: Array

extension Array {
    //  func firstIndex(ofKind kind: Element) -> Int {
    //    index
    //    let index = firstIndex(where: { (element : kind) -> Bool in
    //      if case .preTips = sectionItem  { return true }
    //    })
    //    guard let section = sectionIndex.value else { return nil }
    //  }

    //  func firstIndex<T>(for value: T) -> Int where T: Equatable, T: Element  {
    //    firstIndex(where: { (item : Element) -> Bool in
    //      return (value == item)
    //    })
    //  }

//    func index(for test: ((Element) -> Bool)) -> Int? {
//        let index = self.firstIndex(where: test)
//        return index.value
//    }
}


// String
extension String {

    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
