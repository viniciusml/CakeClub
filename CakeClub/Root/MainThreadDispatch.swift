//
//  MainThreadDispatch.swift
//  CakeClub
//
//  Created by Vinicius Leal on 30/09/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
