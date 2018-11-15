//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

protocol HasURLSchemeTriggers {
    var urlSchemeTriggers: URLSchemeTriggers { get }
}

protocol URLSchemeTriggers {
    var smsCode: Signal<String> { get }
}

final class AppURLSchemeConsumer: URLSchemeTriggers {

    private let smsCodeSource = Source<String>()

    var smsCode: Signal<String> {
        return smsCodeSource
    }

    func consume(url: URL) {
        smsCodeSource.publish("1234")
    }
}
