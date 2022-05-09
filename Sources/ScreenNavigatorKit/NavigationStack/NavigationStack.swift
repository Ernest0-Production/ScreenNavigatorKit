//
//  File.swift
//  
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI
import Combine

public final class NavigationStack: ObservableObject {
    public init() {}

    private let screenList = LinkedList<PushScreen>(
        head: PushScreen() // Root screen
    )

    // MARK: - Root View body

    func rootBody<Content: View>(content: Content) -> some View {
        PushScreenView(
            content: content,
            screen: screenList.head.element
        )
    }

    // MARK: - Push

    public func push<Destination: View>(_ destination: Destination) {
        push(
            hashTag: .none,
            destination: destination
        )
    }

    public func push<ScreenTag: Hashable, Destination: View>(
        screenTag: ScreenTag,
        _ destination: Destination
    ) {
        push(
            hashTag: AnyHashable(screenTag),
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

    public func pop() {
        popLast(1)
    }

    public func popToRoot() {
        screenList.head.element.pushedView = nil
    }

    public func popLast(_ screensNumber: Int) {
        let currentScreen = screenList.tail.previousNodesSequence.dropFirst(screensNumber).first
        currentScreen?.pushedView = nil
    }

    public func pop<Tag: Hashable>(from screenTag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(screenTag) })?
            .previousNode

        currentScreen?.pushedView = nil
    }

    public func pop<Tag: Hashable>(to screenTag: Tag) {
        let currentScreen = screenList.sequence
            .first(where: { $0.element.tag == AnyHashable(screenTag) })

        currentScreen?.pushedView = nil
    }
}
