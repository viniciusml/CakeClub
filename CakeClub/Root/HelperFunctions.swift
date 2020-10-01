//
//  HelperFunctions.swift
//  CakeClub
//
//  Created by Vinicius Leal on 01/10/2020.
//  Copyright © 2020 Vinicius Leal. All rights reserved.
//

import Foundation

/// Creates a closure that automatically deals with weak-strong dance
/// Source: https://github.com/krzysztofzablocki/Strongify
///
/// - Parameters:
///   - context1: Any context object to weakify and strongify.
///   - closure: Closure to execute instead of the original one.
public func strongify<Context1: AnyObject>(weak context1: Context1?, closure: @escaping(Context1) -> Void) -> () -> Void {
    return { [weak context1] in
        guard let strongContext1 = context1 else { return }
        closure(strongContext1)
    }
}

/// Creates a closure that automatically deals with weak-strong dance
/// Source: https://github.com/krzysztofzablocki/Strongify
///
/// - Parameters:
///   - context1: Any context object to weakify and strongify.
///   - closure: Closure to execute instead of the original one.
public func strongify<Context1: AnyObject, Argument1>(weak context1: Context1?, closure: @escaping(Context1, Argument1) -> Void) -> (Argument1) -> Void {
    return { [weak context1] argument1 in
        guard let strongContext1 = context1 else { return }
        closure(strongContext1, argument1)
    }
}

func guaranteeMainThread(_ work: @escaping () -> Void) {
    if Thread.isMainThread {
        work()
    } else {
        DispatchQueue.main.async(execute: work)
    }
}
