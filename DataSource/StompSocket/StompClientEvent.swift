//
//  StompClientEvent.swift
//  DataSource
//
//  Created by Dao Van Nha on 21/01/2024.
//

import Foundation

public enum StompClientEvent {
    case connected
    case disconnected
    case message(body: String?, headers: [String: String], destination: String)
    case receipt(receiptId: String)
    case error(description: String, detailMessage: String?)
    case sentPing
}
