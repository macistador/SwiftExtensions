# SwiftExtensions

Personnal set of useful Swift extensions (iOS)

## Extended

- FloatingPoint 
    - degrees / radiant conversion
- UIImage
    - rotate(radians: CGFloat) -> UIImage
    - imageOverlay(with color: UIColor) -> UIImage?
    - tint(with color: UIColor) -> UIImage?
    - withGrayscale: UIImage
- UIImageView
    - convenience init(clone: UIImageView) // duplicates the imageView
    - addOverlay(with color: UIColor) // tint color overlay
- UIView
    - constraintAnchors(to view: UIView, with offset: Edges)
    - fadeView(style: UIViewFadeStyle = .bottom) // add a fading layer on the view
- CALayer
    - setCircleBorder(with color: UIColor)
- UIScrollView
    - resetScroll()
- Edges
    - new "Edges" struct
- UIToolbar
    - oneButtonBar(with selector: Selector, target: Any, title: String, size: CGSize) -> UIToolbar
- CGPoint
    - point(withOffset offset: CGPoint) -> CGPoint
    - "+" operator
- CGSize
    - "+" operator
- Array
    - firstIndex(ofKind kind: Element) -> Int
    - index(for test: ((Element) -> Bool)) -> Int?
- String: 
    - "a string".localized
- And others

## Installation

  pod 'SwiftExtensions', :git => 'https://github.com/macistador/SwiftExtensions.git'


(not published on the Cocoapods public repo) 
