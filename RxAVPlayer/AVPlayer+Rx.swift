//
//  AVPlayer+Rx.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 3/30/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension AVPlayer {
    public var rx_rate: Observable<Float> {
        return self.rx_observe(Float.self, "rate")
            .map { $0 ?? 0 }
    }
    
    public var rx_status: Observable<AVPlayerStatus> {
        return self.rx_observe(AVPlayerStatus.self, "status")
            .map { $0 ?? .Unknown }
    }
    
    // TODO: This is directly related to status. Should these be wrapped up into one?
    // potentially an enum that wraps status with an associated error for Failed status?
    public var rx_error: Observable<NSError?> {
        return self.rx_observe(NSError.self, "error")
    }
    
    public func rx_periodicTimeObserver(interval interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let t = self.addPeriodicTimeObserverForInterval(interval, queue: nil) { time in
                observer.on(.Next(time))
            }
            
            return AnonymousDisposable { self.removeTimeObserver(t) }
        }
    }
    
    public func rx_boundaryTimeObserver(times times: [CMTime]) -> Observable<Void> {
        return Observable.create { observer in
            let timeValues = times.map() { NSValue(CMTime: $0) }
            let t = self.addBoundaryTimeObserverForTimes(timeValues, queue: nil) {
                observer.on(.Next(()))
            }
            
            return AnonymousDisposable { self.removeTimeObserver(t) }
        }
    }
}
