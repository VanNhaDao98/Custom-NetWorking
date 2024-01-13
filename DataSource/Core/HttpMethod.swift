//
//  HttpMethod.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation
public enum HTTPMethod: String {
    case get        = "GET"
    case put        = "PUT"
    case post       = "POST"
    case patch      = "PATCH"
    case delete     = "DELETE"
    case head       = "HEAD"
    case options    = "OPTIONS"
    case trace      = "TRACE"
    case connect    = "CONNECT"
}
