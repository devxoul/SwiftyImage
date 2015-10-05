//
//  SwiftyImage.swift
//  SwiftyImage
//
//  Created by 전수열 on 7/14/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

public enum BorderAlignment {
    case Inside
    case Center
    case Outside
}


// MARK: - Image Context

public extension UIImage {

    public typealias ContextBlock = CGContextRef -> Void

    public class func with(width width: CGFloat, height: CGFloat, block: ContextBlock) -> UIImage {
        return self.with(size: CGSize(width: width, height: height), block: block)
    }

    public class func with(size size: CGSize,
                           opaque: Bool = false,
                           scale: CGFloat = 0,
                           block: ContextBlock) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()!
        block(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    public func with(contextBlock: (CGContextRef) -> Void) -> UIImage! {
        return UIImage.with(size: self.size, opaque: false, scale: self.scale) { context in
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            self.drawInRect(rect)
            contextBlock(context)
        }
    }

}


// MARK: - Image Operator

public func + (lhs: UIImage, rhs: UIImage) -> UIImage {
    return lhs.with { context in
        let lhsRect = CGRect(x: 0, y: 0, width: lhs.size.width, height: lhs.size.height)
        var rhsRect = CGRect(x: 0, y: 0, width: rhs.size.width, height: rhs.size.height)

        if CGRectContainsRect(lhsRect, rhsRect) {
            rhsRect.origin.x = (lhsRect.size.width - rhsRect.size.width) / 2
            rhsRect.origin.y = (lhsRect.size.height - rhsRect.size.height) / 2
        } else {
            rhsRect.size = lhsRect.size
        }

        lhs.drawInRect(lhsRect)
        rhs.drawInRect(rhsRect)
    }
}


//MARK: - Image Drawing

public extension UIImage {

    public class func size(width width: CGFloat, height: CGFloat) -> ImageDrawer {
        return self.size(CGSize(width: width, height: height))
    }

    public class func size(size: CGSize) -> ImageDrawer {
        let drawer = ImageDrawer()
        drawer.size = .Fixed(size: size)
        return drawer
    }

    public class func resizable() -> ImageDrawer {
        let drawer = ImageDrawer()
        drawer.size = .Resizable
        return drawer
    }
}

public class ImageDrawer {

    public enum Size {
        case Fixed(size: CGSize)
        case Resizable
    }

    private var color = UIColor.clearColor()
    private var borderColor = UIColor.blackColor()
    private var borderWidth: CGFloat = 0
    private var borderAlignment: BorderAlignment = .Inside
    private var cornerRadiusTopLeft: CGFloat = 0
    private var cornerRadiusTopRight: CGFloat = 0
    private var cornerRadiusBottomLeft: CGFloat = 0
    private var cornerRadiusBottomRight: CGFloat = 0
    private var size: Size = .Resizable


    // MARK: Cache

    private static var cachedImages = [String: UIImage]()
    private var cacheKey: String {
        var attributes = [String: String]()
        attributes["color"] = String(self.color.hashValue)
        attributes["borderColor"] = String(self.borderColor.hashValue)
        attributes["borderWidth"] = String(self.borderWidth.hashValue)
        attributes["borderAlignment"] = String(self.borderAlignment.hashValue)
        attributes["cornerRadiusTopLeft"] = String(self.cornerRadiusTopLeft.hashValue)
        attributes["cornerRadiusTopRight"] = String(self.cornerRadiusTopRight.hashValue)
        attributes["cornerRadiusBottomLeft"] = String(self.cornerRadiusBottomLeft.hashValue)
        attributes["cornerRadiusBottomRight"] = String(self.cornerRadiusBottomRight.hashValue)

        switch self.size {
        case .Fixed(let size):
            attributes["size"] = "Fixed(\(size.width), \(size.height))"
        case .Resizable:
            attributes["size"] = "Resizable"
        }

        var serializedAttributes = [String]()
        for key in attributes.keys.sort() {
            if let value = attributes[key] {
                serializedAttributes.append("\(key):\(value)")
            }
        }

        let cacheKey = serializedAttributes.joinWithSeparator("|")
        return cacheKey
    }


    // MARK: Fill

    public func color(color: UIColor) -> Self {
        self.color = color
        return self
    }


    // MARK: Border

    public func border(color color: UIColor) -> Self {
        self.borderColor = color
        return self
    }

    public func border(width width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }

    public func border(alignment alignment: BorderAlignment) -> Self {
        self.borderAlignment = alignment
        return self
    }

    public func corner(radius radius: CGFloat) -> Self {
        self.corner(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius)
        return self
    }

    public func corner(topLeft topLeft: CGFloat) -> Self {
        self.cornerRadiusTopLeft = topLeft
        return self
    }

    public func corner(topRight topRight: CGFloat) -> Self {
        self.cornerRadiusTopRight = topRight
        return self
    }

    public func corner(bottomLeft bottomLeft: CGFloat) -> Self {
        self.cornerRadiusBottomLeft = bottomLeft
        return self
    }

    public func corner(bottomRight bottomRight: CGFloat) -> Self {
        self.cornerRadiusBottomRight = bottomRight
        return self
    }

    public func corner(topLeft topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) -> Self {
        self.corner(topLeft: topLeft)
        self.corner(topRight: topRight)
        self.corner(bottomLeft: bottomLeft)
        self.corner(bottomRight: bottomRight)
        return self
    }


    // MARK: Image

