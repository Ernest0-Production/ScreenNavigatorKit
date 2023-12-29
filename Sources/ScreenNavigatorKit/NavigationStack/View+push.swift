//
//  View+push.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension View {
    func push(
        _ destination: Binding<(some View)?>
    ) -> some View {
        background(
            NavigationLink(
                destination: destination.wrappedValue,
                isActive: destination.isNotNil().removeDublicates(),
                label: { EmptyView() }
            )
            .isDetailLink(false)
            .hidden()
            .accessibilityHidden(true)
        )
    }
}
