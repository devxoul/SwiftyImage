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


// MARK: - UIImage Extension

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


//MARK: - ImageDrawer

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

    private func imageWithSize(size: CGSize) -> UIImage {
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

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()

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
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
