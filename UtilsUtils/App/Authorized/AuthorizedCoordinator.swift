//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class AuthorizedCoordinator: Coordinator {

    let children = CoordinatorContainer()

    private let container: UIViewController
    private let context: AuthorizedContext

    private let bag = SignalTokenBag()

    private lazy var authorizedViewController = DummyViewController(text: "Welcome", buttonTitle: "Buy healthcare", color: .green, action: { [weak self] in
        self?.showBookingFlow()
    })

    init(container: UIViewController, context: AuthorizedContext) {
        self.container = container
        self.context = context
    }

    func stop() {}

    func start() {
        embed(authorizedViewController, inside: container)

        listenToIncomingCalls()
    }

    private func listenToIncomingCalls() {
        context.callProvider.onCall.listen(with: self, { this, call in
            this.showIncomingCall()
        }).bindLifetime(to: bag)
    }

    private func showBookingFlow() {
        let bookingVC = DummyViewController(text: "Book a meeting", buttonTitle: "I have the flu", color: .blue, action: { [weak self] in
            self?.authorizedViewController.dismiss(animated: true)
        })

        authorizedViewController.present(bookingVC, animated: true)
    }

    private func showIncomingCall() {
        let meeting = Meeting(id: "meeting1234", clinician: Meeting.Clinician(name: "Fredrik"))
        let meetingContext = MeetingContext(session: context.session, meeting: meeting)

        let window = UIWindow(frame: UIScreen.main.bounds)
        let meetingCoordinator = MeetingCoordinator(window: window, context: meetingContext)
        meetingCoordinator.delegate = self

        addAndStart(child: meetingCoordinator)
        meetingCoordinator.start()
    }
}

extension AuthorizedCoordinator: MeetingCoordinatorDelegate {

    func meetingCoordinator(_ coordinator: MeetingCoordinator, didFinishIn window: UIWindow) {
        stopAndRemove(child: coordinator)
        window.isHidden = true
    }
}
