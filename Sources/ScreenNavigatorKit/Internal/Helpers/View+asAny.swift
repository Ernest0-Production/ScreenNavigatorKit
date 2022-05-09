//
//  File.swift
//  
//
//  Created by Ernest Babayan on 03.05.2022.
//

import SwiftUI

extension View {
    func asAny() -> AnyView {
        AnyView(self)
    }
}
