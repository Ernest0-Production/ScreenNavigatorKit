//
//  ModalStackView.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

public struct ModalStackView<Content: View>: View {
    public init(
        _ controller: ModalStackController,
        @ViewBuilder content: () -> Content
    ) {
        self.controller = controller
        self.content = content()
    }

    @ObservedObject var controller: ModalStackController
    let content: Content

    public var body: some View {
        controller
            .rootBody(content: content)
            .environmentObject(controller)
    }
}
