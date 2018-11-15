//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class DummyViewController: UIViewController {

    private let text: String
    private let buttonTitle: String
    private let color: UIColor
    private let action: () -> Void

    init(text: String, buttonTitle: String, color: UIColor, action: @escaping () -> Void) {
        self.text = text
        self.buttonTitle = buttonTitle
        self.color = color
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color

        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(label)

        let button = UIButton.cta(color: color.inverted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(buttonTitle, for: [])
        button.setTitleColor(color, for: [])
        button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .primaryActionTriggered)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).priority(.defaultHigh),
            button.bottomAnchor.constraint(lessThanOrEqualTo: keyboardSafeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc
    private func onButtonPressed(_ sender: Any) {
        action()
    }
}

extension NSLayoutConstraint {

    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension UIViewController {

    /// A layout guide that covers the extent of the view controller's view,
    /// but which also shrinks (animatedly) when the keyboard blocks
    /// a portion of that view.
    ///
    /// Example usage:
    ///
    ///     let bottomButton: UIButton = ...
    ///     bottomButton.bottomAnchor.constraint(lessThanOrEqualTo: keyboardSafeAreaLayoutGuide.bottomAnchor).isActive = true
    internal var keyboardSafeAreaLayoutGuide: UILayoutGuide {
        if let existing = existingKeyboardSafeAreaLayoutGuide {
            return existing
        }

        let guide = KeyboardSafeAreaLayoutGuide()
        view.addLayoutGuide(guide)
        guide.bottomSpaceConstraint = guide.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            guide.topAnchor.constraint(equalTo: view.topAnchor),
            guide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            guide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            guide.bottomSpaceConstraint
            ])

        return guide
    }

    private var existingKeyboardSafeAreaLayoutGuide: UILayoutGuide? {
        return view.layoutGuides.first { $0 is KeyboardSafeAreaLayoutGuide }
    }

    private final class KeyboardSafeAreaLayoutGuide: UILayoutGuide {

        var bottomSpaceConstraint: NSLayoutConstraint!

        override init() {
            super.init()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillChangeFrame),
                                                   name: UIResponder.keyboardWillChangeFrameNotification,
                                                   object: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc
        private func keyboardWillChangeFrame(_ notification: Notification) {
            guard
                let view = owningView,
                let screenKeyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                    return
            }

            let localKeyboardFrame = view.convert(screenKeyboardFrame, from: nil)
            let obscuredDistance = view.bounds.maxY - localKeyboardFrame.minY

            bottomSpaceConstraint.constant = -obscuredDistance
            view.layoutIfNeeded()
        }
    }
}

