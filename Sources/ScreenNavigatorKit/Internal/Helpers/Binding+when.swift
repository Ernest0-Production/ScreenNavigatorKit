//
//  Binding+when.swift
//  
//
//  Created by Ernest Babayan on 12.06.2022.
//

import SwiftUI

extension Binding {
    func when<Wrapped>(_ isTrue: Bool) -> Binding<Value> where Value == Wrapped? {
        Binding(
            get: {
                isTrue ? self.wrappedValue : nil
            },
            set: { newValue, transaction in
                self.transaction(transaction).wrappedValue = newValue
            }
        )
    }
}
