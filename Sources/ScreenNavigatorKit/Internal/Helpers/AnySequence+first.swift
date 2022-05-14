//
//  AnySequence+first.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 09.05.2022.
//

import Foundation

extension AnySequence {
    var first: Element? {
        makeIterator().next()
    }
}
