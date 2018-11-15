//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class RootCoordinator: Coordinator {

    let children = CoordinatorContainer()

    private let window: UIWindow
    private let context: RootContext

    private let appViewController = AppRootViewController()

    init(window: UIWindow, context: RootContext) {
        self.window = window
        self.context = context
    }

    func start() {
        window.rootViewController = appViewController
        window.makeKeyAndVisible()

        if let session = context.sessionAtLaunch {
            startAuthorizedFlow(with: session)
        } else {
            startLoginFlow()
        }
    }

    func stop() {}

    private func startAuthorizedFlow(with session: Session) {
        let authorizedContext = AuthorizedContext(rootContext: context, session: session)
        let authorizedCoordinator = AuthorizedCoordinator(container: appViewController, context: authorizedContext)

        addAndStart(child: authorizedCoordinator)
    }

    private func startLoginFlow() {
        let loginVC = DummyViewController(text: "Sign in please", buttonTitle: "Done", color: .red, action: { [weak self] in
            self?.appViewController.dismiss(animated: true)

            self?.startAuthorizedFlow(with: AppSession(id: "1234"))
        })

        appViewController.present(loginVC, animated: false)
    }
}

private final class AppRootViewController: UIViewController {}
