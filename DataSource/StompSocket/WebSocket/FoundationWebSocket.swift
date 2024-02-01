//
//  FoundationWebSocket.swift
//  DataSource
//
//  Created by Dao Van Nha on 21/01/2024.
//

import Foundation

@available(iOS 13.0, macOS 10.15, *)
open class FoundationWebSocket: NSObject, WebSocketProtocol, URLSessionWebSocketDelegate {
    
    private var task: URLSessionWebSocketTask?
    
    private lazy var session = URLSession(configuration: .default,
                                          delegate: self,
                                          delegateQueue: .main)
    
    public var isConnected: Bool {
        task != nil && task?.state == .running
    }
    
    public var eventListener: ((WebSocketEvent) -> Void)?
    
    public func connect(request: URLRequest) {
        task = session.webSocketTask(with: request)
        task?.resume()
        observerMessage()
    }
    
    public func disconnect() {
        task?.cancel(with: .normalClosure, reason: nil)
        task = nil
    }
    
    public func send(string: String) {
        checkState()
        task?.send(.string(string), completionHandler: { error in
            if let error = error {
                print("[FoundationWebSocket] Error send string: \(error)")
            }
        })
    }
    
    public func send(data: Data) {
        checkState()
        task?.send(.data(data), completionHandler: { error in
            if let error = error {
                print("[FoundationWebSocket] Error send data: \(error)")
            }
        })
    }
    
    public func ping() {
        checkState()
        task?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("[FoundationWebSocket] Error send ping: \(error)")
            } else {
                print("[FoundationWebSocket] Received p0ng)")
            }
        })
    }
    
    private func checkState() {
        if task?.state != .running {
            print("[FoundationWebSocket] not running. current state: \(String(describing: task?.state.rawValue))")
        }
    }
    
    private func observerMessage() {
        checkState()
        
        task?.receive(completionHandler: { result in
            switch result {
            case .success(let success):
                switch success {
                case .string(let string):
                    print("[FoundationWebSocket] Received text message: \(string)")
                    self.eventListener?(.text(text: string))
                case .data(let data):
                    if let string = String(data: data, encoding: .utf8) {
                        print("[FoundationWebSocket] Received text message: \(string)")
                        self.eventListener?(.text(text: string))
                    } else {
                        print("[FoundationWebSocket] Received data: \(data)")
                        self.eventListener?(.data(data: data))
                    }
                @unknown default:
                    print("[FoundationWebSocket] Received unknown message type")
                }
            case .failure(let failure):
                print("[FoundationWebSocket] Receive error: \(failure)")
                self.eventListener?(.error(error: failure))
            }
            
            // completionHandler is removed right after receive message
            // so we have to observe message again every time.
            
            if self.task?.state == .running {
                self.observerMessage()
            }
        })
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("FoundationWebSocket didOpenWithProtocol \(`protocol` ?? "")")
        eventListener?(.connected)
    }
    
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        let reasonString = reason == nil ? nil : String(data: reason!, encoding: .utf8)
        print("FoundationWebSocket didCloseWithCode \(closeCode.rawValue) - reason: \(reasonString ?? "")")
        eventListener?(.disconnect(code: closeCode.rawValue, reason: reasonString))
    }
    
}
