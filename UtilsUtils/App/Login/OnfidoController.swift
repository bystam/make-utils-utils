//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol OnfidoView: AnyObject { // conformed to by the view controller
    func showSuccess(_ success: Bool)
}

protocol OnfidoControllerDelegate: AnyObject { // conformed to by the coordinator
    func ondifoControllerDidFinish(_ controller: OnfidoController)
}

final class OnfidoController {

    typealias Dependencies = HasPushTriggers

    weak var delegate: OnfidoControllerDelegate?

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
            this.delegate?.ondifoControllerDidFinish(this)
        }.bindLifetime(to: bag)
    }
}
