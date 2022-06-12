//
//  NavigationStackView.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

/// Under-the-hood it's a NavigationView binded to NavigationStackController state object
/// that provides (as environment object) tools to change navigation stack (i.e. push/pop) in child views.
public struct NavigationStackView<Content: View>: View {
    public init(
        _ controller: @autoclosure @escaping () -> NavigationStackController = NavigationStackController(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._controller = StateObject(wrappedValue: controller())
        self.content = { _ in content() }
    }

    public init(@ViewBuilder content: @escaping (NavigationStackController) -> Content) {
        self._controller = StateObject(wrappedValue: NavigationStackController())
        self.content = content
    }

    @StateObject var controller: NavigationStackController
    @ViewBuilder let content: (NavigationStackController) -> Content

    public var body: some View {
        NavigationView {
            controller.rootBody(
                content: content(controller)
            )
        }
        .environmentObject(controller)
    }
}
