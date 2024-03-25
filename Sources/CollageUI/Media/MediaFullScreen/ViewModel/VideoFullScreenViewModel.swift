//
//  File.swift
//  
//
//  Created by Saumya Prakash on 29/02/24.
//

import Foundation
import SwiftUI
import AVKit

class VideoFullScreenViewModel: ObservableObject {
    
    @Published var isBorderRequired: Bool = false
    private var playerStatusObserver: NSKeyValueObservation?
    private let borderWidth: CGFloat = 2
    
    @Published var isPlayerReadyToPlay: Bool = false {
        didSet{
            playerStatusObserver = nil
        }
    }
    
   // var videoPlayerController: VideoPlayerController
    var coordinator: any AppCoordinatorProtocol
    let model: VideoFullScreenModel
    
    init(model: VideoFullScreenModel, coordinator: any AppCoordinatorProtocol) {
        self.model = model
        self.coordinator = coordinator
       // self.videoPlayerController = VideoPlayerController(mediaHandler: model.model.mediaHandler, showPlayBackControls: true)
        self.model.model.mediaHandler.seek(to: model.snapShotTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    deinit {
        playerStatusObserver = nil
    }

    var getBorderWidth: CGFloat {
        return self.borderWidth
    }
    
    var animation: Animation {
        coordinator.animation
    }
    
    var snapShotImage: UIImage {
        self.model.snapShotImage
    }
    
    var snapShotTime: CMTime {
        self.model.snapShotTime
    }
    
    var viewFrame: CGRect {
        model.viewFrame
    }
    
    var videoModel: VideoModel {
        return self.model.model
    }
    
    var scale: CGFloat {
        self.videoModel.scale
    }
    
    func playMedia(isMuted: Bool) {
        self.videoModel.mediaHandler.playMedia(withMuteOn: isMuted)
    }
    
    func pauseMedia() {
        self.videoModel.mediaHandler.pauseMedia()
    }
    
    func setObserver() {
        playerStatusObserver = self.videoModel.mediaHandler.setObserver({ readyToPlay in
            self.isPlayerReadyToPlay = readyToPlay
        })
    }
    
    
    
    func handleTapGesture(){
        //self.videoPlayerController.showPlayBackControls = false
       // self.pauseMedia()
        isBorderRequired = true
        self.coordinator.onDismissMediaFullScreen()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.825, execute: {
            self.isBorderRequired = false
        })
        
    }
}
