//
//  WeakDictionary.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import Foundation

final class WeakDictionary<Key: Hashable, Value: AnyObject> {
    private let table = NSMapTable<NSString, Value>.strongToWeakObjects()

    subscript(_ key: Key) -> Value? {
        get {
            table.object(forKey: key.nsString)
        }
        set {
            table.setObject(newValue, forKey: key.nsString)
        }
    }

    subscript(_ key: Key, default defaultValue: Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            self[key] = defaultValue
            return defaultValue
        }
    }
}

private extension Hashable {
    var nsString: NSString {
        String(hashValue) as NSString
    }
}
