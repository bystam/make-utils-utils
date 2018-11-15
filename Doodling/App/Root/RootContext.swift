//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

struct RootContext: HasPushTriggers, HasURLSchemeTriggers {
    let sessionAtLaunch: Session?
    let pushTriggers: PushTriggers
    let urlSchemeTriggers: URLSchemeTriggers
}
