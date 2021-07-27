//
//  AVPlayerLayer+Rx.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/4/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerLayer {
    public var isReadyForDisplay: Observable<Bool> {
        return self.observe(Bool.self, #keyPath(AVPlayerLayer.isReadyForDisplay))
            .map { $0 ?? false }
    }

    @available(*, deprecated, renamed: "isReadyForDisplay")
    public var readyForDisplay: Observable<Bool> {
        isReadyForDisplay
    }
}
