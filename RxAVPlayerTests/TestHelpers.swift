//
//  TestHelpers.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation

extension NSError {
    class var test: NSError {
        return NSError(domain: "test", code: 0, userInfo: nil)
    }
}
