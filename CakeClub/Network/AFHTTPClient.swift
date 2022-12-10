//
//  AFHTTPClient.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Alamofire
import Foundation

public class AFHTTPClient: HTTPClient {

    public init() {}

    public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: CakeList.self) { response in

                switch response.result {
                case let .success(value):
                    completion(.success(value))
                case let .failure(error):
                    completion(.failure(error))
                }
        }
    }
}
