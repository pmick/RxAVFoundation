//
//  RxAVAsynchronousKeyValueLoadingTests.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
import AVFoundation

class RxAVAsynchronousKeyValueLoadingTests: XCTestCase {
    func testCallingLoadValuesForKeys_CallsTheAsynchronousLoadingFunction() {
        class MockAsset: AVURLAsset {
            var calledWithKeys: [String]!
            private override func loadValuesAsynchronouslyForKeys(keys: [String], completionHandler handler: (() -> Void)?) {
                self.calledWithKeys = keys
            }
        }
        
        let asset = MockAsset(URL: NSURL.Test)
        
        let keys = ["duration"]
        asset.rx_loadValuesForKeys(keys)
            .subscribeNext { }
            .dispose()
        
        XCTAssertEqual(asset.calledWithKeys, keys)
    }
    
    func testNextAndCompletedShouldBeEmitted_WhenCompletionIsCalled() {
        class MockAsset: AVURLAsset {
            private override func loadValuesAsynchronouslyForKeys(keys: [String], completionHandler handler: (() -> Void)?) {
                handler!()
            }
        }
        
        let asset = MockAsset(URL: NSURL.Test)
        var nextCalled = false
        var completedCalled = false
        
        let keys = ["duration"]
        let o = asset.rx_loadValuesForKeys(keys)
        o.subscribeNext { nextCalled = true }
            .dispose()
        o.subscribeCompleted() { completedCalled = true }
            .dispose()
        
        XCTAssertTrue(nextCalled)
        XCTAssertTrue(completedCalled)
    }
}
