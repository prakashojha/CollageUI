//
//  StubVideoModel.swift
//  
//
//  Created by Saumya Prakash on 20/03/24.
//

import XCTest
import CollageUI
import AVKit

class Player: AVPlayer {
    var playCount = 0
    var pauseCount = 0
    var isMuteOn: Bool = false
    
    init(playCount: Int = 0, pauseCount: Int = 0, isMuteOn: Bool) {
        self.playCount = playCount
        self.pauseCount = pauseCount
        self.isMuteOn = isMuteOn
        super.init()
    }
    
    override func play() {
        playCount += 1
    }
    
    override var isMuted: Bool {
        set {
            self.isMuteOn = newValue
        }
        get {
            return self.isMuteOn
        }
    }
    
    override func pause() {
        pauseCount += 1
    }
}

struct StubVideoModel: MediaProtocol {
    var id: UUID = UUID()
    var orientation: Orientation = .Landscape
    var width: CGFloat = 250
    var height: CGFloat = 100
    var opacity: CGFloat = 1
    
    
}
