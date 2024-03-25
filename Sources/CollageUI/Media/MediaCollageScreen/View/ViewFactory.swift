//
//  File.swift
//
//
//  Created by Saumya Prakash on 19/03/24.
//

import SwiftUI

protocol ViewFactoryProtocol {
    
    associatedtype T: View
    @ViewBuilder static func getView(for media: MediaProtocol, _ coordinator: any CollageCoordinatorProtocol) -> T
}

struct ViewFactory: ViewFactoryProtocol {

    static func getView(for media: MediaProtocol, _ coordinator: any CollageCoordinatorProtocol) -> some View {
        
        if let viewModel = ViewModelFactory.getViewModel(media: media, coordinator) {
            
            switch(viewModel){
                
            case let imageViewModel as ImageViewModel:
                ImageView(viewModel: imageViewModel)
                
            case let videoViewModel as VideoViewModel:
                VideoView(viewModel: videoViewModel)
                
            default:
                Text("Unable to render")
            }
        }
        else{
            Text("View Not available")
        }
    }
}
