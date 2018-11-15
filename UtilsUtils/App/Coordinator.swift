//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class CoordinatorContainer {
    fileprivate var array: [Coordinator] = []
}

protocol Coordinator: AnyObject {

    var children: CoordinatorContainer { get }

    func start()
    func stop()
}

extension Coordinator {

    func addAndStart(child coordiantor: Coordinator) {
        children.array.append(coordiantor)
        coordiantor.start()
    }

    func stopAndRemove(child coordinator: Coordinator) {
        coordinator.stop()
        children.array.removeAll(where: { $0 === coordinator })
    }
}

extension Coordinator {

    func embed(_ viewController: UIViewController, inside containerViewController: UIViewController, animated: Bool = false) {
        containerViewController.addChild(viewController)
        containerViewController.view.addSubview(viewController.view)
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.frame = containerViewController.view.bounds
        viewController.didMove(toParent: containerViewController)

        if animated {
            viewController.view.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                viewController.view.alpha = 1.0
            }
        }
    }

    func remove(_ viewController: UIViewController, animated: Bool = false) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                viewController.view.alpha = 0.0
            }, completion: { _ in
                viewController.view.alpha = 1.0
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            })
        } else {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }
}
