//
//  StatusReporting.swift
//  RxAVFoundation
//
//  Created by Patrick Mick on 12/11/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import AVFoundation
import Foundation

import RxSwift

struct UnknownPlaybackFailureError: Error { }

enum PlaybackStatus: Int {
    case unknown
    case readyToPlay
    case failed
}

/// This is a generalization over AVPlayer and AVPlayerItem because they both
/// share a status and error field.
protocol StatusReporting {
    associatedtype InheritedStatusType
    
    var error: Error? { get }
    var status: InheritedStatusType { get }
}

extension Reactive where Base: NSObject, Base: ReactiveCompatible, Base: StatusReporting {
    var status: Observable<PlaybackStatus> {
        return base.rx.observe(AVPlayerStatus.self, #keyPath(AVPlayer.status))
            .map { status -> PlaybackStatus in
                if status == .failed {
                    throw self.base.error ?? UnknownPlaybackFailureError()
                }
                
                if let status = status,
                    let playbackStatus = PlaybackStatus(rawValue: status.rawValue) {
                    return playbackStatus
                }
                
                return .unknown
        }
    }
}

extension AVPlayer: StatusReporting {}

extension AVPlayerItem: StatusReporting {}
