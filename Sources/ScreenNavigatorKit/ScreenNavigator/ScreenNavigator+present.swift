//
//  ScreenNavigator+present.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

public extension ScreenNavigator {
    func present<Destination: View>(@ViewBuilder _ destination: () -> Destination) {
        present(in: rootScreenTag, destination)
    }

    func present<Destination: View>(
        in presentingScreenTag: ScreenTag,
        @ViewBuilder _ destination: () -> Destination
    ) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .chain(by: .present)
            .last?
            .present(
                destination()
                    .environmentObject(self.focused(on: presentingScreenTag))
            )
    }

    func dismiss() {
        dismiss(in: rootScreenTag)
    }

    func dismiss(in presentingScreenTag: ScreenTag) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .chain(by: .present)
            .dropLast()
            .last?
            .dismiss()
    }

    func dismiss(to presentingScreenTag: ScreenTag) {
        responders[presentingScreenTag]
            .unwrap(orThrow: ResponderNotFoundError(presentingScreenTag: presentingScreenTag))
            .chain(by: .present)
            .reversed()
            .forEach { responder in
                responder.dismiss()
            }
    }
}
