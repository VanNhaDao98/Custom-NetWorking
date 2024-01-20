//
//  HttpClient.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

class HttpClient {
    
    typealias DataTaskComplete<R> = (Result<HTTPResponse<R>, Error>) -> Void
    
    private var section: URLSession
    
    init(section: URLSession) {
        self.section = section
    }
    
    private lazy var errorNotifyQueue = DispatchQueue(label: "httpclient.error.log",
                                                      qos: .default,
                                                      attributes: .concurrent,
                                                      target: .global())
    
    private lazy var responseHandleQueue = DispatchQueue(label: "httpclient.response_handler",
                                                         qos: .default,
                                                         attributes: .concurrent,
                                                         target: .global())
    @discardableResult
    public func dataTask< R: Decodable>(request: URLRequest,
                                         completion: @escaping DataTaskComplete<R>) -> Cancellable {
        return self.dataTask(request: request,
                             body: nil as EmptySendingData?,
                             completion: completion)
    }
    
    @discardableResult
    public func dataTask<T: Encodable, R: Decodable>(request: URLRequest,
                                                      body: T?,
                                                      completion: @escaping DataTaskComplete<R>) -> Cancellable {
        return self.dataTask(request: request,
                             body: body,
                             bodyEncoding: {
            let encoder = JSONEncoder()
            return try encoder.encode($0)
        },
                             bodyDecoding: {
            let decoder = JSONDecoder()
            return try decoder.decode(R.self, from: $0)
        },
                             completion: completion)
    }
    
    private func dataTask<T: Encodable, R: Decodable>(request: URLRequest,
                                                      body: T?,
                                                      bodyEncoding: (T) throws -> Data,
                                                      bodyDecoding: @escaping (Data) throws  -> R,
                                                      completion: @escaping DataTaskComplete<R>) -> Cancellable {
        var request = request
        if request.httpBody == nil, let body = body {
            do {
                request.httpBody = try bodyEncoding(body)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(HTTPRequestError.encodeDataFailed))
                    print("\(request.url?.absoluteString ?? "")- Failed to encode body: \(error)")
                }
            }
        }
        print(request.curlString ?? "")
        let task = section.dataTask(with: request) { data, urlResponse, error in
            self.responseHandleQueue.async {
                self.handleDataTask(request: request,
                                    responseData: (data, urlResponse, error),
                                    bodyDecoding: bodyDecoding,
                                    completion: completion)
            }
        }
        
        task.resume()
        return task
    }
    
    private func handleDataTask<R: Decodable>(request: URLRequest,
                                              responseData: (Data?, URLResponse?, Error?),
                                              bodyDecoding: @escaping (Data) throws  -> R,
                                              completion: @escaping DataTaskComplete<R>) {
        
        let (data, response, error) = responseData
        
        func onCompletion(_ result: Result<HTTPResponse<R>, Error>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let requestUrl = request.url?.absoluteString ?? ""
        
        if let error = error {
            onCompletion(.failure(error))
          return
        }
        
        guard let data = data else {
            onCompletion(.failure(HTTPResponseError.missingReturnData))
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            onCompletion(.failure(HTTPResponseError.missingStatusCode))
            return
        }
        
        switch statusCode.responseType {
        case .informational, .success:
            handleSuccessResponse(requestUrl: requestUrl,
                                  response: response,
                                  receivedData: data,
                                  responseDecoder: bodyDecoding,
                                  completion: completion)
        default:
            onCompletion(.failure(HTTPResponseError.status(status: statusCode, data: data)))
        }
        
    }
    
    private func handleSuccessResponse<R>(requestUrl: String,
                                          response: URLResponse?,
                                          receivedData: Data,
                                          responseDecoder: @escaping (Data) throws -> R,
                                          completion: @escaping DataTaskComplete<R>) where R: Decodable {
        func onComplete(_ result: Result<HTTPResponse<R>, Error>) {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        guard let response = response as? HTTPURLResponse else {
            onComplete(.failure(HTTPResponseError.undefined))
            return
        }
        
//        func handleTextPlainResponse() -> Bool {
//            guard let contentType = response.headerValue(forKey: .contentType) as? String,
//                  contentType == HttpContentType.textPlain else {
//                return false
//            }
//            
//            if let string = String(data: receivedData, encoding: .utf8) as? R {
//                onComplete(.success(.init(data: string, response: response)))
//                return true
//            }
//            
//            return false
//        }
        
        if let empty = EmptyResponse() as? R {
            onComplete(.success(.init(data: empty, response: response)))
            return
        }
        
        do {
            let parsedObject = try responseDecoder(receivedData)
            onComplete(.success(.init(data: parsedObject, response: response)))
        } catch {
            onComplete(.failure(HTTPResponseError.decodeDataFailed))
        }
    }
}

extension HttpClient {
    private static var defaultSession: URLSession = {
        let config = URLSessionConfiguration.default
        
        // Increase number of simultaneous API requests
        config.httpMaximumConnectionsPerHost = 15
        
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = 60
        config.httpShouldSetCookies = false
        
        return URLSession(configuration: config)
    }()
    
    static let shared = HttpClient(section: HttpClient.defaultSession)
}
