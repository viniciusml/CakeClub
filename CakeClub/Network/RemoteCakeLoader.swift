//
//  RemoteCakeLoader.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public class RemoteCakeLoader: CakeLoader {
    let url: URL
    let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (CakeLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
        guard self != nil else { return }

            switch result {
            case let .success(items):
                completion(.success(items))
            case .failure:
                completion(.failure(.HTTPClientError))
            }
        }
    }
}
