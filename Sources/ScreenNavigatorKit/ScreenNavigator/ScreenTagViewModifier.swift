//
//  ScreenTagViewModifier.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

public extension View {
    func screenTag<ScreenTag: Hashable>(_ tag: ScreenTag) -> some View {
        modifier(ScreenTagViewModifier(tag: tag))
    }
}

private struct ScreenTagViewModifier<ScreenTag: Hashable>: ViewModifier {
    let tag: ScreenTag
    @EnvironmentObject var screenNavigator: ScreenNavigator<ScreenTag>

    func body(content: Content) -> some View {
        content
            .navigationResponding(
                with: screenNavigator.responders[tag, default: NavigationResponder()]
            )
            .environmentObject(screenNavigator.focused(on: tag))
    }
}
