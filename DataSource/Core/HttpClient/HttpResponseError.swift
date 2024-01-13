//
//  HttpResponseError.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

enum HTTPRequestError: Error, LocalizedError {
    case encodeDataFailed
    
    var localizedDescription: String {
        switch self {
        case .encodeDataFailed:
            return "\(type(of: self)): encodeDataFailed"
        }
    }
}

enum HTTPResponseError: Error, LocalizedError {
    case missingStatusCode
    case missingReturnData
    case decodeDataFailed
    case status(status: HTTPStatusCode, data: Data?)
    case undefined
    
    var localizedDescription: String {
        switch self {
        case .missingStatusCode:
            return "\(type(of: self)): missingStatusCode"
        case .missingReturnData:
            return "\(type(of: self)): missingReturnData"
        case .decodeDataFailed:
            return "\(type(of: self)): decodeDataFailed"
        case .status(let status, _):
            return "\(type(of: self)): unexpected status: \(status) (\(status.rawValue))"
        case .undefined:
            return "\(type(of: self)): undefined error"
        }
    }
}

