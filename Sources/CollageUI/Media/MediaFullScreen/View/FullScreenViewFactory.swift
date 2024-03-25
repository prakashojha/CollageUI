//
//  FullScreenViewFactory.swift
//  
//
//  Created by Saumya Prakash on 25/03/24.
//

import SwiftUI

import SwiftUI

protocol FullScreenViewFactoryProtocol {
    
    associatedtype T: View
    @ViewBuilder
    static func getFullScreenView(for media: MediaProtocol, frameSize: CGRect, _ coordinator: any AppCoordinatorProtocol) -> T
}

struct FullScreenViewFactory: FullScreenViewFactoryProtocol {
    
    static func getFullScreenView(for media: MediaProtocol, frameSize: CGRect, _ coordinator: any AppCoordinatorProtocol) -> some View {
        
        switch(media){
            
        case let imageModel as ImageModel:
            ImageFullScreenView(imageModel: imageModel, frameSize: frameSize, coordinator: coordinator)
            
        case let videoModel as VideoModel:
            VideoFullScreenView(videoModel: videoModel, frameSize: frameSize, coordinator: coordinator)
            
        default:
            Text("Unable to render")
        }
    }
}


//struct FullScreenViewFactory_Previews: PreviewProvider {
//    static var previews: some View {
//        return FullScreenViewFactory()
//    }
//}
