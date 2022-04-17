//
//  Optional+unwrap.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import Foundation

extension Optional {
    func unwrap(orThrow error: Error) -> Wrapped {
        guard let value = self else {
            fatalError(error.localizedDescription)
        }

        return value
    }
}
