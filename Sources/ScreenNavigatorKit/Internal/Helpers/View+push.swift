//
//  View+push.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension View {
    func push<Destination: View>(
        _ destination: Binding<(() -> Destination)?>
    ) -> some View {
        background(NavigationLink(
            destination: Group {
                if let view = destination.wrappedValue {
                    view()
                }
            },
            isActive: destination.isNotNil(),
            label: { EmptyView() }
        ).isDetailLink(false))
    }
}
