import UIKit

/*:
SwiftyImage
===========

The most sexy way to use images in Swift.
*/

//: Create images with method chaining
//: ----------------------------------

UIImage.size(width: 100, height: 100)
       .color(UIColor.white)
       .border(color: UIColor.red)
       .border(width: 10)
       .corner(radius: 20)
       .image

UIImage.size(width: 50, height: 50)
       .color(UIColor.yellow)
       .corner(radius: 10)
       .image

UIImage.size(width: 100, height: 100)
       .color(UIColor.white)
       .border(color: UIColor.blue)
       .border(width: 10)
       .border(alignment: .outside)
       .corner(topLeft: 20)
       .corner(topRight: 15)
       .corner(bottomRight: 50)
       .image


//: Resizable image
//: ---------------

({ () -> UIButton in
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    button.setBackgroundImage(
        UIImage.resizable()
               .color(UIColor.white)
               .border(color: UIColor.orange)
               .border(width: 10)
               .border(alignment: .outside)
               .corner(radius: 15)
               .image,
        for: .normal
    )
    return button
})()


//: Create image with context
//: -------------------------

UIImage.with(size: CGSize(width: 100, height: 100)) { context in
    UIColor.lightGray.setFill()
    context.fillEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 100))
}


//: Append image with context
//: -------------------------

({ () -> UIImage in
    let background = UIImage.size(width: 120, height: 120)
                            .color(UIColor.black)
                            .corner(radius: 13.5)
                            .image
    let circle = UIImage.size(width: 106, height: 106)
                        .color(UIColor.white)
                        .corner(radius: 50)
                        .image
    let center = UIImage.size(width: 6, height: 6)
                        .color(UIColor.black)
                        .corner(radius: 3)
                        .image
    let clock = background + circle + center
    return clock.with { context in
        context.setLineCap(.round)

        UIColor.black.setStroke()
        context.setLineWidth(2)

        context.move(to: CGPoint(x: clock.size.width / 2, y: clock.size.height / 2))
        context.addLine(to: CGPoint(x: clock.size.width / 2 - 5, y: 15))

        context.move(to: CGPoint(x: clock.size.width / 2, y: clock.size.height / 2))
        context.addLine(to: CGPoint(x: clock.size.width - 25, y: clock.size.height / 2 - 3))

        context.strokePath()

        UIColor.red.setStroke()
        context.setLineWidth(1)

        context.move(to: CGPoint(x: clock.size.width / 2 + 8, y: clock.size.height / 2 - 7))
        context.addLine(to: CGPoint(x: 26, y: clock.size.height / 2 + 32))

        context.strokePath()

        UIColor.red.setFill()
        let rect = CGRect(x: clock.size.width / 2 - 1, y: clock.size.height / 2 - 1, width: 2, height: 2)
        context.fillEllipse(in: rect)
    }
})()


//: Image operator
//: --------------

({ () -> UIImage in
    let background = UIImage.size(width: 120, height: 120)
                            .color(UIColor.black)
                            .corner(radius: 13.5)
                            .image
    let circle = UIImage.size(width: 106, height: 106)
                        .color(UIColor.white)
                        .corner(radius: 50)
                        .image
    return background + circle
})()


//: Color overlay
//: -------------

({ () -> UIImage in
    let image = UIImage.size(width: 100, height: 100)
                       .color(UIColor.white)
                       .border(color: UIColor.blue)
                       .border(width: 10)
                       .border(alignment: .outside)
                       .corner(topLeft: 20)
                       .corner(topRight: 15)
                       .corner(bottomRight: 50)
                       .image
    return image.with(color: .red)
})()
