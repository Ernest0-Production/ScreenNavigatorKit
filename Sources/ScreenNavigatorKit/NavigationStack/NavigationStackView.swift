//
//  NavigationStackView.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

/// Under-the-hood it's a NavigationView binded to NavigationStack state object
/// that provides (as environment object) tools to change navigation stack (i.e. push/pop) in child views.
public struct NavigationStackView<Content: View>: View {
    public init(
        _ navigationStack: @autoclosure @escaping () -> NavigationStack = NavigationStack(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._navigationStack = StateObject(wrappedValue: navigationStack())
        self.content = { _ in content() }
    }

    public init(@ViewBuilder content: @escaping (NavigationStack) -> Content) {
        self._navigationStack = StateObject(wrappedValue: NavigationStack())
        self.content = content
    }

    @StateObject var navigationStack: NavigationStack
    @ViewBuilder let content: (NavigationStack) -> Content

    public var body: some View {
        NavigationView {
            navigationStack.rootBody(
                content: content(navigationStack)
            )
        }
        .environmentObject(navigationStack)
    }
}
