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

    @IBOutlet weak var playerView: PlayerView!
    var player = AVPlayer()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = AVPlayerItem(URL: NSURL(string: "https://i.imgur.com/9rGrj10.gifv")!)
        player.replaceCurrentItemWithPlayerItem(item)
        
        playerView.playerLayer.player = player
        
        player.rx_status
            .filter { $0 == .ReadyToPlay }
            .subscribeNext { status in
                debugPrint("item ready to play")
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
        
        item.rx_didPlayToEnd
            .subscribeNext { _ in
                print("did play to end")
            }.addDisposableTo(disposeBag)
        
    }
}

