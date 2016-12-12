//
//  StatusReportingTests.swift
//  RxAVFoundation
//
//  Created by Patrick Mick on 12/11/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import AVFoundation
import XCTest

import RxSwift

@testable import RxAVFoundation

struct GenericTestingError: Error, Equatable {
    public static func ==(lhs: GenericTestingError, rhs: GenericTestingError) -> Bool {
        return true
    }
 }

class FakeStatusReporting: NSObject, StatusReporting {
    var status: AVPlayerStatus {
        return .readyToPlay
    }
    
    var error: Error? = nil
    
    var playbackStatus: PlaybackStatus {
        return PlaybackStatus(rawValue: self.status.rawValue)!
    }
}

class StatusReportingTests: XCTestCase {
    func testObservingStatus_forwardsStatus() {
        let sut = FakeStatusReporting()
        
        var capturedStatus: PlaybackStatus?
        _ = sut.rx.status.subscribe(onNext: { status in
            capturedStatus = status
        })
        
        XCTAssertEqual(capturedStatus, .readyToPlay)
    }
}

class FakePlayer: AVPlayer {
    var _status: AVPlayerStatus = .unknown {
        willSet {
            self.willChangeValue(forKey: "status")
        }
        
        didSet {
            self.didChangeValue(forKey: "status")
        }
    }
    
    override var error: Error? {
        return GenericTestingError()
    }
    
    override var status: AVPlayerStatus {
        return _status
    }
}

class AVPlayer_StatusReportingTests: XCTestCase {
    func testObservingStatus_returnsUnknownByDefault() {
        let sut = AVPlayer()
        var capturedStatus: PlaybackStatus?
        _ = sut.rx.status.subscribe(onNext: { status in
            capturedStatus = status
        })
        
        XCTAssertEqual(capturedStatus, .unknown)
    }
    
    func testObservingStatus_whenStatusChanges_forwardsStatusTwice() {
        let sut = FakePlayer()
        var capturedStatus: PlaybackStatus?
        _ = sut.rx.status.subscribe(onNext: { status in
            capturedStatus = status
        })
        
        sut._status = .readyToPlay
        
        XCTAssertEqual(capturedStatus, .readyToPlay)
    }
    
    func testObservingStatus_whenStatusChangesToFailed_throwsError() {
        let sut = FakePlayer()
        var capturedError: GenericTestingError?
        // TODO: Why is the swift compiler broken? the same line
        // works above.
        let status: Observable<PlaybackStatus> = sut.rx.status
        _ = status.subscribe(onError: { error in
            capturedError = error as? GenericTestingError
        })
        
        sut._status = .failed
        
        XCTAssertEqual(capturedError, GenericTestingError())
    }
}

extension URL {
    static let testing = URL(string: "https://www.google.com")!
}

class FakePlayerItem: AVPlayerItem {
    var _status: AVPlayerItemStatus = .unknown {
        willSet {
            self.willChangeValue(forKey: "status")
        }
        
        didSet {
            self.didChangeValue(forKey: "status")
        }
    }
    
    override var error: Error? {
        return GenericTestingError()
    }
    
    override var status: AVPlayerItemStatus {
        return _status
    }
}

class AVPlayerItem_StatusReportingTests: XCTestCase {
    func testObservingStatus_returnsUnknownByDefault() {
        let sut = AVPlayerItem(url: URL.testing)
        var capturedStatus: PlaybackStatus?
        _ = sut.rx.status.subscribe(onNext: { status in
            capturedStatus = status
        })
        
        XCTAssertEqual(capturedStatus, .unknown)
    }
    
    func testObservingStatus_whenStatusChanges_forwardsStatusTwice() {
        let sut = FakePlayerItem(url: URL.testing)
        var capturedStatus: PlaybackStatus?
        _ = sut.rx.status.subscribe(onNext: { status in
            capturedStatus = status
        })
        
        sut._status = .readyToPlay
        
        XCTAssertEqual(capturedStatus, .readyToPlay)
    }
    
    func testObservingStatus_whenStatusChangesToFailed_throwsError() {
        let sut = FakePlayerItem(url: URL.testing)
        var capturedError: GenericTestingError?
        // TODO: Why is the swift compiler broken? the same line
        // works above.
        let status: Observable<PlaybackStatus> = sut.rx.status
        _ = status.subscribe(onError: { error in
            capturedError = error as? GenericTestingError
        })
        
        sut._status = .failed
        
        XCTAssertEqual(capturedError, GenericTestingError())
    }
}
