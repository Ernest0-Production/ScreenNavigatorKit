//
//  ModalToggle.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 09.05.2022.
//

import SwiftUI
import Combine

final class ModalToggle: ObservableObject {
    // MARK: - Initializer

    init(tag: AnyHashable? = nil) { self.tag = tag }

    // MARK: - Dependencies

    let tag: AnyHashable?

    fileprivate(set) var presentationStyle: PresentationStyle?

    @Published fileprivate(set) var presentedView: AnyView?

    private weak var destinationToggle: ModalToggle?

    // MARK: - Properties

    @Published fileprivate(set) var isAppeared = false
    @Published fileprivate(set) var isDissapeared = false

    private var cancellables: [AnyCancellable] = []

    // MARK: - Methods

    func present(
        in presentationStyle: PresentationStyle,
        _ destinationView: some View,
        with destinationToggle: ModalToggle,
        onDismiss: @escaping () -> Void = {}
    ) {
        $isDissapeared.dropFirst().assign(to: &destinationToggle.$isAppeared)
        destinationToggle.$isDissapeared.dropFirst().assign(to: &$isAppeared)

        self.destinationToggle = destinationToggle
        self.presentationStyle = presentationStyle
        self.presentedView = destinationView.modifier(
            ModalToggleViewModifier(toggle: destinationToggle)
        ).asAny()

        destinationToggle.$isDissapeared
            .first { $0 }
            .sink { _ in onDismiss() }
            .store(in: &self.cancellables)
    }

    func dismissPresentedView(onComplete: @escaping () -> Void = {}) {
        if presentedView == nil {
            onComplete()
        } else {
            destinationToggle?.dismissPresentedView(onComplete: { [weak destinationToggle, weak self] in
                guard let self = self else { return }
                destinationToggle?.$isDissapeared
                    .first { $0 }
                    .sink { _ in onComplete() }
                    .store(in: &self.cancellables)

                self.presentedView = nil
            })
        }
    }
}

struct ModalToggleViewModifier: ViewModifier {
    @ObservedObject var toggle: ModalToggle

    func body(content: Content) -> some View {
        Group {
            content.onDisappear {
                toggle.isDissapeared = true
            }
            EmptyView()
                .sheet($toggle.presentedView.when(toggle.presentationStyle == .sheet))
            EmptyView()
                .fullScreenCover($toggle.presentedView.when(toggle.presentationStyle == .fullScreenCover))
        }
    }
}
