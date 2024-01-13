//
//  RemoteDateSource.swift
//  DataSource
//
//  Created by Dao Van Nha on 14/01/2024.
//

import Foundation

class RemoteDateSource<RequestBuilder: ApiRequestBuilder> {
    func execue<E: Encodable, D: Decodable>(apt: RequestBuilder,
                                            body: E?,
                                            completion: @escaping(Result<HTTPResponse<D>, Error>) -> Void) -> Cancellable {
        
        let store = CancellableStore()
        return store
    }
}
