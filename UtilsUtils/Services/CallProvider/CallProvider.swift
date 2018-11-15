//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

struct Call {
    let meetingId: String
}

protocol HasCallProvider {
    var callProvider: CallProvider { get }
}

protocol CallProvider {

    var onCall: Signal<Call> { get }
}

final class AppCallProvider: CallProvider {

    private let session: Session
    private let onCallSource = Source<Call>()

    var onCall: Signal<Call> {
        return onCallSource
    }

    init(session: Session) {
        self.session = session
        simulateCallAfterSomeTime()
    }

    private func simulateCallAfterSomeTime() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let call = Call(meetingId: "call1234")
            self.onCallSource.publish(call)
        }
    }
}
