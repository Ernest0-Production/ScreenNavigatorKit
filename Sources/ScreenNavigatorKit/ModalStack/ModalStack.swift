//
//  ModalStack.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI
import Combine

/// Managed object that control modal stack hierarchy when present or dismiss views.
///
/// - Should be binded in specific View that become root view.
public final class ModalStack: ObservableObject {
    // MARK: - Initializer

    public init() {}

    // MARK: - Properties

    private let screenList = LinkedList<PresentScreen>(
        head: PresentScreen() // Presenter screen
    )

    public var itemsCount: Int {
        screenList.sequence.reduce(0) { sum, _ in sum + 1 }
    }

    // MARK: - Presenter View body

    func rootBody<Content: View>(content: Content) -> some View {
        PresentScreenView(
            content: content,
            screen: screenList.head.element
        )
    }

    // MARK: - Present

    /// Present view over last presented view.
    public func present<Destination: View>(
        _ presentationStyle: PresentationStyle,
        _ destination: Destination
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
    public func present<Tag: Hashable, Destination: View>(
        _ presentationStyle: PresentationStyle,
        tag: Tag,
        _ destination: Destination
    ) {
        present(
            presentationStyle: presentationStyle,
            hashTag: AnyHashable(tag),
            destination: destination
        )
    }

    private func present<Destination: View>(
        presentationStyle: PresentationStyle,
        hashTag: AnyHashable?,
        destination: Destination
    ) {
        let currentScreen = screenList.tail
        let newScreen = screenList.append(PresentScreen(tag: hashTag))

        currentScreen.presentationStyle = presentationStyle
        currentScreen.presentedView = PresentScreenView(
            content: destination,
            screen: newScreen.element
        ).asAny()

        currentScreen.element.onChangePresentedView = { [weak screenList, weak newScreen] presentedView in
            if presentedView == nil, let newScreen = newScreen {
                screenList?.remove(newScreen)
            }
        }
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
        screenList.tail
            .previousNodesSequence
            .forEach({ $0.presentedView = nil })
    }

    /// Dismiss last top-most views **consequentially**.
    ///
    /// If modal stack has only root view, it will stay on root view.
    public func dismissLast(_ screensNumber: Int) {
        let currentScreen = screenList.tail
            .previousNodesSequence
            .dropFirst(screensNumber)
            .first

        currentScreen?
            .nextNodesSequence
            .reversed()
            .forEach({ $0.presentedView = nil })
    }

    /// Dismiss all top-most view starting with view specific tag.
    ///
    /// Search first view with passed screen tag and remove it and all next presented views **consequentially**.
    /// If the view is not found, nothing happens.
    public func dismiss<Tag: Hashable>(from tag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(tag) })?
            .previousNode

        currentScreen?
            .nextNodesSequence
            .reversed()
            .forEach({ $0.presentedView = nil })
    }

    /// Dismiss to view with view specific tag.
    ///
    /// Search first view with passed screen tag and remove it and all next presented views **consequentially**.
    /// If the view is not found, nothing happens.
    public func dismiss<Tag: Hashable>(to tag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(tag) })

        currentScreen?
            .nextNodesSequence
            .reversed()
            .forEach({ $0.presentedView = nil })
    }
}
