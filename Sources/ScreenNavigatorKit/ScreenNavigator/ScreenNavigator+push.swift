//
//  ScreenNavigator+push.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

public extension ScreenNavigator {
    func push<Destination: View>(@ViewBuilder _ destination: () -> Destination) {
        push(in: rootScreenTag, destination)
    }

    func push<Destination: View>(
        in presentingScreenTag: ScreenTag,
        @ViewBuilder _ destination: () -> Destination
    ) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .chain(by: .push)
            .last?
            .push(
                destination()
                    .environmentObject(self.focused(on: presentingScreenTag))
            )
    }

    func pop() {
        pop(in: rootScreenTag)
    }

    func pop(in presentingScreenTag: ScreenTag) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .chain(by: .push)
            .dropLast()
            .last?
            .pop()
    }

    func pop(to presentingScreenTag: ScreenTag) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .pop()
    }
}
