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

extension AVPlayerLayer {
    public var rx_readyForDisplay: Observable<Bool> {
        return self.rx_observe(Bool.self, "readyForDisplay")
            .map { $0 ?? false }
    }
}