    public func image() -> UIImage {
        switch self.size {
        case .Fixed(let size):
            return self.imageWithSize(size)

        case .Resizable:
            self.borderAlignment = .Inside

            let cornerRadius = max(
                self.cornerRadiusTopLeft, self.cornerRadiusTopRight,
                self.cornerRadiusBottomLeft, self.cornerRadiusBottomRight
            )
            let capSize = ceil(max(cornerRadius, self.borderWidth))
            let imageSize = capSize * 2 + 1

            let image = self.imageWithSize(CGSize(width: imageSize, height: imageSize))
            let capInsets = UIEdgeInsets(top: capSize, left: capSize, bottom: capSize, right: capSize)
            return image.resizableImageWithCapInsets(capInsets)
        }
    }

    private func imageWithSize(size: CGSize, useCache: Bool = true) -> UIImage {
        if let cachedImage = self.dynamicType.cachedImages[self.cacheKey] where useCache {
            return cachedImage
        }

        var imageSize = CGSize(width: size.width, height: size.height)
        var rect = CGRect()
        rect.size = imageSize

        switch self.borderAlignment {
        case .Inside:
            rect.origin.x += self.borderWidth / 2
            rect.origin.y += self.borderWidth / 2
            rect.size.width -= self.borderWidth
            rect.size.height -= self.borderWidth

        case .Center:
            rect.origin.x += self.borderWidth / 2
            rect.origin.y += self.borderWidth / 2
            imageSize.width += self.borderWidth
            imageSize.height += self.borderWidth

        case .Outside:
            rect.origin.x += self.borderWidth / 2
            rect.origin.y += self.borderWidth / 2
            rect.size.width += self.borderWidth
            rect.size.height += self.borderWidth
            imageSize.width += self.borderWidth * 2
            imageSize.height += self.borderWidth * 2
        }

        let cornerRadius = max(
            self.cornerRadiusTopLeft, self.cornerRadiusTopRight,
            self.cornerRadiusBottomLeft, self.cornerRadiusBottomRight
        )

        let image = UIImage.with(size: imageSize) { context in
            self.color.setFill()
            self.borderColor.setStroke()

            let path: UIBezierPath

            if self.cornerRadiusTopLeft == self.cornerRadiusTopRight &&
               self.cornerRadiusTopLeft == self.cornerRadiusBottomLeft &&
               self.cornerRadiusTopLeft == self.cornerRadiusBottomRight &&
               self.cornerRadiusTopLeft > 0 {
                path = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadiusTopLeft)
            } else if cornerRadius > 0 {
                let startAngle = CGFloat(M_PI)

                let topLeftCenter = CGPoint(
                    x: self.cornerRadiusTopLeft + self.borderWidth / 2,
                    y: self.cornerRadiusTopLeft + self.borderWidth / 2
                )
                let topRightCenter = CGPoint(
                    x: imageSize.width - self.cornerRadiusTopRight - self.borderWidth / 2,
                    y: self.cornerRadiusTopRight + self.borderWidth / 2
                )
                let bottomRightCenter = CGPoint(
                    x: imageSize.width - self.cornerRadiusBottomRight - self.borderWidth / 2,
                    y: imageSize.height - self.cornerRadiusBottomRight - self.borderWidth / 2
                )
                let bottomLeftCenter = CGPoint(
                    x: self.cornerRadiusBottomLeft + self.borderWidth / 2,
                    y: imageSize.height - self.cornerRadiusBottomLeft - self.borderWidth / 2
                )

                let mutablePath = UIBezierPath()

                // top left
                if self.cornerRadiusTopLeft > 0 {
                    mutablePath.addArcWithCenter(topLeftCenter,
                        radius: self.cornerRadiusTopLeft,
                        startAngle: startAngle,
                        endAngle: 1.5 * startAngle,
                        clockwise: true
                    )
                } else {
                    mutablePath.moveToPoint(topLeftCenter)
                }

                // top right
                if self.cornerRadiusTopRight > 0 {
                    mutablePath.addArcWithCenter(topRightCenter,
                        radius: self.cornerRadiusTopRight,
                        startAngle: 1.5 * startAngle,
                        endAngle: 2 * startAngle,
                        clockwise: true
                    )
                } else {
                    mutablePath.addLineToPoint(topRightCenter)
                }

                // bottom right
                if self.cornerRadiusBottomRight > 0 {
                    mutablePath.addArcWithCenter(bottomRightCenter,
                        radius: self.cornerRadiusBottomRight,
                        startAngle: 2 * startAngle,
                        endAngle: 2.5 * startAngle,
                        clockwise: true
                    )
                } else {
                    mutablePath.addLineToPoint(bottomRightCenter)
                }

                // bottom left
                if self.cornerRadiusBottomLeft > 0 {
                    mutablePath.addArcWithCenter(bottomLeftCenter,
                        radius: self.cornerRadiusBottomLeft,
                        startAngle: 2.5 * startAngle,
                        endAngle: 3 * startAngle,
                        clockwise: true
                    )
                } else {
                    mutablePath.addLineToPoint(bottomLeftCenter)
                }

                if self.cornerRadiusTopLeft > 0 {
                    mutablePath.addLineToPoint(CGPoint(x: self.borderWidth / 2, y: topLeftCenter.y))
                } else {
                    mutablePath.addLineToPoint(topLeftCenter)
                }

                path = mutablePath
            } else {
                path = UIBezierPath(rect: rect)
            }
            path.lineWidth = self.borderWidth
            path.fill()
            path.stroke()
        }

        if useCache {
            self.dynamicType.cachedImages[self.cacheKey] = image
        }

        return image
    }
}
