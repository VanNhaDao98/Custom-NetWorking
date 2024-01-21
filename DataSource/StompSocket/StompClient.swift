//
//  StompClient.swift
//  DataSource
//
//  Created by Dao Van Nha on 21/01/2024.
//

import Foundation

class StompClient {
    
    private var socket: WebSocketProtocol?
    
    private var urlRequest: URLRequest!
    
    private var connectionsHeaders: [String: String]?
    
    private var sectionId: String?
    
    private var reconnectTimer: Timer?
    
    private var pingTimer: Timer?
    
    public var eventListener: ((StompClientEvent) -> Void)?
    
    public var isCertificateCheckEnable: Bool = true
    
    public var isAutoPingEnable: Bool = true
    
    public var autoPingInterval: TimeInterval = 10
    
    public var isConnected: Bool {
        socket?.isConnected ?? false
    }
    
    private let socketBuilder: () -> WebSocketProtocol
    
    public init(socketBuilder: @escaping () -> WebSocketProtocol) {
        self.socketBuilder = socketBuilder
    }
    
    
    public func openSocketWithUrlRequest(urlRequest: URLRequest,
                                         connectionHeaders: [String: String]? = nil) {
        self.urlRequest = urlRequest
        self.connectionsHeaders = connectionHeaders
        openSocket()
    }
    
    private func openSocket() {
        self.socket = socketBuilder()
        self.socket?.eventListener = { [weak self] event in
            self?.handle(event: event)
        }
        
        self.socket?.connect(request: urlRequest)
    }
    
    private func handle(event: WebSocketEvent) {
        switch event {
        case .connected:
            if isAutoPingEnable {
                pingTimer?.invalidate()
                
                pingTimer = Timer.scheduledTimer(timeInterval: autoPingInterval,
                                                 target: self,
                                                 selector: #selector(ping),
                                                 userInfo: nil,
                                                 repeats: true)
            } else {
                pingTimer?.invalidate()
            }
            print("[StompClient] WebSocket is connected, send connect frame")
            sendConnectFrame()
        case .disconnect(let code, let reason):
            print("[StompClient] WebSocket disconnected with code: \(code), reason: \(reason ?? "nil")")
            pingTimer?.invalidate()
            eventListener?(.disconnected)
        case .text(let text):
            self.processString(string: text)
        case .data(let data):
            if let msg = String(data: data, encoding: .utf8) {
                processString(string: msg)
            }
        case .error(let error):
            print("[StompClient] WebSocket error occurred: \(String(describing: error))")
            pingTimer?.invalidate()
            eventListener?(.error(description: error.localizedDescription,
                                  detailMessage: nil))
        }
    }
    
    @objc private func ping() {
        socket?.ping()
        eventListener?(.sentPing)
    }
    
    private func sendConnectFrame() {
        
    }
    
    private func processString(string: String) {
        
    }
    
}
