//
//  PushToggle.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 08.05.2022.
//

import SwiftUI
import Combine

final class PushToggle: ObservableObject {
    static func root() -> PushToggle {
        let toggle = PushToggle()
        toggle.isAppeared = true
        return toggle
    }

    init(tag: AnyHashable? = nil) { self.tag = tag }

    let tag: AnyHashable?

    @Published fileprivate(set) var pushedView: AnyView?
    @Published fileprivate(set) var isAppeared = false
    @Published fileprivate(set) var isDissapeared = false

    private var cancellables: [AnyCancellable] = []

    func push(
        to destinationView: some View,
        with destinationToggle: PushToggle,
        onComplete: @escaping () -> Void = {},
        onDismiss: @escaping () -> Void = {}
    ) {
        $isDissapeared.dropFirst().assign(to: &destinationToggle.$isAppeared)
        destinationToggle.$isDissapeared.dropFirst().assign(to: &$isAppeared)

        $isAppeared
            .first { $0 }
            .sink { [unowned self] _ in
                pushedView = destinationView.modifier(
                    PushToggleViewModifier(toggle: destinationToggle)
                ).asAny()

                onComplete()
            }
            .store(in: &cancellables)

        $pushedView
            .dropFirst()
            .first { view in
                view == nil
            }
            .sink { _ in
                onDismiss()
            }
            .store(in: &cancellables)
    }

    func pop() {
        pushedView = nil
    }
}

struct PushToggleViewModifier: ViewModifier {
    @ObservedObject var toggle: PushToggle

    func body(content: Content) -> some View {
        content
            .push($toggle.pushedView)
            .onDisappear {
                toggle.isDissapeared = true
            }
    }
}
