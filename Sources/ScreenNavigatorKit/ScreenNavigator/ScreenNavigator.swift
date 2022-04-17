//
//  ScreenNavigator.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

public final class ScreenNavigator<ScreenTag: Hashable>: ObservableObject {
    public convenience init(rootScreenTag: ScreenTag) {
        self.init(
            rootScreenTag: rootScreenTag,
            responders: WeakDictionary<ScreenTag, NavigationResponder>()
        )
    }

    init(
        rootScreenTag: ScreenTag,
        responders: WeakDictionary<ScreenTag, NavigationResponder>
    ) {
        self.rootScreenTag = rootScreenTag
        self.responders = responders
    }

    public let rootScreenTag: ScreenTag
    let responders: WeakDictionary<ScreenTag, NavigationResponder>

    public func focused(on screenTag: ScreenTag) -> ScreenNavigator {
        ScreenNavigator(rootScreenTag: screenTag,responders: responders)
    }
}
