//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import SwiftUI

struct RenderView: View {
    @EnvironmentObject private var coordinator: CollageCoordinator
    
    let media: any MediaProtocol
    
    init(_ media: any MediaProtocol) {
        self.media = media
    }
    
    var body: some View {
      
        VStack {
            ViewFactory.getView(for: media, coordinator)
        }
    }
}

//struct CollageRenderView_Previews: PreviewProvider {
//    @Namespace static var nameSpace
//    static var previews: some View {
//        let model = Media(media: ImageModel(mediaType: UIImage(named: "landscape-1")!))
//        RenderView(model: model)
//    }
//}
