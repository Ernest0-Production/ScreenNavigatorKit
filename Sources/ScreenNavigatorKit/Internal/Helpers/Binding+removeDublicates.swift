//
//  File.swift
//  
//
//  Created by Ernest Babayan on 24.12.2022.
//

import SwiftUI

extension Binding where Value: Equatable {
    func removeDublicates() -> Binding {
        Binding {
            self.wrappedValue
        } set: { newValue, transaction in
            guard newValue != self.wrappedValue else {
                return
            }
            self.transaction(transaction).wrappedValue = newValue
        }
    }
}
