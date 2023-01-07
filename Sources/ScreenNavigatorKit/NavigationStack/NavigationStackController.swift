//
//  NavigationStackController.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI
import Combine

/// Managed object that change navigation view stack hierarchy on push or pop operation.
///
/// - Should be binded in specific NavigationStackView
/// - Can not be empty. It always has a root view even if it's a EmptyView
public final class NavigationStackController: ObservableObject {
    // MARK: - Initializer

    public init() {}

    // MARK: - Properties

    private var toggles: [PushToggle] = [
        PushToggle.root()
    ]

    public var itemsCount: Int {
        toggles.count
    }

    // MARK: - Root View body

    func rootBody(content: some View) -> some View {
        content.modifier(
            PushToggleViewModifier(toggle: toggles[0])
        )
    }

    // MARK: - Push

    /// Push view in navigation stack view.
    public func push(_ destination: some View) {
        push(
            hashTag: .none,
            destination: destination
        )
    }

    /// Push view in navigation stack view tagging it with a tag.
    ///
    /// The tag will allow to pop(to:) or pop(from:) exactly to this view.
    public func push(
        tag: some Hashable,
        _ destination: some View
    ) {
        push(
            hashTag: tag,
            destination: destination
        )
    }

    private func push(
        hashTag: AnyHashable?,
        destination pushedView: some View
    ) {
        let currentToggle = toggles.last!
        let newToggle = PushToggle(tag: hashTag)
        toggles.append(newToggle)

        let newToggleIndex = toggles.count - 1
        currentToggle.push(
            to: pushedView,
            with: newToggle,
            onDismiss: { [weak self] in
                self?.toggles.removeSubrange(newToggleIndex...)
            }
        )
    }

    // MARK: - Pop

    /// Pop top-most view in navigation stack view.
    ///
    /// If navigation stack has not any pushed views, it will stay on root view.
    public func pop() {
        popLast(1)
    }

    /// Pop to root view in navigation stack view.
    public func popToRoot() {
        toggles.first?.pop()
    }

    /// Pop last top-most views in navigation stack view.
    ///
    /// If navigation stack has not any pushed views, it will stay on root view.
    public func popLast(_ screensNumber: Int) {
        guard screensNumber < toggles.count else {
            popToRoot()
            return
        }

        toggles.dropLast(screensNumber).last?.pop()
    }

    /// Pop all top-most views starting with view with specific tag in navigation stack view.
    ///
    /// Search first view with passed screen tag and remove it and all next views from navigation stack.
    /// If the view is not found, nothing happens.
    public func pop(from tag: some Hashable) {
        guard let popScreenIndex = toggles.firstIndex(where: { $0.tag == AnyHashable(tag) }) else {
            return
        }

        guard popScreenIndex != 0 else {
            popToRoot()
            return
        }

        toggles[popScreenIndex - 1].pop()
    }

    /// Pop to view with specific tag in navigation stack view.
    ///
    /// Search first view with passed screen tag and remove all next views from navigation stack until tagged view is at the top of the stack.
    /// If the view is not found, nothing happens.
    public func pop(to tag: some Hashable) {
        guard let newTopmostScreenIndex = toggles.firstIndex(where: { $0.tag == AnyHashable(tag) }) else {
            return
        }

        guard newTopmostScreenIndex != 0 else {
            popToRoot()
            return
        }

        toggles[newTopmostScreenIndex].pop()
    }
}
