//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import UIKit

final class OnfidoViewController: UIViewController, OnfidoView {

    private let controller: OnfidoController

    init(controller: OnfidoController) {
        self.controller = controller
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
    }

    func showSuccess(_ success: Bool) {
        view.backgroundColor = success ? .green : .red
    }
}
