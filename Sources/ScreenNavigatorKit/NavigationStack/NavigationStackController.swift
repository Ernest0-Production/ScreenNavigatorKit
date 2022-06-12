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

    private let screenList = LinkedList<PushScreen>(
        head: PushScreen() // Root screen
    )

    public var itemsCount: Int {
        screenList.sequence.reduce(0) { sum, _ in sum + 1 }
    }

    // MARK: - Root View body

    func rootBody<Content: View>(content: Content) -> some View {
        PushScreenView(
            content: content,
            screen: screenList.head.element
        )
    }

    // MARK: - Push

    /// Push view in navigation stack view.
    public func push<Destination: View>(_ destination: Destination) {
        push(
            hashTag: .none,
            destination: destination
        )
    }

    /// Push view in navigation stack view tagging it with a tag.
    ///
    /// The tag will allow to pop(to:) or pop(from:) exactly to this view.
    public func push<Tag: Hashable, Destination: View>(
        tag: Tag,
        _ destination: Destination
    ) {
        push(
            hashTag: AnyHashable(tag),
            destination: destination
        )
    }

    private func push<Destination: View>(
        hashTag: AnyHashable?,
        destination: Destination
    ) {
        let currentScreen = screenList.tail
        let newScreen = screenList.append(PushScreen(tag: hashTag))

        currentScreen.pushedView = PushScreenView(
            content: destination,
            screen: newScreen.element
        ).asAny()

        currentScreen.element.onChangePushedView = { [weak screenList, weak newScreen] presentedView in
            if presentedView == nil, let newScreen = newScreen {
                screenList?.remove(newScreen)
            }
        }
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
        screenList.head.element.pushedView = nil
    }

    /// Pop last top-most views in navigation stack view.
    ///
    /// If navigation stack has not any pushed views, it will stay on root view.
    public func popLast(_ screensNumber: Int) {
        let currentScreen = screenList.tail.previousNodesSequence.dropFirst(screensNumber).first
        currentScreen?.pushedView = nil
    }

    /// Pop all top-most views starting with view with specific tag in navigation stack view.
    ///
    /// Search first view with passed screen tag and remove it and all next views from navigation stack.
    /// If the view is not found, nothing happens.
    public func pop<Tag: Hashable>(from tag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(tag) })?
            .previousNode

        currentScreen?.pushedView = nil
    }

    /// Pop to view with specific tag in navigation stack view.
    ///
    /// Search first view with passed screen tag and remove all next views from navigation stack until tagged view is at the top of the stack.
    /// If the view is not found, nothing happens.
    public func pop<Tag: Hashable>(to tag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(tag) })

        currentScreen?.pushedView = nil
    }
}
