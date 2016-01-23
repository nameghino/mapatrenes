//
//  MapaTrenesTests.swift
//  MapaTrenesTests
//
//  Created by Nicolas Ameghino on 1/22/16.
//  Copyright © 2016 Nicolas Ameghino. All rights reserved.
//

import XCTest

import RxSwift

@testable import MapaTrenes

class MapaTrenesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAPI() {
        let expectation = expectationWithDescription("api test")
        
        let observable = TrainMapAPI.trainLocationsForLine(5, updateInterval: 1.0)
        let bag = DisposeBag()
        NSLog("testing")
        observable.subscribe(
            onNext: {
                (trains) -> Void in
                NSLog("stuff: \(trains)")
                XCTAssert(trains.count > 0)
            }, onError: {
                (error) -> Void in
                XCTFail("\(error)")
            }, onCompleted: nil, onDisposed: { expectation.fulfill() }
            ).addDisposableTo(bag)
        waitForExpectationsWithTimeout(30, handler: nil)
    }
}
