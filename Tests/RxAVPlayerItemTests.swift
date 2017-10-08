//
//  RxAVPlayerItemTests.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
@testable import RxAVFoundation
import AVFoundation

class RxAVPlayerItemTests: XCTestCase {
    let asset = AVURLAsset(url: URL(string: "www.google.com")!)
    
    //MARK: Status
    
    func testPlayerItem_ShouldAllowObservationOfStatus() {
        let sut = AVPlayerItem(asset: asset)
        var capturedStatus: AVPlayerItemStatus?
        sut.rx.status
            .subscribe(onNext: { capturedStatus = $0 })
            .dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerItemStatus.unknown)
    }
    
    func testPlayerItem_ShouldUpdateRxStatus() {
        class MockItem: AVPlayerItem {
            fileprivate override var status: AVPlayerItemStatus {
                return .readyToPlay
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedStatus: AVPlayerItemStatus?
        sut.rx.status
            .subscribe(onNext: { capturedStatus = $0 })
            .dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerItemStatus.readyToPlay)
    }
    
    // MARK: Error
    
    func testPlayerItem_ShouldAllowObservationOfError() {
        let sut = AVPlayerItem(asset: asset)
        var capturedError: NSError?
        sut.rx.error
            .subscribe(onNext: { capturedError = $0 })
            .dispose()
        
        XCTAssertNil(capturedError)
    }
    
    func testPlayerItem_ShouldUpdateRxError() {
        class MockItem: AVPlayerItem {
            fileprivate override var error: Error? {
                return NSError.test
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedError: NSError?
        sut.rx.error
            .subscribe(onNext: { capturedError = $0 })
            .dispose()
        
        XCTAssertEqual(capturedError, NSError.test)
    }
    
    //MARK: Duration
    
    func testPlayerItem_ShouldAllowObservationOfDuration() {
        let sut = AVPlayerItem(asset: asset)
        var capturedDuration: CMTime?
        sut.rx.duration
            .subscribe(onNext: { capturedDuration = $0 })
            .dispose()
        
        XCTAssertEqual(capturedDuration?.value, 0)
    }

    func testPlayerItem_ShouldUpdateRxDuration() {
        class MockItem: AVPlayerItem {
            // Using flag to test because player item does something odd and doesn't
            // return our mocked 5 second duration even though it's accessed
            var durationChecked = false
            fileprivate override var duration: CMTime {
                durationChecked = true
                return CMTime(seconds: 5, preferredTimescale: 1)
            }
        }
        
        let sut = MockItem(asset: asset)
        sut.rx.duration
            .subscribe(onNext: { duration in })
            .dispose()
        
        XCTAssertTrue(sut.durationChecked)
    }
    
    // MARK: PlaybackLikelyToKeepUp
    
    func testPlayerItem_ShouldAllowObservationOfPlaybackLikelyToKeepUp() {
        let sut = AVPlayerItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackLikelyToKeepUp
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertFalse(capturedFlag)
    }
    
    func testPlayerItem_ShouldUpdateRxPlaybackLikelyToKeepUp() {
        class MockItem: AVPlayerItem {
            fileprivate override var isPlaybackLikelyToKeepUp: Bool {
                return true
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackLikelyToKeepUp
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertTrue(capturedFlag)
    }
    
    // MARK: PlaybackBufferFull
    
    func testPlayerItem_ShouldAllowObservationOfPlaybackBufferFull() {
        let sut = AVPlayerItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackBufferFull
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertFalse(capturedFlag)
    }
    
    func testPlayerItem_ShouldUpdateRxPlaybackBufferFull() {
        class MockItem: AVPlayerItem {
            fileprivate override var isPlaybackBufferFull: Bool {
                return true
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackBufferFull
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertTrue(capturedFlag)
    }
    
    // MARK: PlaybackBufferEmpty
    
    func testPlayerItem_ShouldAllowObservationOfPlaybackBufferEmpty() {
        let sut = AVPlayerItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackBufferEmpty
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertTrue(capturedFlag)
    }
    
    func testPlayerItem_ShouldUpdateRxPlaybackBufferEmpty() {
        class MockItem: AVPlayerItem {
            fileprivate override var isPlaybackBufferEmpty: Bool {
                return true
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedFlag: Bool!
        sut.rx.playbackBufferEmpty
            .subscribe(onNext: { capturedFlag = $0 })
            .dispose()
        
        XCTAssertTrue(capturedFlag)
    }
    
    // MARK: DidReachEnd
    
    func testPlayerItem_ShouldAllowObservationOfDidReachEnd() {
        let sut = AVPlayerItem(asset: asset)
        var called: Bool = false
        sut.rx.didPlayToEnd
            .subscribe(onNext: { note in called = true })
            .dispose()
        
        XCTAssertFalse(called)
    }
    
    func testPlayerItem_ShouldUpdateRxDidPlayToEnd() {
        let sut = AVPlayerItem(asset: asset)
        var called: Bool = false
        let observer = sut.rx.didPlayToEnd
            .subscribe(onNext: { note in called = true })
        
        let ns = NotificationCenter.default
        ns.post(name: .AVPlayerItemDidPlayToEndTime, object: sut)
        
        observer.dispose()
        
        XCTAssertTrue(called)
    }
    
    // MARK: LoadedTimeRanges
    
    func testPlayerItem_ShouldAllowObservationOfLoadedTimeRanges() {
        let sut = AVPlayerItem(asset: asset)
        var capturedRanges: [CMTimeRange]?
        sut.rx.loadedTimeRanges
            .subscribe(onNext: { capturedRanges = $0 })
            .dispose()
        
        XCTAssertEqual(capturedRanges!, [])
    }
    
    func testPlayerItem_WhenLoadedTimeRangesHasATimeRange_ShouldProduceThatRange() {
        class MockItem: AVPlayerItem {
            let range = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 5, preferredTimescale: 1))
            fileprivate override var loadedTimeRanges: [NSValue] {
                return [NSValue(timeRange: range)]
            }
        }
        
        let sut = MockItem(asset: asset)
        var capturedRanges: [CMTimeRange]?
        sut.rx.loadedTimeRanges
            .subscribe(onNext: { capturedRanges = $0 })
            .dispose()
        
        XCTAssertEqual(capturedRanges!, [sut.range])
    }
}
