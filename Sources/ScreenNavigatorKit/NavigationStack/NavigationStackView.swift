//
//  File.swift
//  
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

public struct NavigationStackView<Content: View>: View {
    public init(
        _ navigationStack: @autoclosure @escaping () -> NavigationStack = NavigationStack(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._navigationStack = StateObject(wrappedValue: navigationStack())
        self.content = content
    }

    @StateObject var navigationStack: NavigationStack
    @ViewBuilder let content: () -> Content

    public var body: some View {
        NavigationView {
            navigationStack.rootBody(content: content())
        }
        .environmentObject(navigationStack)
    }
}
