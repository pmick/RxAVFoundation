//
//  AVAsynchronousKeyValueLoading+Rx.swift
//  RxAVPlayer
//
//  Created by Patrick Mick on 4/1/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVAsynchronousKeyValueLoading {
    public func loadValuesForKeys(_ keys: [String]) -> Observable<Void> {
        return Observable.create { observer in
            self.base.loadValuesAsynchronously(forKeys: keys) {
                // TODO: Test statusOfValueForKey for every key that was loaded and
                // return some kind of error model if any keys failed to load
                
                observer.onNext(())
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
