//
//  View+definesPresentationContext.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

public extension View {
    /// Makes this view the **root view** on top of which all ModalStackController views will be presented.
    func definesPresentationContext(
        with modalStackController: @autoclosure @escaping () -> ModalStackController = ModalStackController()
    ) -> some View {
        modifier(EmbedModalStackViewModifier(modalStackController: modalStackController()))
    }
}

private struct EmbedModalStackViewModifier: ViewModifier {
    @StateObject var modalStackController: ModalStackController

    func body(content: Content) -> some View {
        modalStackController
            .rootBody(content: content)
            .environmentObject(modalStackController)
    }
}
