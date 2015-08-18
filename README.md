SwiftyImage
===========

[![CocoaPods](http://img.shields.io/cocoapods/v/SwiftyImage.svg?style=flat)](https://cocoapods.org/pods/SwiftyImage)

The most sexy way to use images in Swift.


Features
--------

* [x] [Create images with method chaining](#getting-started)
* [x] [Create and manipulate images with CGContext](#play-with-cgcontext)
* [x] [Combine images with `+` operator](#image-operator)
* [x] iOS support
* [ ] OS X support


At a Glance
-----------

```swift
UIImage.size(width: 100, height: 100)
       .color(UIColor.whiteColor())
       .border(color: UIColor.redColor())
       .border(width: 10)
       .corner(radius: 20)
       .image()
```

![sample1](https://cloud.githubusercontent.com/assets/931655/8675848/106e59ea-2a81-11e5-8e4f-98cfea38bd8e.png)


```swift
UIImage.resizable()
       .color(UIColor.whiteColor())
       .border(color: UIColor.blueColor())
       .border(width: 5)
       .corner(radius: 10)
       .image()
```

![sample2](https://cloud.githubusercontent.com/assets/931655/8675936/514b7f60-2a81-11e5-8806-26036d8e8ba5.png)


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
UIImage.size(width: 100, height: 100)     // fixed size
       .color(UIColor.whiteColor())       // fill color
       .border(color: UIColor.redColor()) // border color
       .border(width: 10)                 // border width
       .corner(radius: 20)                // corner radius
```

```swift
UIImage.resizable() // resizable image
       .color(UIColor.whiteColor())
       .border(color: UIColor.lightGrayColor())
       .border(width: 1)
       .corner(radius: 5)
```


#### Step 3. Generating Image

Use `.image()` at the end of method chaining to generate image.

```swift
imageView.image = UIImage.size(width: 100, height: 100)
                         .color(UIColor.whiteColor())
                         .border(color: UIColor.redColor())
                         .border(width: 10)
                         .corner(radius: 20)
                         .image()  // generate UIImage
```


### Methods Available

| Method | Description |
|---|---|
| `.size(width: CGFloat, height: CGFloat)` | Start chaining for fixed size image |
| `.size(CGSize)` | Start chaining for fixed size image |
| `.resizable()` | Start chaining for resizable image |

| Method | Description |
|---|---|
| `.color(UIColor)` | Set fill color |
| `.border(width: CGFloat)` | Set border width |
| `.border(color: UIColor)` | Set border color |
| `.border(alignment: BorderAlignment)` | Set border alignment. Same with Photoshop's.<br> `.Inside`, `.Center`, `.Outside` |
| `.corner(radius: CGFloat)` | Set all corners radius of image |
| `.corner(topLeft: CGFloat)` | Set top left corner radius of image |
| `.corner(topRight: CGFloat)` | Set top right corner radius of image |
| `.corner(bottomLeft: CGFloat)` | Set bottom left corner radius of image |
| `.corner(bottomRight: CGFloat)` | Set bottom right corner radius of image |


| Method | Description |
|---|---|
| `.image()` | Generate and return image |


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

#### iOS 8+

Use [CocoaPods](https://cocoapods.org). Minimum required version of CocoaPods is 0.36, which supports Swift frameworks.

**Podfile**

```ruby
pod 'SwiftyImage', '~> 0.2'
```


#### iOS 7

I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic framework.

**Seedfile**

```ruby
github 'devxoul/SwiftyImage', '0.2.1', :files => 'SwiftyImage/SwiftyImage.swift'
```


Playground
----------

Use CocoaPods command `$ pod try SwiftyImage` to try Playground!

![playground](https://cloud.githubusercontent.com/assets/931655/8679576/611e1b9a-2a96-11e5-9f34-debb222f28c6.png)


License
-------

SwiftyImage is under MIT license. See the LICENSE file for more info.
