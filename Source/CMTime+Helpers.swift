//
//  CMTimeExtensions.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/4/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation
import AVFoundation

#if swift(>=4.2)
#else
extension CMTime {
    public static var zero: CMTime {
        return kCMTimeZero
    }
}
#endif
