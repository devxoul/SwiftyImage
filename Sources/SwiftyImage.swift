//
//  SwiftyImage.swift
//  SwiftyImage
//
//  Created by 전수열 on 7/14/15.
//  Copyright (c) 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

public enum BorderAlignment {
  case inside
  case center
  case outside
}


// MARK: - Image Context

public extension UIImage {

  public typealias ContextBlock = (CGContext) -> Void

  public class func with(width: CGFloat, height: CGFloat, block: ContextBlock) -> UIImage {
    return self.with(size: CGSize(width: width, height: height), block: block)
  }

  public class func with(size: CGSize, opaque: Bool = false, scale: CGFloat = 0, block: ContextBlock) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext()!
    block(context)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
  }

  public func with(_ contextBlock: (CGContext) -> Void) -> UIImage! {
    return UIImage.with(size: self.size, opaque: false, scale: self.scale) { context in
      let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
      self.draw(in: rect)
      contextBlock(context)
    }
  }

}


// MARK: - Image Operator

public func + (lhs: UIImage, rhs: UIImage) -> UIImage {
  return lhs.with { context in
    let lhsRect = CGRect(x: 0, y: 0, width: lhs.size.width, height: lhs.size.height)
    var rhsRect = CGRect(x: 0, y: 0, width: rhs.size.width, height: rhs.size.height)

    if lhsRect.contains(rhsRect) {
      rhsRect.origin.x = (lhsRect.size.width - rhsRect.size.width) / 2
      rhsRect.origin.y = (lhsRect.size.height - rhsRect.size.height) / 2
    } else {
      rhsRect.size = lhsRect.size
    }

    lhs.draw(in: lhsRect)
    rhs.draw(in: rhsRect)
  }
}


//MARK: - Image Drawing

public extension UIImage {

  public class func size(width: CGFloat, height: CGFloat) -> ImageDrawer {
    return self.size(CGSize(width: width, height: height))
  }

  public class func size(_ size: CGSize) -> ImageDrawer {
    let drawer = ImageDrawer()
    drawer.size = .fixed(size)
    return drawer
  }

  public class func resizable() -> ImageDrawer {
    let drawer = ImageDrawer()
    drawer.size = .resizable
    return drawer
  }
}

open class ImageDrawer {

  public enum Size {
    case fixed(CGSize)
    case resizable
  }

