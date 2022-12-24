//
//  ModalToggle.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 09.05.2022.
//

import SwiftUI
import Combine

final class ModalToggle: ObservableObject {
    init(tag: AnyHashable? = nil) { self.tag = tag }

    let tag: AnyHashable?

    fileprivate(set) var presentationStyle: PresentationStyle?
    @Published fileprivate(set) var presentedView: AnyView?

    private var cancellables: [AnyCancellable] = []

    func present(
        in presentationStyle: PresentationStyle,
        to destinationView: some View,
        with destinationToggle: ModalToggle,
        onDismiss: @escaping () -> Void
    ) {
        self.presentationStyle = presentationStyle
        self.presentedView = destinationView.modifier(
            ModalToggleViewModifier(toggle: destinationToggle)
        ).asAny()

        $presentedView
            .dropFirst()
            .first { view in
                view == nil
            }
            .sink { _ in
                onDismiss()
            }
            .store(in: &cancellables)
    }

    func dismiss() {
        presentedView = nil
    }
}

struct ModalToggleViewModifier: ViewModifier {
    @ObservedObject var toggle: ModalToggle

    func body(content: Content) -> some View {
        Group {
            content
            EmptyView()
                .sheet($toggle.presentedView.when(toggle.presentationStyle == .sheet))
            EmptyView()
                .fullScreenCover($toggle.presentedView.when(toggle.presentationStyle == .fullScreenCover))
        }
    }
}
