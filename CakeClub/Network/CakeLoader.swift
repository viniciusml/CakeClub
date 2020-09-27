//
//  CakeLoader.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public protocol CakeLoader {
    typealias Result = Swift.Result<CakeList, LoadingError>

    func load(completion: @escaping (Result) -> Void)
}

public enum LoadingError: Error {
    case HTTPClientError
}
