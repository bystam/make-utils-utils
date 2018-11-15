//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol HasSession {
    var session: Session { get }
}

protocol Session {

    var id: String { get }

    var onEnded: Signal<Void> { get }
}

final class AppSession: Session {

    private(set) var id: String

    private let onEndedSource = Source<Void>()

    var onEnded: Signal<Void> {
        return onEndedSource
    }

    static func persisted() -> AppSession? {
        return nil
    }

    init(id: String) {
        self.id = id
    }
}
