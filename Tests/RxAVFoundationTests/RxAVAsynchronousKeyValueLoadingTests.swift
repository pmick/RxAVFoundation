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
            fileprivate override func loadValuesAsynchronously(forKeys keys: [String], completionHandler handler: (() -> Void)?) {
                self.calledWithKeys = keys
            }
        }
        
        let asset = MockAsset(url: URL.test)
        
        let keys = ["duration"]
        asset.rx.loadValuesForKeys(keys)
            .subscribe(onNext: {})
            .dispose()
        
        XCTAssertEqual(asset.calledWithKeys, keys)
    }
    
    func testNextAndCompletedShouldBeEmitted_WhenCompletionIsCalled() {
        class MockAsset: AVURLAsset {
            fileprivate override func loadValuesAsynchronously(forKeys keys: [String], completionHandler handler: (() -> Void)?) {
                handler!()
            }
        }
        
        let asset = MockAsset(url: URL.test)
        var nextCalled = false
        var completedCalled = false
        
        let keys = ["duration"]
        let o = asset.rx.loadValuesForKeys(keys)
        o.subscribe(onNext: { nextCalled = true })
            .dispose()
        o.subscribe(onCompleted: { completedCalled = true })
            .dispose()
        
        XCTAssertTrue(nextCalled)
        XCTAssertTrue(completedCalled)
    }
}
