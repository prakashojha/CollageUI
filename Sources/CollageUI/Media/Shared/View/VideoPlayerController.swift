//
//  File.swift
//  
//
//  Created by Saumya Prakash on 27/02/24.
//

import Foundation
import AVKit
import SwiftUI

struct VideoPlayerController: UIViewControllerRepresentable {
    let videoModel: VideoModel
    @Binding var showPlayBackControls: Bool
    
    init(videoModel: VideoModel, showPlayBackControls: Binding<Bool>) {
        self.videoModel = videoModel
        self._showPlayBackControls = showPlayBackControls
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = videoModel.mediaHandler.player
        controller.showsPlaybackControls = showPlayBackControls
        controller.videoGravity = .resizeAspectFill
        controller.view.backgroundColor = .clear
    
    
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(VideoPlayerCoordinator.videoDidEnded),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: videoModel.mediaHandler.player.currentItem)
                
        return controller
    }
    
    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        controller.showsPlaybackControls = showPlayBackControls
    }
    
    func makeCoordinator() -> VideoPlayerCoordinator {
        VideoPlayerCoordinator(parent: self)
    }
    
}

class VideoPlayerCoordinator {
    
    let parent: VideoPlayerController
    
    init(parent: VideoPlayerController) {
        self.parent = parent
    }
    
    @objc func videoDidEnded(){
        parent.videoModel.mediaHandler.player.seek(to: CMTime.zero)
    }
}
