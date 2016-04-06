//
//  RxAVPlayerTests.swift
//  RxAVPlayerTests
//
//  Created by Patrick Mick on 3/30/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
@testable import RxAVFoundation
import AVFoundation
import RxSwift
import RxCocoa

class RxAVPlayerRateTests: XCTestCase {
    let player = AVPlayer()
    var capturedRate: Float?

    func testObserving_ShouldReturnTheDefaultRateOfZero() {
        player.rx_rate
            .subscribeNext { self.capturedRate = $0 }
            .dispose()
        
        XCTAssertEqual(capturedRate, 0)
    }
    
    func testObservingAPlayerWithARateOfOne_ShouldReturnOne() {
        let sut = player.rx_rate.subscribeNext() { self.capturedRate = $0 }
        player.rate = 1
        sut.dispose()
        
        XCTAssertEqual(capturedRate, 1)
    }
}

class RxAVPlayerStatusTests: XCTestCase {
    func testObservingStatus_ShouldReturnTheDefaultUnknown() {
        let player = AVPlayer()
        var capturedStatus: AVPlayerStatus?
        player.rx_status
            .subscribeNext { capturedStatus = $0 }
            .dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerStatus.Unknown)
    }
    
    func testObservingStatus_WhenItChangesToReadyToPlay_ShouldUpdateTheObserver() {
        // Makes it so that we can update the readonly property
        class MockPlayer: AVPlayer {
            var changeableStatus: AVPlayerStatus = .Unknown {
                willSet { self.willChangeValueForKey("status") }
                didSet { self.didChangeValueForKey("status") }
            }
            private override var status: AVPlayerStatus { return changeableStatus }
        }
        
        let player = MockPlayer()
        var capturedStatus: AVPlayerStatus?
        let sut = player.rx_status.subscribeNext { capturedStatus = $0 }
        player.changeableStatus = .ReadyToPlay
        sut.dispose()
        
        XCTAssertEqual(capturedStatus, AVPlayerStatus.ReadyToPlay)
    }
}

class RxAVPlayerErrorTests: XCTestCase {
    func testObservingStatus_ShouldReturnTheDefaultUnknown() {
        let player = AVPlayer()
        var capturedError: NSError?
        player.rx_error
            .subscribeNext { capturedError = $0 }
            .dispose()
        
        XCTAssertNil(capturedError)
    }
    
    func testObservingStatus_WhenItChangesToReadyToPlay_ShouldUpdateTheObserver() {
        // Makes it so that we can update the readonly property
        class MockPlayer: AVPlayer {
            var changeableError: NSError? = nil {
                willSet { self.willChangeValueForKey("error") }
                didSet { self.didChangeValueForKey("error") }
            }
            private override var error: NSError? { return changeableError }
        }
        
        let player = MockPlayer()
        var capturedError: NSError?
        let sut = player.rx_error.subscribeNext { capturedError = $0 }
        player.changeableError = NSError.Test
        sut.dispose()
        
        XCTAssertEqual(capturedError, NSError.Test)
    }
}

class RxAVPlayerPeriodicTimeObserverTests: XCTestCase {
    func testPediodicTimeObserver_AddsAnObserverToTheAVPlayer() {
        class MockPlayer: AVPlayer {
            var interval: CMTime!
            
            private override func addPeriodicTimeObserverForInterval(interval: CMTime, queue: dispatch_queue_t?, usingBlock block: (CMTime) -> Void) -> AnyObject {
                self.interval = interval
                return ""
            }
            
            private override func removeTimeObserver(observer: AnyObject) { }
        }
        
        let player = MockPlayer()
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_periodicTimeObserver(interval: interval)
            .subscribeNext { time in }
            .dispose()
        
        XCTAssertEqual(player.interval, interval)
    }
    
    func testPeriodicTimeObserver_NotifiesObserversWhenItsBlockIsCalled() {
        class MockPlayer: AVPlayer {
            private override func addPeriodicTimeObserverForInterval(interval: CMTime, queue: dispatch_queue_t?, usingBlock block: (CMTime) -> Void) -> AnyObject {
                block(CMTime(seconds: 2, preferredTimescale: CMTimeScale(1)))
                return ""
            }
            
            private override func removeTimeObserver(observer: AnyObject) { }
        }
        
        let player = MockPlayer()
        var capturedTime: CMTime!
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_periodicTimeObserver(interval: interval)
            .subscribeNext { time in capturedTime = time }
            .dispose()
        
        let time = CMTime(seconds: 2, preferredTimescale: CMTimeScale(1))
        
        XCTAssertEqual(capturedTime, time)
    }
    
    func testPeriodicTimeObserver_ShouldRemoveTheTimeObserverWhenDisposed() {
        class MockPlayer: AVPlayer {
            var capturedRemove: String!
            
            private override func addPeriodicTimeObserverForInterval(interval: CMTime, queue: dispatch_queue_t?, usingBlock block: (CMTime) -> Void) -> AnyObject {
                return "test"
            }
            
            private override func removeTimeObserver(observer: AnyObject) {
                capturedRemove = observer as! String
            }
        }
        
        let player = MockPlayer()
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_periodicTimeObserver(interval: interval)
            .subscribeNext { time in }
            .dispose()
        
        XCTAssertEqual("test", player.capturedRemove)
    }
}

class RxAVPlayerPeriodicBoundaryObserverTests: XCTestCase {
    func testBoundaryTimeObserver_AddsAnObserverToTheAVPlayer() {
        class MockPlayer: AVPlayer {
            var times: [CMTime]!
            
            private override func addBoundaryTimeObserverForTimes(times: [NSValue], queue: dispatch_queue_t?, usingBlock block: () -> Void) -> AnyObject {
                self.times = times.map { $0.CMTimeValue }
                return ""
            }
            
            private override func removeTimeObserver(observer: AnyObject) { }
        }
        
        let player = MockPlayer()
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_boundaryTimeObserver(times: [time])
            .subscribeNext { }
            .dispose()
        
        XCTAssertEqual(player.times.first, time)
    }
    
    func testBoundaryTimeObserver_NotifiesObserversWhenItsBlockIsCalled() {
        class MockPlayer: AVPlayer {
            private override func addBoundaryTimeObserverForTimes(times: [NSValue], queue: dispatch_queue_t?, usingBlock block: () -> Void) -> AnyObject {
                block()
                return ""
            }
            
            private override func removeTimeObserver(observer: AnyObject) { }
        }
        
        let player = MockPlayer()
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        var closureCalled = false
        player.rx_boundaryTimeObserver(times: [time])
            .subscribeNext { closureCalled = true }
            .dispose()
        
        XCTAssertTrue(closureCalled)
    }
    
    func testBoundaryTimeObserver_ShouldRemoveTheTimeObserverWhenDisposed() {
        class MockPlayer: AVPlayer {
            var capturedRemove: String!
            
            private override func addBoundaryTimeObserverForTimes(times: [NSValue], queue: dispatch_queue_t?, usingBlock block: () -> Void) -> AnyObject {
                return "test"
            }
            
            private override func removeTimeObserver(observer: AnyObject) {
                capturedRemove = observer as! String
            }
        }
        
        let player = MockPlayer()
        let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_boundaryTimeObserver(times: [time])
            .subscribeNext { }
            .dispose()
        
        XCTAssertEqual("test", player.capturedRemove)
    }
}
