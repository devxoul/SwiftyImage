SwiftyImage
===========

[![CocoaPods](http://img.shields.io/cocoapods/v/SwiftyImage.svg?style=flat)](https://cocoapods.org/pods/SwiftyImage)

The most sexy way to use images in Swift.


Features
--------

* [x] Create images with method chaining
* [x] Cache created images with properties
* [x] iOS support
* [ ] OS X support


At a Glance
-----------

Use `$ pod try SwiftyImage` to try Playground.

#### Fixed-size image

```swift
UIImage.size(width: 100, height: 100)
       .color(UIColor.whiteColor())
       .border(color: UIColor.redColor())
       .border(width: 10)
       .corner(radius: 20)
       .image()
```

#### Resizable image

```swift
UIImage.resizable()
       .color(UIColor.whiteColor())
       .border(color: UIColor.blueColor())
       .border(width: 5)
       .corner(radius: 10)
       .image()
```


Installation
------------

### iOS 8+

Use [CocoaPods](https://cocoapods.org). Minimum required version of CocoaPods is 0.36, which supports Swift frameworks.

**Podfile**

```ruby
pod 'SwiftyImage', '0.1.0'
```


### iOS 7

I recommend you to try [CocoaSeeds](https://github.com/devxoul/CocoaSeeds), which uses source code instead of dynamic framework.

**Seedfile**

```ruby
github 'devxoul/SwiftyImage', '0.1.0', :files => 'SwiftyImage/SwiftyImage.swift'
```


Creating Images
---------------

SwiftyImage provides a simple way to create images with method chaining.


### 1) Start Chaining

Method chaining starts from `UIImage.size()` or `UIImage.resizable()`.

```swift
UIImage.size(width: CGFloat, height: CGFloat) // ...
UIImage.size(size: CGSize) // ...
UIImage.resizable() // ...
```

#### Methods Available

| Method | Description |
|---|---|
| `.size(width: CGFloat, height: CGFloat)` | Start chaining for fixed size image |
| `.size(CGSize)` | Start chaining for fixed size image |
| `.resizable()` | Start chaining for resizable image |


### 2) Setting Properties

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

#### Methods Available

| Method | Description |
|---|---|
| `.color(UIColor)` | Set fill color |
| `.border(width: CGFloat)` | Set border width |
| `.border(color: UIColor)` | Set border color |
| `.border(alignment: BorderAlignment)` | Set border alignment. Same with Photoshop's.<br> `.Inside`, `.Center`, `.Outside` |
| `.corner(radius: CGFloat)` | Set corner radius of image |


### 3) Generating Image

Use `.image()` at the end of method chaining to generate image.

```swift
imageView.image = UIImage.size(width: 100, height: 100)
                         .color(UIColor.whiteColor())
                         .border(color: UIColor.redColor())
                         .border(width: 10)
                         .corner(radius: 20)
                         .image()  // generate UIImage
```

#### Methods Available

| Method | Description |
|---|---|
| `.image()` | Generate and return image |


License
-------

SwiftyImage is under MIT license. See the LICENSE file for more info.
