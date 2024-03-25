//
//  File.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import Foundation
import SwiftUI
import AVKit
import PhotosUI

class CollageCoordinator: CollageCoordinatorProtocol, ObservableObject {
    
    
    
    let gm: GenerateModel
    let photoPickerItemHandler: PhotosPickerItemHandler
    
    init(generateModel: GenerateModel, photoPickerItemHandler: PhotosPickerItemHandler) {
        self.gm = generateModel
        self.photoPickerItemHandler = photoPickerItemHandler
    }
    /// Constant values
    let refWidth: CGFloat = UIScreen.main.bounds.width
    
    /// Properties coming from Coordinator Protocol
    var parentCoordinator: (any AppCoordinatorProtocol)?
    
    var collageViewModels: [UUID: any CollageViewModelProtocol] = [:]
    
    
    /// Keeps models for the views inside one array.
    /// This will prevent re-rendering of view when moved to full screen and coming back
    @Published var modelsForViews: [any MediaProtocol] = []
    
    @Published var pauseWhenEnteringFullScreen: Bool = false
    
    
    /// Called by view when FullScreen view is dismissed. Used to control opacity of image
    var onFullScreenViewDismissed: (() -> Void)?
    
    
    var photPickerItemsFromMediaLibrary: [PhotosPickerItem] = [] {
        didSet {
            Task {
                // convert from items photosPickerItem to MediaProtocol models.
                let mediaModels: [MediaProtocol] = await photoPickerItemHandler.generateMedias(from: photPickerItemsFromMediaLibrary)
                // models to be used by View
                await MainActor.run(body: {
                    self.mediaModels = mediaModels
                })
                
            }
        }
    }
    
    var mediaModels: [MediaProtocol] = [] {
        didSet {
            Task {
                let models: [MediaProtocol] = await gm.prepareModelsForView(mediaModels, refWidth: refWidth)
                await MainActor.run {
                    self.modelsForViews = models
                }
            }
        }
    }
    
    func generateModelsFrom(_ models: [Model]) {
        Task {
            let medias = await photoPickerItemHandler.generateMedias(from: models)
            await MainActor.run {
                self.mediaModels = medias
            }
        }
    }
    
    private func pauseAllVideosWhenGoingFullScreen(id: UUID, _ pauseStatus: Bool){
        for viewModel in collageViewModels.values {
            if viewModel is VideoViewModel {
                if pauseStatus {
                    if (viewModel as! VideoViewModel).videoModel.id != id {
                        (viewModel as! VideoViewModel).pauseMedia()
                    }
                }
                else{
                    (viewModel as! VideoViewModel).playMedia(withMuteOn: true)
                }
            }
        }
    }
    
    @MainActor
    func makeMediaFullScreen(_ media: any MediaProtocol, _ initialFrameSize: CGRect, _ onFullScreenDismiss: (() -> Void)?) {
        guard let parentCoordinator = parentCoordinator else { return }
        self.onFullScreenViewDismissed = onFullScreenDismiss
        
        Task {
            self.pauseAllVideosWhenGoingFullScreen(id: media.id, true)
        }

        parentCoordinator.makeMediaFullScreen(media, initialFrameSize) { [weak self] in
            self?.onFullScreenViewDismissed?()
            self?.pauseAllVideosWhenGoingFullScreen(id: media.id, false)
        }
    }
}

