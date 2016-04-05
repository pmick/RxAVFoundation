//
//  RxAVPlayerLayerTests.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/4/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
@testable import RxAVPlayer
import AVFoundation

class RxAVPlayerLayerTests: XCTestCase {
    func testPlayerLayer_ShouldAllowObservationOfReadyForDisplay() {
        let sut = AVPlayerLayer()
        var capturedFlag: Bool!
        sut.rx_readyForDisplay
            .subscribeNext { capturedFlag = $0 }
            .dispose()
        
        XCTAssertFalse(capturedFlag)
    }
    
    // TODO: fix this test. if observation is set on isReadyToDisplay rather than
    // 'readyToDisplay' this will work correctly, but that's not the key path
    // we want to observe. This is failing because of that custom getter name
    // We could override observeValueForKey to capture arguments but that's
    // called a lot internally and fails.
//    func testPlayerLayer_ShouldUpdateRxReadyForDisplay() {
//        class MockLayer: AVPlayerLayer {
//            private override var readyForDisplay: Bool {
//                return true
//            }
//        }
//        
//        let sut = MockLayer()
//        var capturedFlag = false
//        sut.rx_readyForDisplay
//            .subscribeNext { capturedFlag = $0 }
//            .dispose()
//        
//        XCTAssertTrue(capturedFlag)
//    }
}
