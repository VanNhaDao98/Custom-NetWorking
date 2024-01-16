//
//  Cancellable.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

extension URLSessionDataTask: Cancellable {
    
}
// Store multiple cancellables to cancel  later
public class CancellableStore: Cancellable {
    
    private var cancellables: [Cancellable]
    
    init(cancellables: [Cancellable] = []) {
        self.cancellables = cancellables
    }
    
    func add(_ cancellable: Cancellable) {
        cancellables.append(cancellable)
    }
    
    public func cancel() {
        cancellables.forEach({ $0.cancel()})
    }
}
