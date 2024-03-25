//
//  File.swift
//  
//
//  Created by Saumya Prakash on 28/02/24.
//

import Foundation
import SwiftUI


final class ImageViewModel: CollageViewModelProtocol {
   
    @MainActor @Published var opacity: CGFloat = 1
    let borderWidth: CGFloat = 2
    
    private var coordinator: any CollageCoordinatorProtocol
    private var model: ImageModel
    
    init(model: ImageModel, coordinator: any CollageCoordinatorProtocol) {
        self.model = .init(model: model)
        self.coordinator = coordinator
        coordinator.collageViewModels[model.id] = self
    }

    var getModelWidth: CGFloat {
        model.width
    }
    
    var getModelHeight: CGFloat {
        model.height
    }
    
    var mediaType: UIImage{
        model.mediaType
    }

    @MainActor
    func handleTapGesture(frameSize: CGRect){
        self.opacity = 0
        self.coordinator.makeMediaFullScreen(self.model, frameSize) {
            self.opacity = 1
        }
    }
}
