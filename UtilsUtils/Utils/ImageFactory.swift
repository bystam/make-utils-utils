//
//  Copyright Â© 2018 Frallware. All rights reserved.
//

import UIKit

enum ImageFactory {

    private static var cache: [UIColor : UIImage] = [:]

    static func shadowedResizableImage(withBackground color: UIColor) -> UIImage {
        if let cached = cache[color] {
            return cached
        }

        let bounds = CGRect(origin: .zero, size: CGSize(width: 16, height: 16))
        let inset: CGFloat = 4
        let radius: CGFloat = 3
        let resizingStart = inset + radius
        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        var image = renderer.image { context in

            let path = UIBezierPath(roundedRect: bounds.insetBy(dx: inset, dy: inset),
                                    cornerRadius: radius)

            context.cgContext.addPath(path.cgPath)
            context.cgContext.setShadow(offset: .zero,
                                        blur: 5.0,
                                        color: UIColor.black.withAlphaComponent(0.3).cgColor)

            color.setFill()
            context.cgContext.fillPath()
        }

        image = image.resizableImage(withCapInsets: UIEdgeInsets(top: resizingStart,
                                                                 left: resizingStart,
                                                                 bottom: resizingStart,
                                                                 right: resizingStart),
                                     resizingMode: .stretch)

        cache[color] = image

        return image
    }
}
