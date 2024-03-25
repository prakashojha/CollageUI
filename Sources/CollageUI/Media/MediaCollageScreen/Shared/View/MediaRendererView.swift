//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 28/02/24.
//

import SwiftUI

struct MediaRendererView: View {
   
    let modelsCount: Int
    
    init(_ modelsCount: Int) {
        self.modelsCount = modelsCount
    }
    
    var body: some View {
        VStack{
            switch(modelsCount){
            case 1:
                RenderSingleView()
                    .transition(.scale(scale: 1))
            case 2:
                RenderTwoView()
                    .transition(.scale(scale: 1))
            default:
                RenderMultipleView()
                    .transition(.scale(scale: 1))
            }
        }
       // .opacity(collageCoordinator.pauseWhenEnteringFullScreen ? 0.5 : 1)
       // .allowsHitTesting(appCoordinator.allowHitTesting)
    }
}

struct MediaRendererView_Previews: PreviewProvider {
    static var previews: some View {
        MediaRendererView(4)
    }
}
