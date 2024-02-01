//
//  StompConsts.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/01/2024.
//

import Foundation

struct StompConsts {
    static let controlChar = String(format: "%C", arguments: [0x00])
    
    // Header Response Keys
    static let responseHeaderSession = "session"
    static let responseHeaderReceiptId = "receipt-id"
    static let responseHeaderErrorMessage = "message"
}
