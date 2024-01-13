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

extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    var curlString: String? {
        guard let url = url, let method = HTTPMethod(rawValue: httpMethod ?? "") else { return nil }
        var baseCommand = #"curl -L "\#(url.absoluteString)""#
        
        if method == .head {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if method != .head {
            command.append("-X \(method.rawValue.uppercased())")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            let escapedBody = body.replacingOccurrences(of: "'", with: "'\\''")
            command.append("-d '\(escapedBody)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
}
