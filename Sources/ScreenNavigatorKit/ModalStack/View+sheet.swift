//
//  View+sheet.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension View {
    func sheet(
        _ destination: Binding<(some View)?>
    ) -> some View {
        sheet(
            isPresented: destination.isNotNil().removeDublicates(),
            content: { destination.wrappedValue }
        )
    }
}
