//
//  WebSocketEvent.swift
//  DataSource
//
//  Created by Dao Van Nha on 21/01/2024.
//

import Foundation

public enum WebSocketEvent {
    case connected
    case disconnect(code: Int, reason: String?)
    case text(text: String)
    case data(data: Data)
    case error(error: Error)
}

public protocol WebSocketProtocol {
    func connect(request: URLRequest)
    func disconnect()
    
    var isConnected: Bool { get }
    
    var eventListener: ((WebSocketEvent) -> Void)? { get set }
    
    func send(string: String)
    
    func send(data: Data)
    
    func ping()
}
