//
//  DispatchQueue+Extensions.swift
//  DelegateProxy+Combine
//
//  Created by SwiftMan on 2022/08/14.
//

import Dispatch

extension DispatchQueue {
  private static var token: DispatchSpecificKey<()> = {
    let key = DispatchSpecificKey<()>()
    DispatchQueue.main.setSpecific(key: key, value: ())
    return key
  }()
  
  static var isMain: Bool {
    DispatchQueue.getSpecific(key: token) != nil
  }
}
