//
//  NavigationResponder.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

final class NavigationResponder: ObservableObject {
    private(set) weak var parentResponder: NavigationResponder?
    let nextResponder = WeakDictionary<ID, NavigationResponder>()

    @Published var pushedView: (() -> AnyView)?
    @Published var presentedView: (() -> AnyView)?

    func push<Destination: View>(_ destination: Destination) {
        pushedView = { [unowned self] in
            chainedView(with: destination, by: .push)
        }
    }

    func pop() {
        pushedView = .none
    }

    func present<Destination: View>(_ destination: Destination) {
        presentedView = { [unowned self] in
            chainedView(with: destination, by: .present)
        }
    }

    func dismiss() {
        presentedView = .none
    }

    private func chainedView<NextView: View>(with view: NextView, by id: ID) -> AnyView {
        let nextResponder = nextResponder[id, default: NavigationResponder()]
        nextResponder.parentResponder = self

        return AnyView(
            view.navigationResponding(with: nextResponder)
        )
    }
}
