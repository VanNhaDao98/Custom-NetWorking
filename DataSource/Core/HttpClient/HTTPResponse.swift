//
//  HTTPResponse.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

class HTTPResponse<D> {
    let data: D
    let response: HTTPURLResponse
    
    init(data: D,
         response: HTTPURLResponse) {
        self.data = data
        self.response = response
    }
}
