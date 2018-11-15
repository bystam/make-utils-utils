//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

protocol MeetingCoordinatorDelegate: AnyObject {
    func meetingCoordinator(_ coordinator: MeetingCoordinator, didFinishIn window: UIWindow)
}

final class MeetingCoordinator: Coordinator {

    let children = CoordinatorContainer()

    weak var delegate: MeetingCoordinatorDelegate?

    private let window: UIWindow
    private let context: MeetingContext

    private let navigationController = UINavigationController()

    init(window: UIWindow, context: MeetingContext) {
        self.window = window
        self.context = context
    }

    func start() {
        let meetingVC = DummyViewController(text: "Video Call", buttonTitle: "End", color: .red, action: { [weak self] in
            self?.finish()
        })
        let callVC = DummyViewController(text: "Dr. Healer is calling", buttonTitle: "Answer", color: .black, action: { [weak self] in
            self?.navigationController.pushViewController(meetingVC, animated: true)
        })

        navigationController.viewControllers = [callVC]

        window.rootViewController = navigationController
        window.isHidden = false

        window.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.window.alpha = 1.0
        }
    }

    func stop() {}

    private func finish() {
        UIView.animate(withDuration: 0.3, animations: {
            self.window.alpha = 0.0
        }, completion: { _ in
            self.delegate?.meetingCoordinator(self, didFinishIn: self.window)
        })
    }
}
