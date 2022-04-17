//
//  NavigationResponder+chain.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

extension NavigationResponder {
    func chain(by id: ID) -> [NavigationResponder] {
        var chain: [NavigationResponder] = [self]
        var currentResponder = self

        while let nextResponder = currentResponder.nextResponder[id] {
            chain.append(nextResponder)
            currentResponder = nextResponder
        }

        return chain
    }
}
