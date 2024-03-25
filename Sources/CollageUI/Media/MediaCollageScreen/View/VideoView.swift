//
//  SwiftUIView.swift
//
//
//  Created by Saumya Prakash on 22/02/24.
//

import SwiftUI
import AVKit

struct VideoView: View {
    @StateObject private var viewModel: VideoViewModel
    @State private var isPlayerLoaded: Bool = false
    
    // MARK: Test
    @State private var setZIndex: Bool = false
    
    init(viewModel: VideoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        
        GeometryReader { proxy in
            Color.clear.overlay {
                VideoPlayerController(videoModel: self.viewModel.videoModel, showPlayBackControls: .constant(false))
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 4, trailing: 0))
                    }
                if !isPlayerLoaded {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: viewModel.getModelWidth, height: viewModel.getModelHeight)
                        .background(.mint)
                }
            }
            .zIndex(setZIndex ? 5 : 1)
            .onTapGesture {
                setZIndex = true
                let frameSize = proxy.frame(in: .global)
               // (viewModel.coordinator.parentCoordinator as! AppCoordinator).view = self
                viewModel.handleTapGesture(frameSize: frameSize )
            }
            .onAppear{
                viewModel.setObserver()
            }
        }
        .onChange(of: viewModel.isPlayerReadyToPlay, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
                isPlayerLoaded = newValue
                viewModel.playMedia(withMuteOn: true)

            })
        })
        .border(.white, width: viewModel.borderWidth)
        .clipShape(RoundedRectangle(cornerRadius: 1))
        .contentShape(RoundedRectangle(cornerRadius: 1))
        
        .opacity(viewModel.opacity)
        
        .frame(width: viewModel.getModelWidth)
        .frame(height: viewModel.getModelHeight)
        
    }
    
}

//struct RenderVideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        let imageModel = ImageModel(media: UIImage(named: "landscape-1")!)
//        RenderVideoView(Videom)
//    }
//}
