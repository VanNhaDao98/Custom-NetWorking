//
//  RemoteDateSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

public class RemoteDateSource<RequestBuilder: ApiRequestBuilder> {
    
    func execute<E: Encodable, D: Decodable>(api: RequestBuilder,
                                             body: E?,
                                             completion: @escaping(Result<HTTPResponse<D>, Error>) -> Void) -> Cancellable {
        
        let store = CancellableStore()
        
        let cancellable = HttpClient.shared.dataTask(request: api.requestBuilder.build(),
                                                     body: body,
                                                     completion: completion)
        
        store.add(cancellable)
        return store
    }
    
    func execute<D: Decodable>(api: RequestBuilder,
                               completion: @escaping(Result<HTTPResponse<D>, Error>) -> Void) -> Cancellable {
        execute(api: api,
                body: nil as EmptySendingData?,
                completion: completion)
    }
}
