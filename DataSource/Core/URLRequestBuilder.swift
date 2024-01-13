//
//  URLRequestBuilder.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

class URLRequestBuilder {
    
    private var endPoint: ApiServiceEndpoint
    
    private var httpMethod: HTTPMethod = .get
    private var path: String = ""
    private var body: Data?
    private var headers: [HttpHeaderKey: String] = [:]
    private var parameter: ParameterType?
    
    init(endPoint: ApiServiceEndpoint) {
        self.endPoint = endPoint
    }
    
    private func generateUrlComponent(path: String, params: ParameterType?) -> URL {
        var components = URLComponents()
        let (host, basePath) = endPoint.components
        
        components.scheme = endPoint.scheme
        components.host = host
        components.path = basePath + path
        components.queryItems = params?.map { URLQueryItem(name: $0.key, value: $0.value)}
        
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        
        return components.url!
    }
    
    private func buildHeader(header: [HttpHeaderKey: String]?) -> [String: String] {
        var defaultHeaders = [HttpHeaderKey: String]()
        defaultHeaders[.contentType] = HttpContentType.applicationJSON
        return defaultHeaders.joined(header ?? [:]).mapKeys({ $0.rawValue })
    }
    
    @discardableResult
    func path(_ path: String) -> Self {
        self.path = path
        return self
    }
    
    @discardableResult
    func body(_ body: Data?) -> Self {
        self.body = body
        return self
    }
    
    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        self.httpMethod = method
        return self
    }
    
    @discardableResult
    func authorize(_ authorization: Authorization) -> Self {
        headers(authorization.asRequestHeaders())
        return self
    }
    
    @discardableResult
    func headers(_ headers: [HttpHeaderKey: String]?) -> Self {
        if let headers = headers {
            // do not override Authorization header
            self.headers.join(headers, keepKey: .authorization)
        }
        return self
    }
    
    @discardableResult
    func parameters(_ parameters: ParameterType?) -> Self {
        self.parameter = parameters
        return self
    }
    
    func build() -> URLRequest {
        let url = generateUrlComponent(path: path, params: parameter)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = buildHeader(header: headers)
        return urlRequest
    }
}

extension URLRequestBuilder {
    static func `default`(domain: String,
                          path: String,
                          method: HTTPMethod = .get,
                          body: Data? = nil,
                          headers: [HttpHeaderKey: String]? = nil,
                          params: ParameterType? = nil) -> URLRequestBuilder {
        let enpoint: ApiServiceEndpoint = {
            .custom(domain)
        }()
        
        return URLRequestBuilder(endPoint: enpoint)
            .path(path)
            .method(method)
            .body(body)
            .parameters(params)
    }
}
