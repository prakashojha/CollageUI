//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 22/02/24.
//

import SwiftUI

struct ImageView: View {
    @ObservedObject private var viewModel: ImageViewModel
   
    init(viewModel: ImageViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        GeometryReader { proxy in
            Color.clear.overlay {
                Image(uiImage:  viewModel.mediaType)
                    .resizable()
                    .scaledToFill()
            }
            .border(.white, width: viewModel.borderWidth)
            .clipShape(RoundedRectangle(cornerRadius: 1))
            .contentShape(RoundedRectangle(cornerRadius: 1))
            .onTapGesture {
                viewModel.handleTapGesture(frameSize: proxy.frame(in: .global))
            }
            .opacity(viewModel.opacity)
        }
       // .frame(width: viewModel.getModelWidth)
        .frame(height: viewModel.getModelHeight)
    }
}

//struct RenderImageView_Previews: PreviewProvider {
//    @Namespace static var nameSpace
//    static var previews: some View {
//        let imageModel = ImageModel(mediaType: UIImage(named: "landscape-1")!)
//        ImageView(imageModel)
//    }
//}
