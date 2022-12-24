//
//  ModalStackController.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI
import Combine

/// Managed object that control modal stack hierarchy when present or dismiss views.
///
/// - Should be binded in specific View that become root view.
public final class ModalStackController: ObservableObject {
    // MARK: - Initializer

    public init() {}

    // MARK: - Properties

    private var toggles: [ModalToggle] = [
        ModalToggle()
    ]

    public var itemsCount: Int {
        toggles.count
    }

    // MARK: - Presenter View body

    func rootBody(content: some View) -> some View {
        content.modifier(
            ModalToggleViewModifier(toggle: toggles[0])
        )
    }

    // MARK: - Present

    /// Present view over last presented view.
    public func present(
        _ presentationStyle: PresentationStyle,
        _ destination: some View
    ) {
        present(
            presentationStyle: presentationStyle,
            hashTag: nil,
            destination: destination
        )
    }

    /// Present view over last presented view tagging it with a tag.
    ///
    /// The tag will allow to dismiss(to:) or dismiss(from:) exactly to this view.
    public func present(
        _ presentationStyle: PresentationStyle,
        tag: some Hashable,
        _ destination: some View
    ) {
        present(
            presentationStyle: presentationStyle,
            hashTag: AnyHashable(tag),
            destination: destination
        )
    }

    private func present(
        presentationStyle: PresentationStyle,
        hashTag: AnyHashable?,
        destination: some View
    ) {
        let currentToggle = toggles.last!
        let newToggle = ModalToggle(tag: hashTag)
        toggles.append(newToggle)

        let newToggleIndex = toggles.count - 1
        currentToggle.present(
            in: presentationStyle,
            to: destination,
            with: newToggle,
            onDismiss: { [weak self] in
                self?.toggles.removeSubrange(newToggleIndex...)
            }
        )
    }

    // MARK: - Dismiss

    /// Dismiss top-most view in modal stack.
    ///
    /// If modal stack has only root view, it will stay on root view.
    public func dismiss() {
        dismissLast(1)
    }

    /// Dismiss all presented view **consequentially**.
    ///
    /// If modal stack has only root view, it will stay on root view.
    public func dismissAll() {
        toggles
            .reversed()
            .forEach({ $0.dismiss() })
    }

    /// Dismiss last top-most views **consequentially**.
    ///
    /// If modal stack has only root view, it will stay on root view.
    public func dismissLast(_ screensNumber: Int) {
        guard screensNumber < toggles.count else {
            dismissAll()
            return
        }

        let newTopmostScreenIndex = (toggles.count - 1) - screensNumber

        toggles[newTopmostScreenIndex...]
            .reversed()
            .forEach({ $0.dismiss() })
    }

    /// Dismiss all top-most view starting with view specific tag.
    ///
    /// Search first view with passed screen tag and remove it and all next presented views **consequentially**.
    /// If the view is not found, nothing happens.
    public func dismiss(from tag: some Hashable) {
        guard let dismissScreenIndex = toggles.firstIndex(where: { $0.tag == AnyHashable(tag) }) else {
            return
        }

        guard dismissScreenIndex != 0 else {
            dismissAll()
            return
        }

        toggles[(dismissScreenIndex - 1)...]
            .reversed()
            .forEach({ $0.dismiss() })
    }

    /// Dismiss to view with view specific tag.
    ///
    /// Search first view with passed screen tag and remove it and all next presented views **consequentially**.
    /// If the view is not found, nothing happens.
    public func dismiss(to tag: some Hashable) {
        guard let newTopmostScreenIndex = toggles.firstIndex(where: { $0.tag == AnyHashable(tag) }) else {
            return
        }

        guard newTopmostScreenIndex != 0 else {
            dismissAll()
            return
        }

        toggles[newTopmostScreenIndex...]
            .reversed()
            .forEach({ $0.dismiss() })
    }
}