  fileprivate var color = UIColor.clear
  fileprivate var borderColor = UIColor.black
  fileprivate var borderWidth: CGFloat = 0
  fileprivate var borderAlignment: BorderAlignment = .inside
  fileprivate var cornerRadiusTopLeft: CGFloat = 0
  fileprivate var cornerRadiusTopRight: CGFloat = 0
  fileprivate var cornerRadiusBottomLeft: CGFloat = 0
  fileprivate var cornerRadiusBottomRight: CGFloat = 0
  fileprivate var size: Size = .resizable


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
    case .fixed(let size):
      attributes["size"] = "Fixed(\(size.width), \(size.height))"
    case .resizable:
      attributes["size"] = "Resizable"
    }

    var serializedAttributes = [String]()
    for key in attributes.keys.sorted() {
      if let value = attributes[key] {
        serializedAttributes.append("\(key):\(value)")
      }
    }

    let cacheKey = serializedAttributes.joined(separator: "|")
    return cacheKey
  }


  // MARK: Fill

  open func color(_ color: UIColor) -> Self {
    self.color = color
    return self
  }


  // MARK: Border

  open func border(color: UIColor) -> Self {
    self.borderColor = color
    return self
  }

  open func border(width: CGFloat) -> Self {
    self.borderWidth = width
    return self
  }

  open func border(alignment: BorderAlignment) -> Self {
    self.borderAlignment = alignment
    return self
  }

  open func corner(radius: CGFloat) -> Self {
    return self.corner(topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius)
  }

  open func corner(topLeft: CGFloat) -> Self {
    self.cornerRadiusTopLeft = topLeft
    return self
  }

  open func corner(topRight: CGFloat) -> Self {
    self.cornerRadiusTopRight = topRight
    return self
  }

  open func corner(bottomLeft: CGFloat) -> Self {
    self.cornerRadiusBottomLeft = bottomLeft
    return self
  }

  open func corner(bottomRight: CGFloat) -> Self {
    self.cornerRadiusBottomRight = bottomRight
    return self
  }

  open func corner(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) -> Self {
    return self
      .corner(topLeft: topLeft)
      .corner(topRight: topRight)
      .corner(bottomLeft: bottomLeft)
      .corner(bottomRight: bottomRight)
  }


  // MARK: Image

  open var image: UIImage {
    switch self.size {
    case .fixed(let size):
      return self.imageWithSize(size)

    case .resizable:
      self.borderAlignment = .inside

      let cornerRadius = max(
        self.cornerRadiusTopLeft, self.cornerRadiusTopRight,
        self.cornerRadiusBottomLeft, self.cornerRadiusBottomRight
      )
      let capSize = ceil(max(cornerRadius, self.borderWidth))
      let imageSize = capSize * 2 + 1

      let image = self.imageWithSize(CGSize(width: imageSize, height: imageSize))
      let capInsets = UIEdgeInsets(top: capSize, left: capSize, bottom: capSize, right: capSize)
      return image.resizableImage(withCapInsets: capInsets)
    }
  }

  private func imageWithSize(_ size: CGSize, useCache: Bool = true) -> UIImage {
    if let cachedImage = type(of: self).cachedImages[self.cacheKey], useCache {
      return cachedImage
    }

    var imageSize = CGSize(width: size.width, height: size.height)
    var rect = CGRect()
    rect.size = imageSize

    switch self.borderAlignment {
    case .inside:
      rect.origin.x += self.borderWidth / 2
      rect.origin.y += self.borderWidth / 2
      rect.size.width -= self.borderWidth
      rect.size.height -= self.borderWidth

    case .center:
      rect.origin.x += self.borderWidth / 2
      rect.origin.y += self.borderWidth / 2
      imageSize.width += self.borderWidth
      imageSize.height += self.borderWidth

    case .outside:
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
          mutablePath.addArc(
            withCenter: topLeftCenter,
            radius: self.cornerRadiusTopLeft,
            startAngle: startAngle,
            endAngle: 1.5 * startAngle,
            clockwise: true
          )
        } else {
          mutablePath.move(to: topLeftCenter)
        }

        // top right
        if self.cornerRadiusTopRight > 0 {
          mutablePath.addArc(
            withCenter: topRightCenter,
            radius: self.cornerRadiusTopRight,
            startAngle: 1.5 * startAngle,
            endAngle: 2 * startAngle,
            clockwise: true
          )
        } else {
          mutablePath.addLine(to: topRightCenter)
        }

        // bottom right
        if self.cornerRadiusBottomRight > 0 {
          mutablePath.addArc(
            withCenter: bottomRightCenter,
            radius: self.cornerRadiusBottomRight,
            startAngle: 2 * startAngle,
            endAngle: 2.5 * startAngle,
            clockwise: true
          )
        } else {
          mutablePath.addLine(to: bottomRightCenter)
        }

        // bottom left
        if self.cornerRadiusBottomLeft > 0 {
          mutablePath.addArc(
            withCenter: bottomLeftCenter,
            radius: self.cornerRadiusBottomLeft,
            startAngle: 2.5 * startAngle,
            endAngle: 3 * startAngle,
            clockwise: true
          )
        } else {
          mutablePath.addLine(to: bottomLeftCenter)
        }

        if self.cornerRadiusTopLeft > 0 {
          mutablePath.addLine(to: CGPoint(x: self.borderWidth / 2, y: topLeftCenter.y))
        } else {
          mutablePath.addLine(to: topLeftCenter)
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
      type(of: self).cachedImages[self.cacheKey] = image
    }

    return image
  }
}


// MARK: - Color overlay

public extension UIImage {

  public func with(color: UIColor) -> UIImage {
    return UIImage.with(size: self.size) { context in
      context.translateBy(x: 0, y: self.size.height)
      context.scaleBy(x: 1, y: -1)
      context.setBlendMode(.normal)
      let rect = CGRect(origin: .zero, size: self.size)
      context.clip(to: rect, mask: self.cgImage!)
      color.setFill()
      context.fill(rect)
    }
  }

}
