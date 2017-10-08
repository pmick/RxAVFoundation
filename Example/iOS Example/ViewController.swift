//
//  ViewController.swift
//  iOS Example
//
//  Created by Patrick Mick on 4/2/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import UIKit
import RxAVFoundation
import RxSwift
import RxCocoa
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var playerView: PlayerView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let player = AVPlayer()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = AVPlayerItem(url: URL(string: "https://i.imgur.com/9rGrj10.mp4")!)
        player.replaceCurrentItem(with: item)
        
        playerView.playerLayer.videoGravity = .resizeAspectFill
        playerView.playerLayer.player = player
        
        setupProgressObservation(item: item)
        
        // TODO: Build out this example by hiding loading indicator and pausing
        // adding a gesture recognizer to pause/resume playback etc.
        
        player.rx.status
            .filter { $0 == .readyToPlay }
            .subscribe(onNext: { [unowned self] status in
                print("item ready to play")
                self.player.play()
            }).addDisposableTo(disposeBag)
    }
    
    private func setupProgressObservation(item: AVPlayerItem) {
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.rx.periodicTimeObserver(interval: interval)
            .map { [unowned self] in self.progress(currentTime: $0, duration: item.duration) }
            .bindTo(progressView.rx.progress)
            .addDisposableTo(disposeBag)
    }
    
    private func progress(currentTime: CMTime, duration: CMTime) -> Float {
        if !duration.isValid || !currentTime.isValid {
            return 0
        }
        
        let totalSeconds = duration.seconds
        let currentSeconds = currentTime.seconds
        
        if !totalSeconds.isFinite || !currentSeconds.isFinite {
            return 0
        }

        let p = Float(min(currentSeconds/totalSeconds, 1))
        return p
    }
}

