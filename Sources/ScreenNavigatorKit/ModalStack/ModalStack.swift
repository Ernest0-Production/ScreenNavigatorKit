//
//  File.swift
//  
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI
import Combine


public final class ModalStack: ObservableObject {
    public init() {}

    private let screenList = LinkedList<PresentScreen>(
        head: PresentScreen() // Presenter screen
    )

    // MARK: - Presenter View body

    func rootBody<Content: View>(content: Content) -> some View {
        PresentScreenView(
            content: content,
            screen: screenList.head.element
        )
    }

    // MARK: - Present

    public func present<ScreenTag: Hashable, Destination: View>(
        _ presentationStyle: PresentationStyle,
        screenTag: ScreenTag,
        _ destination: Destination
    ) {
        present(
            presentationStyle: presentationStyle,
            hashTag: AnyHashable(screenTag),
            destination: destination
        )
    }

    public func present<Destination: View>(
        _ presentationStyle: PresentationStyle,
        _ destination: Destination) {
        present(
            presentationStyle: presentationStyle,
            hashTag: nil,
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

    public func dismiss() {
        dismissLast(1)
    }

    public func dismissAll() {
        screenList.tail
            .previousNodesSequence
            .forEach({ $0.presentedView = nil })
    }

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

    public func dismiss<Tag: Hashable>(from screenTag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(screenTag) })?
            .previousNode

        currentScreen?
            .nextNodesSequence
            .reversed()
            .forEach({ $0.presentedView = nil })
    }

    public func dismiss<Tag: Hashable>(to screenTag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(screenTag) })

        currentScreen?
            .nextNodesSequence
            .reversed()
            .forEach({ $0.presentedView = nil })
    }
}
