//
//  Binding+isNotNil.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI

extension Binding {
    func isNotNil<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        Binding<Bool>(
            get: { self.wrappedValue != nil },
            set: { exists, transaction in
                if !exists {
                    self.transaction(transaction).wrappedValue = nil
                }
            }
        )
    }
}
