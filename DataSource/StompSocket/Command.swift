//
//  Command.swift
//  DataSource
//
//  Created by Dao Van Nha on 31/01/2024.
//

enum Command: String {
    case connect = "CONNECT"
    case send = "SEND"
    case subscribe = "SUBSCRIBE"
    case unsubscribe = "UNSUBSCRIBE"
    case begin = "BEGIN"
    case commit = "COMMIT"
    case abort = "ABORT"
    case ack = "ACK"
    case disconnect = "DISCONNECT"
    case ping = "\n"
}
