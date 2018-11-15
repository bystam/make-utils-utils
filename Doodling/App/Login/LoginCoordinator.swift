//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {

    let children = CoordinatorContainer()

    private let navigationController: UINavigationController
    private let context: LoginContext

    init(navigationController: UINavigationController, context: LoginContext) {
        self.navigationController = navigationController
        self.context = context
    }

    func stop() {}

    func start() {
        let onfidoController = OnfidoController(dependencies: context)
        let onfidoVC = OnfidoViewController(controller: onfidoController)
        navigationController.pushViewController(onfidoVC, animated: true)
    }
}
