//
//  Publishers+SubscribersCounter.swift
//  DelegateProxy+Combine
//
//  Created by SwiftMan on 2022/08/15.
//

#if !os(Linux)

import Combine

extension Publishers {
  
  public class SubscribersCounter<Upstream> : Publisher where Upstream : Publisher {
    
    private(set) var numberOfSubscribers = 0
    
    public typealias Output = Upstream.Output
    public typealias Failure = Upstream.Failure
    
    public let upstream: Upstream
    public let callback: ((Int) -> Void)?
    
    public init(upstream: Upstream, callback: ((Int) -> Void)?) {
      self.upstream = upstream
      self.callback = callback
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber,
                                                Upstream.Failure == S.Failure, Upstream.Output == S.Input {
                                                  self.increase()
                                                  upstream.receive(subscriber: SubscribersCounterSubscriber<S>(counter: self, subscriber: subscriber))
                                                }
    
    fileprivate func increase() {
      numberOfSubscribers += 1
      self.callback?(numberOfSubscribers)
    }
    
    fileprivate func decrease() {
      numberOfSubscribers -= 1
      self.callback?(numberOfSubscribers)
    }
    
    // own subscriber is needed to intercept upstream/downstream events
    private class SubscribersCounterSubscriber<S> : Subscriber where S: Subscriber {
      let counter: SubscribersCounter<Upstream>
      let subscriber: S
      
      init (counter: SubscribersCounter<Upstream>, subscriber: S) {
        self.counter = counter
        self.subscriber = subscriber
      }
      
      deinit {
        Swift.print(">> Subscriber deinit")
      }
      
      func receive(subscription: Subscription) {
        subscriber.receive(subscription: SubscribersCounterSubscription<Upstream>(counter: counter, subscription: subscription))
      }
      
      func receive(_ input: S.Input) -> Subscribers.Demand {
        return subscriber.receive(input)
      }
      
      func receive(completion: Subscribers.Completion<S.Failure>) {
        subscriber.receive(completion: completion)
      }
      
      typealias Input = S.Input
      typealias Failure = S.Failure
    }
    
    // own subcription is needed to handle cancel and decrease
    private class SubscribersCounterSubscription<Upstream>: Subscription where Upstream: Publisher {
      let counter: SubscribersCounter<Upstream>
      let wrapped: Subscription
      
      private var cancelled = false
      init(counter: SubscribersCounter<Upstream>, subscription: Subscription) {
        self.counter = counter
        self.wrapped = subscription
      }
      
      deinit {
        Swift.print(">> Subscription deinit")
        if !cancelled {
          counter.decrease()
        }
      }
      
      func request(_ demand: Subscribers.Demand) {
        wrapped.request(demand)
      }
      
      func cancel() {
        wrapped.cancel()
        if !cancelled {
          cancelled = true
          counter.decrease()
        }
      }
    }
  }
}

#endif
