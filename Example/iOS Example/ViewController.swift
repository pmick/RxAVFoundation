//
//  ViewController.swift
//  iOS Example
//
//  Created by Patrick Mick on 4/2/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import UIKit
import RxAVPlayer
import RxSwift
import RxCocoa
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var playerView: PlayerView!
    var player = AVPlayer()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = AVPlayerItem(URL: NSURL(string: "https://i.imgur.com/9rGrj10.mp4")!)
        player.replaceCurrentItemWithPlayerItem(item)
        
        playerView.playerLayer.rx_readyForDisplay
            .subscribeNext { ready in
                print("ready for display: \(ready)")
            }.addDisposableTo(disposeBag)
        
        playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerView.playerLayer.player = player
        
        player.rx_status
            .filter { $0 == .ReadyToPlay }
            .subscribeNext { status in
                print("item ready to play")
                self.player.play()
            }.addDisposableTo(disposeBag)
        player.rx_rate
            .subscribeNext { rate in
                print("rate: \(rate)")
            }.addDisposableTo(disposeBag)
        player.rx_error
            .subscribeNext { error in
                print("error: \(error)")
            }.addDisposableTo(disposeBag)
        
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.rx_periodicTimeObserver(interval: interval)
            .subscribeNext { time in
                self.progressView.progress = self.progress(time, duration: item.duration)
            }.addDisposableTo(disposeBag)
        
        item.rx_didPlayToEnd
            .subscribeNext { _ in
                print("did play to end")
            }.addDisposableTo(disposeBag)
        item.rx_playbackLikelyToKeepUp
            .subscribeNext { flag in
                print("playback likely to keep up: \(flag)")
            }.addDisposableTo(disposeBag)
        item.rx_playbackBufferFull
            .subscribeNext { flag in
                print("playback buffer full: \(flag)")
            }.addDisposableTo(disposeBag)
        item.rx_playbackBufferEmpty
            .subscribeNext { flag in
                print("playback buffer empty: \(flag)")
            }.addDisposableTo(disposeBag)
    }
    
    private func progress(currentTime: CMTime, duration: CMTime) -> Float {
        if CMTIME_IS_INVALID(duration) || CMTIME_IS_INVALID(currentTime) {
            return 0
        }
        
        let totalSeconds = Float(CMTimeGetSeconds(duration))
        let currentSeconds = Float(CMTimeGetSeconds(currentTime))
        
        if !isfinite(totalSeconds) || !isfinite(currentSeconds) {
            return 0
        }

        let p = min(currentSeconds/totalSeconds, 1)
        return p
    }
}

