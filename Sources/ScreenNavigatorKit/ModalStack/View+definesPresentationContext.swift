//
//  File.swift
//  
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

public extension View {
    func definesPresentationContext(
        with modalStack: @autoclosure @escaping () -> ModalStack = ModalStack()
    ) -> some View {
        modifier(EmbedModalStackViewModifier(modalStack: modalStack()))
    }
}

private struct EmbedModalStackViewModifier: ViewModifier {
    @StateObject var modalStack: ModalStack

    func body(content: Content) -> some View {
        modalStack
            .rootBody(content: content)
            .environmentObject(modalStack)
    }
}
