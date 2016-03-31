//
//  RxAVPlayerTests.swift
//  RxAVPlayerTests
//
//  Created by Patrick Mick on 3/30/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import XCTest
@testable import RxAVPlayer
import AVFoundation
import RxSwift
import RxCocoa

class RxAVPlayerRateTests: XCTestCase {
    let player = AVPlayer()
    var capturedRate: Float!

    func testObserving_ShouldReturnTheDefaultRateOfZero() {
        player.rx_rate.subscribeNext() { val in
            self.capturedRate = val
        }.dispose()
        
        XCTAssertEqual(capturedRate, 0)
    }
    
    func testObservingAPlayerWithARateOfOne_ShouldReturnOne() {
        player.rate = 1
        
        player.rx_rate.subscribeNext() { val in
            self.capturedRate = val
        }.dispose()
        
        XCTAssertEqual(capturedRate, 1)
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
        }
        
        let player = MockPlayer()
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_periodicTimeObserver(interval: interval).subscribeNext { time in
            
        }.dispose()
        
        XCTAssertEqual(player.interval, interval)
    }
    
    func testPeriodicTimeObserver_NotifiesObserversWhenItsBlockIsCalled() {
        class MockPlayer: AVPlayer {
            var block: (CMTime -> Void)!
            
            private override func addPeriodicTimeObserverForInterval(interval: CMTime, queue: dispatch_queue_t?, usingBlock block: (CMTime) -> Void) -> AnyObject {
                self.block = block
                return ""
            }
        }
        
        let player = MockPlayer()
        
        var capturedTime: CMTime!
        
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(1))
        player.rx_periodicTimeObserver(interval: interval).subscribeNext { time in
            capturedTime = time
            }.dispose()
        
        let time = CMTime(seconds: 2, preferredTimescale: CMTimeScale(1))
        player.block(time)
        
        XCTAssertEqual(capturedTime, time)
        
    }
}
