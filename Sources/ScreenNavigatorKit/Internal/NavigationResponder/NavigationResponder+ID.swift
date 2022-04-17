//
//  NavigationResponder+ID.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension NavigationResponder {
    struct ID: Hashable {
        let rawValue: String

        static let push = ID(rawValue: "push")
        static let present = ID(rawValue: "present")
    }
}

