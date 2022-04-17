//
//  WeakDictionary.swift
//  ScreenNavigatorKit
//
//  Created by Ernest Babayan on 17.04.2022.
//

import Foundation

final class WeakDictionary<Key: Hashable, Value: AnyObject> {
    private let table = NSMapTable<NSString, AnyObject>.strongToWeakObjects()

    subscript(_ key: Key) -> Value? {
        get {
            table.object(forKey: nsKey(for: key)) as? Value
        }
        set {
            table.setObject(newValue, forKey: nsKey(for: key))
        }
    }

    subscript(_ key: Key, default defaultValue: Value) -> Value {
        if let value = table.object(forKey: nsKey(for: key)) as? Value {
            return value
        } else {
            self[key] = defaultValue
            return defaultValue
        }
    }

    private func nsKey(for key: Key) -> NSString {
        String(key.hashValue) as NSString
    }
}
