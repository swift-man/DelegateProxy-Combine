//
//  Publisher+countingSubscribers.swift
//  DelegateProxy+Combine
//
//  Created by SwiftMan on 2022/08/15.
//

#if !os(Linux)

import Combine

extension Publisher {
  public func countingSubscribers(_ callback: ((Int) -> Void)? = nil)
  -> Publishers.SubscribersCounter<Self> {
    return Publishers.SubscribersCounter<Self>(upstream: self, callback: callback)
  }
}

#endif
