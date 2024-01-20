//
//  CommonResponse.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

public struct EmptySendingData: Encodable {
    
}

public struct EmptyResponse: Decodable {
    
}

public struct BoolResponse: Decodable {
    public let success: Bool?
    public let message: String?
}

