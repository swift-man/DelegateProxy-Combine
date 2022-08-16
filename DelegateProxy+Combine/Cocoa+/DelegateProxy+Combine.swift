//
//  DelegateProxy+Combine.swift
//  
//
//  Created by SwiftMan on 2022/08/14.
//

import Foundation

// MARK: casts or fatal error

// workaround for Swift compiler bug, cheers compiler team :)
func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
      fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    
    return result
}
