//
//  File.swift
//
//
//  Created by Saumya Prakash on 20/03/24.
//

import AVKit
import XCTest
@testable import CollageUI

final class SpyMediaHandler: NSObject, MediaHandlerProtocol {
   
    var url: URL
    var player: AVPlayer
    
    // MARK: Test Related data
    var pauseMediaCount: Int = 0
    var playMediaCount: Int = 0
    var setObserverStatus: Bool = false
    var observerCallback: ( (Bool)->Void )?
    
    func createTestImageWith( width:CGFloat, height:CGFloat, color: UIColor) -> UIImage {
        let rect: CGRect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    init(url: URL, player: AVPlayer) {
        self.url = url
        self.player = player
    }
    
    func setObserver(_ observer: @escaping (Bool) -> Void) -> NSKeyValueObservation {
        return self.player.observe(\.isMuted) { player, change in
            observer(player.isMuted)
        }
    }
    
    func playMedia(withMuteOn: Bool) {
        playMediaCount += 1
    }
    
    func pauseMedia() {
        pauseMediaCount += 1
    }
    
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        //
    }
    
    func getCurrentItemAsset() -> AVAsset? {
        return AVAsset(url: self.url)
    }
    
    func getCurrentTime() -> CMTime {
        return CMTime(value: 25, timescale: 1000)
    }
    
    func getSnapShot() async -> UIImage? {
        return createTestImageWith(width: 10, height: 10, color: .red)
    }
    
}
    

