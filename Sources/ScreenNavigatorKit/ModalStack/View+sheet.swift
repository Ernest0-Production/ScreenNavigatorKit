//
//  View+present.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension View {
    func sheet<Destination: View>(
        _ destination: Binding<Destination?>
    ) -> some View {
        sheet(
            isPresented: destination.isNotNil(),
            content: { destination.wrappedValue }
        )
    }
}
