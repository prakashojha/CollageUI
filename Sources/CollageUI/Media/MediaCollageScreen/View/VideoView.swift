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
    
    init(viewModel: VideoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        GeometryReader { proxy in
            Color.clear.overlay {
                // A UIViewControllerRepresentable view. Used to handle controls for AVPlayer.
                VideoPlayerController(videoModel: self.viewModel.videoModel, showPlayBackControls: .constant(false))
                    .overlay(alignment: .bottomLeading) {
                        Image(systemName: "video.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 4, bottom: 4, trailing: 0))
                    }
                // Show progress View if video is not loaded/ready to play.
                if !isPlayerLoaded {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: viewModel.getModelWidth, height: viewModel.getModelHeight)
                        .background(.mint)
                }
            }
            .onTapGesture {
                // get the media/frame size in respect to screen (global).
                let frameSize = proxy.frame(in: .global)
                viewModel.handleTapGesture(frameSize: frameSize )
            }
            .onAppear{
                viewModel.setObserver()
            }
        }
        // check if video is available and first frame is ready.
        // Video is delayed played to make sure no blank screen appears when video starts to play.
        // Vide is muted when not in full screen mode.
        .onChange(of: viewModel.isPlayerReadyToPlay, perform: { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
                isPlayerLoaded = newValue
                viewModel.playMedia(withMuteOn: true)
            })
        })
        // border provides clear partition between two media items
        .border(.white, width: viewModel.borderWidth)
        // clipped to present media/video in given frame
        .clipShape(RoundedRectangle(cornerRadius: 1))
        // Bound the tap gesture in the clipped frame
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
