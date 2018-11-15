//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

struct LoginContext: HasPushTriggers, HasURLSchemeTriggers {
    let pushTriggers: PushTriggers
    let urlSchemeTriggers: URLSchemeTriggers
}

extension LoginContext {

    init(rootContext: RootContext) {
        self.init(pushTriggers: rootContext.pushTriggers,
                  urlSchemeTriggers: rootContext.urlSchemeTriggers)
    }
}
