//
//  MainScheduler.swift
//  DelegateProxy+Combine
//
//  Created by SwiftMan on 2022/08/14.
//

import Foundation

import Dispatch
#if !os(Linux)
import Foundation
#endif

/**
 Abstracts work that needs to be performed on `DispatchQueue.main`. In case `schedule` methods are called from `DispatchQueue.main`, it will perform action immediately without scheduling.
 
 This scheduler is usually used to perform UI work.
 
 Main scheduler is a specialization of `SerialDispatchQueueScheduler`.
 
 This scheduler is optimized for `observeOn` operator. To ensure observable sequence is subscribed on main thread using `subscribeOn`
 operator please use `ConcurrentMainScheduler` because it is more optimized for that purpose.
 */
public final class MainScheduler {
  /// In case this method is called on a background thread it will throw an exception.
  public static func ensureExecutingOnScheduler(errorMessage: String? = nil) {
    if !DispatchQueue.isMain {
      fatalError(errorMessage ?? "Executing on background thread. Please use `MainScheduler.instance.schedule` to schedule work on main thread.")
    }
  }
  
  /// In case this method is running on a background thread it will throw an exception.
  public static func ensureRunningOnMainThread(errorMessage: String? = nil) {
#if !os(Linux) // isMainThread is not implemented in Linux Foundation
    guard Thread.isMainThread else {
      fatalError(errorMessage ?? "Running on background thread.")
    }
#endif
  }
}
