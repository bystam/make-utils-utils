//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol OnfidoAPIFactory: HasSession {
}

extension OnfidoAPIFactory {
    func createOnfidoAPI() -> OnfidoAPI {
        return AppOnfidoAPI(sessionId: session.id)
    }
}

protocol OnfidoAPI {

    func submitStuff(_ stuff: String, completion: @escaping (Bool) -> Void)
}

final class AppOnfidoAPI: OnfidoAPI {

    init(sessionId: String) {

    }

    func submitStuff(_ stuff: String, completion: @escaping (Bool) -> Void) {

    }
}
