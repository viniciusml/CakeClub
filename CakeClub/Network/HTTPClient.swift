//
//  HTTPClient.swift
//  CakeClub
//
//  Created by Vinicius Leal on 27/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<CakeList, Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}
