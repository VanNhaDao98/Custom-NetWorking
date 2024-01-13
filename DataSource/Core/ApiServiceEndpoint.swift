//
//  ApiServiceEndpoint.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

typealias ParameterType = [String: String]

protocol ApiServiceEndpointType {
    var components: (host: String, basePath: String) { get }
}

enum ApiServiceEndpoint: ApiServiceEndpointType {
    
    case custom(_ domain: String)
    
    var components: (host: String, basePath: String) {
        switch self {
        case .custom(let domain):
            return(domain, "")
        }
    }
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
}
