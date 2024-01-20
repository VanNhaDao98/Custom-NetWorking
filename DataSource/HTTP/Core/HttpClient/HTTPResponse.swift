//
//  HTTPResponse.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

public class HTTPResponse<D> {
    public var data: D
    public var response: HTTPURLResponse
    
    init(data: D,
         response: HTTPURLResponse) {
        self.data = data
        self.response = response
    }
}
