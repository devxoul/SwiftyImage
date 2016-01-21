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

UIImage.size(width: 100, height: 100)
       .color(UIColor.whiteColor())
       .border(color: UIColor.blueColor())
       .border(width: 10)
       .border(alignment: .Outside)
       .corner(topLeft: 20)
       .corner(topRight: 15)
       .corner(bottomRight: 50)
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


//: Create image with context
//: -------------------------

UIImage.with(size: CGSize(width: 100, height: 100)) { context in
    UIColor.lightGrayColor().setFill()
    CGContextFillEllipseInRect(context, CGRect(x: 0, y: 0, width: 100, height: 100))
}


//: Append image with context
//: -------------------------

({ () -> UIImage in
    let background = UIImage.size(width: 120, height: 120)
                            .color(UIColor.blackColor())
                            .corner(radius: 13.5)
                            .image()
    let circle = UIImage.size(width: 106, height: 106)
                        .color(UIColor.whiteColor())
                        .corner(radius: 50)
                        .image()
    let center = UIImage.size(width: 6, height: 6)
                        .color(UIColor.blackColor())
                        .corner(radius: 3)
                        .image()
    let clock = background + circle + center
    return clock.with { context in
        CGContextSetLineCap(context, .Round)

        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(context, 2)

        CGContextMoveToPoint(context, clock.size.width / 2, clock.size.height / 2)
        CGContextAddLineToPoint(context, clock.size.width / 2 - 5, 15)

        CGContextMoveToPoint(context, clock.size.width / 2, clock.size.height / 2)
        CGContextAddLineToPoint(context, clock.size.width - 25, clock.size.height / 2 - 3)

        CGContextStrokePath(context)

        UIColor.redColor().setStroke()
        CGContextSetLineWidth(context, 1)

        CGContextMoveToPoint(context, clock.size.width / 2 + 8, clock.size.height / 2 - 7)
        CGContextAddLineToPoint(context, 26, clock.size.height / 2 + 32)

        CGContextStrokePath(context)

        UIColor.redColor().setFill()
        let rect = CGRect(x: clock.size.width / 2 - 1, y: clock.size.height / 2 - 1, width: 2, height: 2)
        CGContextFillEllipseInRect(context, rect)
    }
})()


//: Image operator
//: --------------

({ () -> UIImage in
    let background = UIImage.size(width: 120, height: 120)
                            .color(UIColor.blackColor())
                            .corner(radius: 13.5)
                            .image()
    let circle = UIImage.size(width: 106, height: 106)
                        .color(UIColor.whiteColor())
                        .corner(radius: 50)
                        .image()
    return background + circle
})()


//: Color overlay
//: -------------

({ () -> UIImage in
    let image = UIImage.size(width: 100, height: 100)
                       .color(UIColor.whiteColor())
                       .border(color: UIColor.blueColor())
                       .border(width: 10)
                       .border(alignment: .Outside)
                       .corner(topLeft: 20)
                       .corner(topRight: 15)
                       .corner(bottomRight: 50)
                       .image()
    return image.with(color: .redColor())
})()
