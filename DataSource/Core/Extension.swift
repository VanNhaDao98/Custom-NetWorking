//
//  Extension.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation
extension Dictionary {
    
    mutating func join(_ other: [Key: Value?], keepKey: Key? = nil) {
        if let keepKey = keepKey, keys.contains(keepKey) {
            other.compactMapValues({ $0 }).forEach({
                if $0.key != keepKey {
                    self[$0.key] = $0.value
                }
            })
        } else {
            other.compactMapValues({ $0 }).forEach({ self[$0.key] = $0.value })
        }
    }
    
    func joined(_ other: [Key: Value?], keepKey: Key? = nil) -> [Key: Value] {
        var dict = self
        dict.join(other, keepKey: keepKey)
        return dict
    }
    
    @inlinable
    func mapKeys<NewKey>(_ mapping: (Key) -> NewKey) -> [NewKey: Value] where NewKey: Hashable {
        var newDict = [NewKey: Value]()
        for (key, value) in self {
            newDict[mapping(key)] = value
        }
        return newDict
    }
}
