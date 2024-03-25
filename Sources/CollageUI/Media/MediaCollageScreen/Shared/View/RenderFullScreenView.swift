//
//  SwiftUIView.swift
//
//
//  Created by Saumya Prakash on 22/02/24.
//

import SwiftUI

struct RenderFullScreenView: View {
    
    let media: any MediaProtocol
    let frameSize: CGRect
    let coordinator: AppCoordinatorProtocol
    
    init(_ media: any MediaProtocol, frameSize: CGRect, coordinator: AppCoordinatorProtocol) {
        self.media = media
        self.frameSize = frameSize
        self.coordinator = coordinator
    }
    
    var body: some View {
      
        VStack {
            FullScreenViewFactory.getFullScreenView(for: media, frameSize: frameSize, coordinator)
        }
    }
}

//struct RenderFullScreenView_Previews: PreviewProvider {
//    @Namespace static var collageNameSpace
//    static var previews: some View {
//        RenderFullScreenView()
//    }
//}
