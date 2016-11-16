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

extension Reactive where Base: AVPlayer {
    public var rate: Observable<Float> {
        return self.observe(Float.self, #keyPath(AVPlayer.rate))
            .map { $0 ?? 0 }
    }
    
    public var status: Observable<AVPlayerStatus> {
        return self.observe(AVPlayerStatus.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }
    
    // TODO: This is directly related to status. Should these be wrapped up into one?
    // potentially an enum that wraps status with an associated error for Failed status?
    public var error: Observable<NSError?> {
        return self.observe(NSError.self, #keyPath(AVPlayer.error))
    }
    
    public func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let t = self.base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                observer.onNext(time)
            }
            
            return Disposables.create { self.base.removeTimeObserver(t) }
        }
    }
    
    public func boundaryTimeObserver(times: [CMTime]) -> Observable<Void> {
        return Observable.create { observer in
            let timeValues = times.map() { NSValue(time: $0) }
            let t = self.base.addBoundaryTimeObserver(forTimes: timeValues, queue: nil) {
                observer.onNext()
            }
            
            return Disposables.create { self.base.removeTimeObserver(t) }
        }
    }
}
