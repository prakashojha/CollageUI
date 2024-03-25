//
//  SwiftUIView.swift
//
//
//  Created by Saumya Prakash on 23/02/24.
//

import SwiftUI
import AVKit

struct VideoFullScreenView: View {
    
    @State var isVideoFullScreenRequired: Bool = false
    @State var changeBackgroundColor: Bool = false
    @State var showPlayBackControls: Bool = true
    
    var videoModel: VideoModel
    var frameSize: CGRect
    var coordinator: AppCoordinatorProtocol
    
    init(videoModel: VideoModel, frameSize: CGRect, coordinator: AppCoordinatorProtocol){
        self.videoModel = videoModel
        self.frameSize = frameSize
        self.coordinator = coordinator
    }
    
    var body: some View {
        
        GeometryReader { geo in
            let posX = frameSize.minX + frameSize.width/2
            let posY = frameSize.minY + frameSize.height/2 - geo.safeAreaInsets.top
            let midPoint = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            
            Color.clear.overlay {
                VideoPlayerController(videoModel: videoModel, showPlayBackControls: $showPlayBackControls)
            }
            .border(isVideoFullScreenRequired ? .clear : .white, width: 2)
            .frame(maxWidth: isVideoFullScreenRequired ? .infinity : videoModel.width,
                   maxHeight: isVideoFullScreenRequired ? .infinity : videoModel.height)
            .clipped()
            .position(x: isVideoFullScreenRequired ? midPoint.x : posX,
                      y: isVideoFullScreenRequired ? midPoint.y : posY)
            .aspectRatio(videoModel.scale, contentMode: .fit)
            .transition(.scale(scale: 1))
            
       }
        .animation(.spring(response: 0.5, dampingFraction: 0.825, blendDuration: 0), value: isVideoFullScreenRequired)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                changeBackgroundColor = true
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.825, execute: {
                videoModel.mediaHandler.playMedia(withMuteOn: false)
            })
           
            isVideoFullScreenRequired = true
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isVideoFullScreenRequired = false
                    changeBackgroundColor = false
                    showPlayBackControls = false
                    videoModel.mediaHandler.playMedia(withMuteOn: true)
                    coordinator.onDismissMediaFullScreen()
                } label: {
                    Image(systemName: "multiply")
                }

            }
        })
        .background(changeBackgroundColor ? Color.black : Color.clear)
    }
}

//struct RenderExtendedVideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        RenderExtendedVideoView(nameSpace: <#Namespace.ID#>, coordinator: <#CollageCoordinator#>)
//    }
//}
