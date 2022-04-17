//
//  ResponderNotFoundError.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import Foundation

struct ResponderNotFoundError<ScreenTag>: LocalizedError {
    let presentingScreenTag: ScreenTag

    var errorDescription: String? {
        "Не удалось найти презентующий экран \(presentingScreenTag)"
    }
}
