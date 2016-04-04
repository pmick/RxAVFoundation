//
//  PlayerView.swift
//  iOS Example
//
//  Created by Patrick Mick on 4/2/16.
//  Copyright © 2016 YayNext. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    override class func layerClass() -> AnyClass {
        return AVPlayerLayer.self
    }
    
    
}
