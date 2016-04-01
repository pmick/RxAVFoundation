//
//  AVPlayerItem+Rx.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension AVPlayerItem {
    public var rx_status: Observable<AVPlayerItemStatus> {
        return self.rx_observe(AVPlayerItemStatus.self, "status")
            .map { $0 ?? .Unknown }
    }
    
    public var rx_duration: Observable<CMTime> {
        return self.rx_observe(CMTime.self, "duration")
            .map { $0 ?? CMTime(seconds: 0, preferredTimescale: 0) }
    }
    
    public var rx_error: Observable<NSError?> {
        return self.rx_observe(NSError.self, "error")
    }
    
    public var rx_playbackLikelyToKeepUp: Observable<Bool> {
        return self.rx_observe(Bool.self, "playbackLikelyToKeepUp")
            .map { $0 ?? false }
    }
    
    public var rx_didPlayToEnd: Observable<NSNotification> {
        let ns = NSNotificationCenter.defaultCenter()
        return ns.rx_notification(AVPlayerItemDidPlayToEndTimeNotification,
                                  object: self)
    }
}
