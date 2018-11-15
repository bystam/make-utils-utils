//
//  Copyright Â© 2018 Frallware. All rights reserved.
//

import UIKit

extension UILabel {

    static func header() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }

    static func title() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }

    static func body() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }
}


extension UIButton {

    static func cta(color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.setBackgroundImage(
            ImageFactory.shadowedResizableImage(withBackground: color), for: []
        )
        return button
    }
}


extension UITableView {

    static func plain() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }
}

extension UIAlertController {

    static func alert(title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

extension UIColor {

    var inverted: UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: 1.0 - r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
}
