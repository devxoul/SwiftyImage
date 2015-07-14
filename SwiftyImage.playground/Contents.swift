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

UIImage.size(width: 50, height: 50)
       .color(UIColor.yellowColor())
       .corner(radius: 10)
       .image()


//: Resizable image
//: ---------------

({ () -> UIButton in
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    button.setBackgroundImage(
        UIImage.resizable()
               .color(UIColor.whiteColor())
               .border(color: UIColor.orangeColor())
               .border(width: 10)
               .border(alignment: .Outside)
               .corner(radius: 15)
               .image(),
        forState: .Normal
    )
    return button
})()
