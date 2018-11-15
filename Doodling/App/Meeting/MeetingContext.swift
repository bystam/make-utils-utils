//
//  Copyright © 2018 Fredrik Bystam. All rights reserved.
//

import Foundation

struct Meeting {

    let id: String
    let clinician: Clinician

    struct Clinician {
        let name: String
    }
}

struct MeetingContext {

    let session: Session
    let meeting: Meeting
}
