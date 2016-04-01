//
//  RxAVPlayerItemTests.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
@testable import RxAVPlayer
import AVFoundation

class RxAVPlayerItemTests: XCTestCase {
    let asset = AVURLAsset(URL: NSURL(string: "www.google.com")!)
    
    //MARK: Status
    
    func testPlayerItem_ShouldAllowObservationOfStatus() {
        let sut = AVPlayerItem(asset: asset)
        var capturedStatus: AVPlayerItemStatus?
        sut.rx_status
            .subscribeNext { capturedStatus = $0 }
            .dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerItemStatus.Unknown)
    }
    
    func testPlayerItem_ShouldUpdateRxStatus() {
        class MockItem: AVPlayerItem {
            private override var status: AVPlayerItemStatus {
                return .ReadyToPlay
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedStatus: AVPlayerItemStatus?
        sut.rx_status
            .subscribeNext { capturedStatus = $0 }
            .dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerItemStatus.ReadyToPlay)
    }
    
    //MARK: Duration
    
    func testPlayerItem_ShouldAllowObservationOfDuration() {
        let sut = AVPlayerItem(asset: asset)
        var capturedDuration: CMTime?
        sut.rx_duration
            .subscribeNext { capturedDuration = $0 }
            .dispose()
        
        XCTAssertEqual(capturedDuration, CMTime(seconds: 0, preferredTimescale: 0))
    }

    // TODO: fix this -
//    func testPlayerItem_ShouldUpdateRxDuration() {
//        class MockItem: AVPlayerItem {
//            private override var duration: CMTime {
//                return CMTime(seconds: 5, preferredTimescale: 1)
//            }
//        }
//        
//        let sut = MockItem(asset: asset)
//        var capturedDuration: CMTime?
//        sut.rx_duration
//            .subscribeNext { capturedDuration = $0 }
//            .dispose()
//        
//        XCTAssertEqual(capturedDuration, CMTime(seconds: 5, preferredTimescale: 1))
//    }
    
    // MARK: Error
    
    func testPlayerItem_ShouldAllowObservationOfError() {
        let sut = AVPlayerItem(asset: asset)
        var capturedError: NSError?
        sut.rx_error
            .subscribeNext { capturedError = $0 }
            .dispose()
        
        XCTAssertNil(capturedError)
    }
    
    func testPlayerItem_ShouldUpdateRxError() {
        class MockItem: AVPlayerItem {
            private override var error: NSError? {
                return NSError.Test
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedError: NSError?
        sut.rx_error
            .subscribeNext { capturedError = $0 }
            .dispose()
        
        XCTAssertEqual(capturedError, NSError.Test)
    }
    
    // MARK: PlaybackLikelyToKeepUp
    
    func testPlayerItem_ShouldAllowObservationOfPlaybackLikelyToKeepUp() {
        let sut = AVPlayerItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx_playbackLikelyToKeepUp
            .subscribeNext { capturedFlag = $0 }
            .dispose()
        
        XCTAssertFalse(capturedFlag)
    }
    
    func testPlayerItem_ShouldUpdateRxPlaybackLikelyToKeepUp() {
        class MockItem: AVPlayerItem {
            private override var playbackLikelyToKeepUp: Bool {
                return true
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx_playbackLikelyToKeepUp
            .subscribeNext { capturedFlag = $0 }
            .dispose()
        
        XCTAssertTrue(capturedFlag)
    }
    
    // MARK: DidReachEnd
    
    func testPlayerItem_ShouldAllowObservationOfDidReachEnd() {
        let sut = AVPlayerItem(asset: asset)
        var called: Bool = false
        sut.rx_didPlayToEnd
            .subscribeNext { note in called = true }
            .dispose()
        
        XCTAssertFalse(called)
    }
    
    func testPlayerItem_ShouldUpdateRxDidPlayToEnd() {
        let sut = AVPlayerItem(asset: asset)
        var called: Bool = false
        let observer = sut.rx_didPlayToEnd
            .subscribeNext { note in called = true }
        
        let ns = NSNotificationCenter.defaultCenter()
        ns.postNotificationName(AVPlayerItemDidPlayToEndTimeNotification,
                                object: sut)
        
        observer.dispose()
        
        XCTAssertTrue(called)
    }
}