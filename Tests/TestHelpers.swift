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

extension URL {
    static var test: URL {
        return URL(string: "www.google.com")!
    }
}

struct GenericTestingError: Error, Equatable {
    public static func ==(lhs: GenericTestingError, rhs: GenericTestingError) -> Bool {
        return true
    }
}
