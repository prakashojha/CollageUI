//
//  File.swift
//  
//
//  Created by Saumya Prakash on 1/03/24.
//

import SwiftUI
import AVKit

final class VideoViewModel: CollageViewModelProtocol {
    
    
    private var playerStatusObserver: NSKeyValueObservation?
    
    let borderWidth: CGFloat = 2
    
    private let model: VideoModel
    let coordinator: any CollageCoordinatorProtocol
    
    @MainActor @Published var opacity: CGFloat = 1
    @Published var isPlayerReadyToPlay: Bool = false {
        didSet{
            playerStatusObserver = nil
        }
    }
    
    init(model: VideoModel, coordinator: any CollageCoordinatorProtocol) {
        self.model = .init(model: model)
        self.coordinator = coordinator
        self.coordinator.collageViewModels[model.id] = self
    }
    
    deinit {
        playerStatusObserver = nil
    }

    var videoModel: VideoModel {
        self.model
    }
    
    var animation: Animation {
        coordinator.parentCoordinator!.animation
    }
    
    var getModelWidth: CGFloat {
        self.model.width
    }
    
    var getModelHeight: CGFloat {
        self.model.height
    }
    
    /// Video is played when its' loaded and ready to play. Initial frames may have black background.
    ///  Observer is set and once there is no initial black frames, then video is displayed.
    func setObserver() {
        playerStatusObserver = self.model.mediaHandler.setObserver({ readyToPlay in
            self.isPlayerReadyToPlay = readyToPlay
        })
    }
    
    func playMedia(withMuteOn: Bool) {
        self.model.mediaHandler.playMedia(withMuteOn: withMuteOn)
    }
    
    func pauseMedia() {
        self.model.mediaHandler.pauseMedia()
    }
    
    
    /// Get the snapshot of the video being played. This snapshot is used to perform seamless transition to fullscreen.
    /// - Returns: A tuple containing snapshot image and time
    private func getSnapShotImageAndTime() async -> (UIImage?, CMTime) {
        let snapShotImage: UIImage? =  nil // await videoModel.mediaHandler.getSnapShot()
        let currentTime = self.model.mediaHandler.getCurrentTime()
        let fullScreeModel = ( snapShotImage, currentTime )
        return fullScreeModel
    }
    
    /// Ask the coordinator to make the video fullscreen
    /// Pauses the video, gets the snapshot at current time, sets opacity to 0 after 0.5 seconds before asking coordinator to make view full screen.
    /// Also provides a closure which reset the value of opacity to 1 and play media with mute off.
    /// - Parameter frameSize: frame Size of view on screen
    func handleTapGesture(frameSize: CGRect) {
        Task {
            await MainActor.run(body: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2   , execute: {
                    self.opacity = 0
                })
                self.coordinator.makeMediaFullScreen(self.model, frameSize) {
                    self.opacity = 1
                    self.playMedia(withMuteOn: true)
                }
            })
        }
    }
}
