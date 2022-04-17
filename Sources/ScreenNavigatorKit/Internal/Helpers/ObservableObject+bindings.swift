//
//  ObservableObject+bindings.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import SwiftUI
import Combine

extension ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher {
    func binding<Subject>(_ keyPath: ReferenceWritableKeyPath<Self, Subject>) -> Binding<Subject> {
        Binding(
            get: {
                self[keyPath: keyPath]
            },
            set: { newValue in
                self.objectWillChange.send()
                self[keyPath: keyPath] = newValue
            }
        )
    }
}
