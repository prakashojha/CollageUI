//
//  AVHandler.swift
//  
//
//  Created by Saumya Prakash on 20/03/24.
//

import SwiftUI
import AVKit

final class VideoHandler: MediaHandlerProtocol {
   
    let url: URL
    let videoPlayer: AVPlayer
    
    init(url: URL) {
        self.url = url
        self.videoPlayer = AVPlayer(url: url)
    }
    
    var player: AVPlayer {
        return self.videoPlayer
    }
    
    func setObserver(_ observer: @escaping (Bool) -> Void ) -> NSKeyValueObservation {
        return self.videoPlayer.observe(\.currentItem?.loadedTimeRanges) { player, change in
            let ready = player.status == .readyToPlay

            let timeRange = player.currentItem?.loadedTimeRanges.first as? CMTimeRange
            if let duration = timeRange?.duration {
                let timeLoaded = Int(duration.value) / Int(duration.timescale)
                let loaded = timeLoaded > 0
                observer(ready && loaded)
            }
        }
    }
    
    func playMedia(withMuteOn: Bool) {
        self.videoPlayer.play()
        self.videoPlayer.isMuted = withMuteOn
    }
    
    func seek(to: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        self.videoPlayer.seek(to: to, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter)
    }
    
    func pauseMedia() {
        self.videoPlayer.pause()
    }
    
    func getCurrentTime() -> CMTime {
        return videoPlayer.currentTime()
    }
    
    func getCurrentItemAsset() -> AVAsset? {
        return videoPlayer.currentItem?.asset
    }
    
    private func createAVAssetImageGenerator(asset: AVAsset) -> AVAssetImageGenerator {
        let imageGenerator = AVAssetImageGenerator(asset: asset);
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero;
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero;
        imageGenerator.appliesPreferredTrackTransform = true
        
        return imageGenerator
    }
    
    private func getImage(at time: CMTime, _ imageGenerator: AVAssetImageGenerator) async -> CGImage? {
        var thumb: CGImage?
        
        do {
            let (cgImage, _) = try await imageGenerator.image(at: time)
            thumb = cgImage
            
        } catch {
            await MainActor.run(body: {
                print("⛔️ Failed to get video snapshot: \(error)");
            })
        }
        return thumb
    }
    
    func getSnapShot() async -> UIImage? {
        guard let asset = self.getCurrentItemAsset()  else { return nil }
        let imageGenerator = self.createAVAssetImageGenerator(asset: asset)
        guard let thumb = await self.getImage(at: self.getCurrentTime(), imageGenerator) else { return nil }
        return UIImage(cgImage: thumb)
    }
}
