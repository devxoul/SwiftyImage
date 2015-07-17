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

    public typealias ContextBlock = (CGContextRef) -> Void

    public class func with(#width: CGFloat, height: CGFloat, block: ContextBlock) -> UIImage {
        return self.with(size: CGSize(width: width, height: height), block: block)
    }

    public class func with(#size: CGSize, opaque: Bool = false, scale: CGFloat = 0, block: ContextBlock) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        block(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    public func with(contextBlock: (CGContextRef) -> Void) -> UIImage! {
        return UIImage.with(size: self.size, opaque: false, scale: self.scale) { context in
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
            CGContextDrawImage(context, rect, self.CGImage)
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

        CGContextDrawImage(context, lhsRect, lhs.CGImage)
        CGContextDrawImage(context, rhsRect, rhs.CGImage)
    }
}


//MARK: - Image Drawing

public extension UIImage {

    public class func size(#width: CGFloat, height: CGFloat) -> ImageDrawer {
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
    private var cornerRadius: CGFloat = 0
    private var size: Size = .Resizable


    // MARK: Cache

    private static var cachedImages = [String: UIImage]()
    private var cacheKey: String {
        var attributes = [
            "color": toString(self.color.hashValue),
            "borderColor": toString(self.borderColor.hashValue),
            "borderWidth": toString(self.borderWidth.hashValue),
            "borderAlignment": toString(self.borderAlignment.hashValue),
            "cornerRadius": toString(self.cornerRadius.hashValue),
        ]

        switch self.size {
        case .Fixed(let size):
            attributes["size"] = "Fixed(\(size.width), \(size.height))"
        case .Resizable:
            attributes["size"] = "Resizable"
        }

        var serializedAttributes = [String]()
        for key in sorted(attributes.keys) {
            if let value = attributes[key] {
                serializedAttributes.append("\(key):\(value)")
            }
        }

        let cacheKey = "|".join(serializedAttributes)
        return cacheKey
    }


    // MARK: Fill

    public func color(color: UIColor) -> Self {
        self.color = color
        return self
    }


    // MARK: Border

    public func border(#color: UIColor) -> Self {
        self.borderColor = color
        return self
    }

    public func border(#width: CGFloat) -> Self {
        self.borderWidth = width
        return self
    }

    public func border(#alignment: BorderAlignment) -> Self {
        self.borderAlignment = alignment
        return self
    }

    public func corner(#radius: CGFloat) -> Self {
        self.cornerRadius = radius
        return self
    }


    // MARK: Image

    public func image() -> UIImage {
        switch self.size {
        case .Fixed(let size):
            return self.imageWithSize(size)

        case .Resizable:
            self.borderAlignment = .Inside

            let imageSize: CGFloat
            let capSize: CGFloat

            if self.cornerRadius > 0 {
                imageSize = self.cornerRadius * 2
                capSize = self.cornerRadius
            } else {
                imageSize = self.borderWidth * 2 + 1
                capSize = self.borderWidth
            }

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

        var image = UIImage.with(size: imageSize) { context in
            self.color.setFill()
            self.borderColor.setStroke()

            let path: UIBezierPath
            if self.cornerRadius > 0 {
                path = UIBezierPath(roundedRect: rect, cornerRadius: self.cornerRadius)
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
