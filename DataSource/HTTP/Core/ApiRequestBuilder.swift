//
//  ApiRequestBuilder.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation


public protocol ApiRequestBuilder {
    var requestBuilder: URLRequestBuilder { get }
}
