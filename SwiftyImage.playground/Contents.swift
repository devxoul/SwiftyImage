import UIKit

/*:
SwiftyImage
===========

The most sexy way to use images in Swift.
*/

//: Create images with method chaining
//: ----------------------------------

UIImage.size(width: 100, height: 100)
       .color(UIColor.whiteColor())
       .border(color: UIColor.redColor())
       .border(width: 10)
       .corner(radius: 20)
       .image()


//: Resizable image
//: ---------------

({ () -> UIButton in
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    button.setBackgroundImage(
        UIImage.resizable().border(color: UIColor.greenColor()).border(width: 3).corner(radius: 10).image(),
        forState: .Normal
    )
    return button
})()
