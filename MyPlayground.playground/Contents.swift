//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import XCPlayground

func play(interval: NSTimeInterval, target: AnyObject, selector: Selector) -> (NSTimer, Observable<Int>) {
    let timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: target, selector: selector, userInfo: nil, repeats: true)
    let signal = Observable<Int>.create {
        (subscriber) -> Disposable in
        subscriber.onNext(Int(arc4random_uniform(10)))
        return NopDisposable.instance
    }
    return (timer, signal)
}

class Player: NSObject {
    func foo(timer: NSTimer) {
        NSLog("fired")
    }
}

let player = Player()

//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let (timer, signal) = play(10, target: player, selector: "foo:")
signal.subscribeNext {
    NSLog("\($0)")
}

