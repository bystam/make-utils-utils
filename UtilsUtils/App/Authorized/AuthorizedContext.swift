//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

struct AuthorizedContext: HasSession, HasPushTriggers, HasCallProvider {

    let session: Session
    let pushTriggers: PushTriggers
    let callProvider: CallProvider
}

extension AuthorizedContext {

    init(rootContext: RootContext, session: Session) {
        self.init(session: session,
                  pushTriggers: rootContext.pushTriggers,
                  callProvider: AppCallProvider(session: session))
    }
}
