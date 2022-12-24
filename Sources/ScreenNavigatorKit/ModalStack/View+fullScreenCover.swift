//
//  View+fullScreenCover.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 25.04.2022.
//

import SwiftUI

extension View {
    func fullScreenCover(
        _ destination: Binding<(some View)?>
    ) -> some View {
        fullScreenCover(
            isPresented: destination.isNotNil().removeDublicates(),
            content: { destination.wrappedValue }
        )
    }
}
