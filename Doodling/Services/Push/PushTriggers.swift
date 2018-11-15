//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol HasPushTriggers {
    var pushTriggers: PushTriggers { get }
}

protocol PushTriggers {
    var answerCall: Signal<Void> { get }
    var onfidoResult: Signal<Bool> { get }
}

final class AppPushConsumer: PushTriggers {

    private enum Payload {

    }

    private let answerCallSource = Source<Void>()
    private let onfidoResultSource = Source<Bool>()

    var answerCall: Signal<Void> { return answerCallSource }
    var onfidoResult: Signal<Bool> { return onfidoResultSource }

    func consume(payload: [AnyHashable: Any]) {
        if (payload["type"] as? String == "answer_call") {
            answerCallSource.publish(())
        }
        if (payload["type"] as? String == "onfido") {
            let success = (payload["success"] as? Bool) == true
            onfidoResultSource.publish(success)
        }
    }
}
