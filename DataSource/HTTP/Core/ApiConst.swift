//
//  ApiConst.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

enum Authorization {
    case header(key: HttpHeaderKey, value: String)
    case bearer(token: String)
    
    func asRequestHeaders() -> [HttpHeaderKey: String] {
        switch self {
        case .header(let key, let value):
            return [key: value]
        case .bearer(let token):
            return [.authorization: "Bearer \(token)"]
        }
    }
}

enum HttpHeaderKey: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case contentLength = "Content-Length"
}

struct HttpContentType {
    private init() {}
    
    static let applicationJSON = "application/json"
    static let formUrlEncoded = "application/x-www-form-urlencoded"
    static let textPlain = "text/plain"
    
    static func multipartFormData(boundary: String) -> String {
        "multipart/form-data; boundary=\(boundary)"
    }
}
