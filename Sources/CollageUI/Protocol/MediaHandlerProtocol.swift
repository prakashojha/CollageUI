//
//  AVPlayerHandlerProtocol.swift
//  
//
//  Created by Saumya Prakash on 20/03/24.
//

import SwiftUI
import AVKit

protocol MediaHandlerProtocol {
    var  url: URL { get }
    var  player: AVPlayer { get }
    func setObserver(_ observer: @escaping (Bool) -> Void ) -> NSKeyValueObservation
    func playMedia(withMuteOn: Bool)
    func pauseMedia()
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime)
    func getCurrentItemAsset() -> AVAsset?
    func getCurrentTime() -> CMTime
   // func createAVAssetImageGenerator(asset: AVAsset) -> AVAssetImageGenerator
   // func getImage(at time: CMTime,  _ imageGenerator: AVAssetImageGenerator) async -> CGImage?
    func getSnapShot() async -> UIImage?
}
