//
//  ViewModelFactory.swift
//
//
//  Created by Saumya Prakash on 19/03/24.
//

import Foundation

struct ViewModelFactory {
    
    ///  Based on `media` type returns either ImageModel or VideoModel. First try to retrieve model form coordinator., if found returns the same otherwise create one.
    ///   Coordinator stores the models to keep the model's reference. Helps provide the changed data to view when re-rendering.
    /// - Parameters:
    ///   - media: a mode of type` MediaProtocol`
    ///   - coordinator: a coordinator to of type `CollageCoordinatorProtocol`.
    /// - Returns: an ImageModel or VideoModel of type `CollageViewModelProtocol`
    static func getViewModel(media: MediaProtocol, _ coordinator: any CollageCoordinatorProtocol) -> (any CollageViewModelProtocol)? {
        switch(media){
        case let imageModel as ImageModel:
            guard let imageViewModel = coordinator.collageViewModels[imageModel.id] else {
                return ImageViewModel(model: .init(model: imageModel), coordinator: coordinator as! CollageCoordinator)
            }
            return imageViewModel
        case let videoModel as VideoModel:
            let videoViewModel = coordinator.collageViewModels[videoModel.id] ?? VideoViewModel(model: .init(model: videoModel), coordinator: coordinator as! CollageCoordinator)
            return videoViewModel
        default:
            return nil
        }
        
    }

}
