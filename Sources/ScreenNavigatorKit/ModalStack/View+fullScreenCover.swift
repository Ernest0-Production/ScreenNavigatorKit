//
//  View+fullScreenCover.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 25.04.2022.
//

import SwiftUI

extension View {
    func fullScreenCover<Destination: View>(
        _ destination: Binding<Destination?>
    ) -> some View {
        fullScreenCover(
            isPresented: destination.isNotNil(),
            content: { destination.wrappedValue }
        )
    }
}
