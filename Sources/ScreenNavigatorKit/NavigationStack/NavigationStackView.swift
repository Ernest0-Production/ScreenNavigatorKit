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
        _ controller: NavigationStackController,
        @ViewBuilder content: () -> Content
    ) {
        self.controller = controller
        self.content = content()
    }

    @ObservedObject var controller: NavigationStackController
    let content: Content

    public var body: some View {
        NavigationView {
            controller.rootBody(
                content: content
            )
        }
        .environmentObject(controller)
    }
}
