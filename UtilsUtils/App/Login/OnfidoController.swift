//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol OnfidoView: AnyObject {
    func showSuccess(_ success: Bool)
}

final class OnfidoController {

    typealias Dependencies = HasPushTriggers

    private let dependencies: Dependencies
    private let bag = SignalTokenBag()

    private weak var view: OnfidoView?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func bind(view: OnfidoView) {
        self.view = view
        listenToPushNotifications()
    }

    private func listenToPushNotifications() {
        dependencies.pushTriggers.onfidoResult.listen(with: self) { this, success in
            this.view?.showSuccess(success)
        }.bindLifetime(to: bag)
    }
}
