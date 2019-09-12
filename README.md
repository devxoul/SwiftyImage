SwiftyImage
===========

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![CocoaPods](http://img.shields.io/cocoapods/v/SwiftyImage.svg?style=flat)](https://cocoapods.org/pods/SwiftyImage)
[![CI](https://github.com/devxoul/SwiftyImage/workflows/CI/badge.svg)](http://github.com/devxoul/SwiftyImage/actions)

The most sexy way to use images in Swift.


Features
--------

* [x] [Create images with method chaining](#getting-started)
* [x] [Gradient fill and stroke](#methods-available)
* [x] [Create and manipulate images with CGContext](#play-with-cgcontext)
* [x] [Combine images with `+` operator](#image-operator)
* [x] iOS support
* [ ] macOS support


At a Glance
-----------

##### Creating Images

```swift
UIImage.size(width: 100, height: 100)
  .color(.white)
  .border(color: .red)
  .border(width: 10)
  .corner(radius: 20)
  .image
```

![sample1](https://cloud.githubusercontent.com/assets/931655/8675848/106e59ea-2a81-11e5-8e4f-98cfea38bd8e.png)


```swift
UIImage.resizable()
  .color(.white)
  .border(color: .blue)
  .border(width: 5)
  .corner(radius: 10)
  .image
```

![sample2](https://cloud.githubusercontent.com/assets/931655/8675936/514b7f60-2a81-11e5-8806-26036d8e8ba5.png)

##### Creating Color Overlayed Image

```swift
let image = UIImage(named: "myArrow").with(color: UIColor.blueColor())
```


Getting Started
---------------

SwiftyImage provides a simple way to create images with method chaining.


#### Step 1. Start Chaining

Method chaining starts from `UIImage.size()` or `UIImage.resizable()`.

```swift
UIImage.size(width: CGFloat, height: CGFloat) // ...
UIImage.size(size: CGSize) // ...
UIImage.resizable() // ...
```


#### Step 2. Setting Properties

You can set fill color, border attributes, corner radius, etc.

```swift
UIImage.size(width: 100, height: 100)  // fixed size
  .color(.white)                       // fill color
  .border(color: .red)                 // border color
  .border(width: 10)                   // border width
  .corner(radius: 20)                  // corner radius
```

```swift
UIImage.resizable() // resizable image
  .color(.white)
  .border(color: .lightGray)
  .border(width: 1)
  .corner(radius: 5)
```


#### Step 3. Generating Image

Use `.image` at the end of method chaining to generate image.

```swift
imageView.image = UIImage.size(width: 100, height: 100)
  .color(.white)
  .border(color: .red)
  .border(width: 10)
  .corner(radius: 20)
  .image  // generate UIImage
```


### Methods Available

#### Starting Method Chaining

* **`.size(width: CGFloat, height: CGFloat)`**

    Starts chaining for fixed size image

* **`.size(CGSize)`**

    Starts chaining for fixed size image

* **`.resizable()`**

    Starts chaining for resizable image

#### Setting Properties

* **`.color(UIColor)`**

    Sets fill color

* **`.color(gradient: [UIColor], locations: [CGFloat], from: CGPoint, to: CGPoint)`**

    Sets gradient fill color

    *New in version 1.1.0*

* **`.border(width: CGFloat)`**

    Sets border width

* **`.border(color: UIColor)`**

    Sets border color

* **`.border(gradient: [UIColor], locations: [CGFloat], from: CGPoint, to: CGPoint)`**

    Sets gradient border color

    *New in version 1.1.0*

* **`.border(alignment: BorderAlignment)`**

    Sets border alignment. Same with Photoshop's
    
    available values: `.inside`, `.center`, `.outside`

* **`.corner(radius: CGFloat)`**

    Sets all corners radius of image

* **`.corner(topLeft: CGFloat)`**

    Sets top left corner radius of image

* **`.corner(topRight: CGFloat)`**

    Sets top right corner radius of image

* **`.corner(bottomLeft: CGFloat)`**

    Sets bottom left corner radius of image

* **`.corner(bottomRight: CGFloat)`**

    Sets bottom right corner radius of image

#### Generating Image

* **`.image`**

    Generates and returns image


Play with CGContext
-------------------

SwiftyImage also provides a simple method to create or manipulate images with CGContext.

#### Creating Images

```swift
let image = UIImage.with(size: CGSize(width: 100, height: 100)) { context in
  UIColor.lightGrayColor().setFill()
  CGContextFillEllipseInRect(context, CGRect(x: 0, y: 0, width: 100, height: 100))
}
```


#### Manipulating Images

```swift
let newImage = oldImage.with { context in
  UIColor.lightGrayColor().setFill()
  CGContextFillEllipseInRect(context, CGRect(x: 0, y: 0, width: 100, height: 100))
}
```


Image Operator
--------------

You can easily combine multiple images with `+` operator.

```swift
let backgroundImage = ...
let iconImage = ...
let combinedImage = backgroundImage + iconImage
```

![combine](https://cloud.githubusercontent.com/assets/931655/8679414/84fb8e5e-2a95-11e5-89ea-8cfbb7ec761d.png)


Installation
------------

```ruby
pod 'SwiftyImage', '~> 1.1'
```

Playground
----------

Use CocoaPods command `$ pod try SwiftyImage` to try Playground!

![playground](https://cloud.githubusercontent.com/assets/931655/8679576/611e1b9a-2a96-11e5-9f34-debb222f28c6.png)


License
-------

SwiftyImage is under MIT license. See the LICENSE file for more info.
