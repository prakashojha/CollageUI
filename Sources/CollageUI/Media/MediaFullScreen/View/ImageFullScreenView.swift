//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import SwiftUI

struct ImageFullScreenView: View {
    
    @State var isFullScreenRequired: Bool = false
    @State var changeBackgroundColor: Bool = false
    
    var imageModel: ImageModel
    var frameSize: CGRect
    var coordinator: AppCoordinatorProtocol
    
    init(imageModel: ImageModel, frameSize: CGRect, coordinator: AppCoordinatorProtocol){
        self.imageModel = imageModel
        self.frameSize = frameSize
        self.coordinator = coordinator
    }
    
    var body: some View {
        let scale = imageModel.mediaType.size.width / imageModel.mediaType.size.height
        
        GeometryReader { geo in
            let posX = frameSize.minX + frameSize.width/2
            let posY = frameSize.minY + frameSize.height/2 - geo.safeAreaInsets.top
            let midPoint = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
            
            Color.clear.overlay {
                Image(uiImage:  imageModel.mediaType)
                    .resizable()
                    .scaledToFill()
            }
            .border(isFullScreenRequired ? .clear : .white, width: 2)
            .frame(maxWidth: isFullScreenRequired ? .infinity : imageModel.width,
                   maxHeight: isFullScreenRequired ? .infinity : imageModel.height)
            .clipped()
            .position(x: isFullScreenRequired ? midPoint.x : posX,
                      y: isFullScreenRequired ? midPoint.y : posY)
            .aspectRatio(scale, contentMode: .fit)
            .transition(.scale(scale: 1))
            
       }
        .animation(.spring(response: 0.5, dampingFraction: 0.825, blendDuration: 0), value: isFullScreenRequired)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                changeBackgroundColor = true
            })
            isFullScreenRequired = true
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isFullScreenRequired = false
                    changeBackgroundColor = false
                    coordinator.onDismissMediaFullScreen()
                } label: {
                    Image(systemName: "multiply")
                }

            }
        })
        .background(changeBackgroundColor ? Color.black : Color.clear)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
//    @ObservedObject  var viewModel: ImageFullScreenViewModel
//
//    init(viewModel: ImageFullScreenViewModel) {
//        self.viewModel = viewModel
//    }
//
//    public var body: some View {
//        let model = viewModel.model
//        let scale = model.image.size.width / model.image.size.height
//
//
//        GeometryReader { geo in
//            let posX = viewModel.viewFrame.minX + viewModel.viewFrame.width/2
//            let posY = viewModel.viewFrame.minY + viewModel.viewFrame.height/2 - geo.safeAreaInsets.top
//            let midPoint = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
//            Color.clear.overlay {
//                Image(uiImage:  model.image)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(maxWidth: viewModel.isImageFullScreenRequired ? .infinity : viewModel.viewFrame.width,
//                           maxHeight: viewModel.isImageFullScreenRequired ? .infinity : viewModel.viewFrame.height)
//
//                    .clipped()
//                    .border(viewModel.isBorderRequired ? .white: .clear, width: viewModel.borderWidth)
//
//
//            }
//            .position(x: viewModel.isImageFullScreenRequired ? midPoint.x : posX,
//                      y: viewModel.isImageFullScreenRequired ? midPoint.y : posY)
//            .zIndex(2)
//            .aspectRatio(scale, contentMode: .fit)
//            .transition(.scale(scale: 1))
//            .onAppear(perform: {
//                viewModel.isImageFullScreenRequired = true
//            })
//            .animation(viewModel.animation, value: viewModel.isImageFullScreenRequired)
//        }
//
//        .toolbar(content: {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    viewModel.handleTapGesture()
//                } label: {
//                    if viewModel.isImageFullScreenRequired {
//                        Image(systemName: "multiply")
//                    }
//                    else{
//                        EmptyView()
//                    }
//
//                }
//
//            }
//        })
//        .background(viewModel.isImageFullScreenRequired ? Color.black : Color.clear)
    //}
}

//struct CollageExtendedUI_Previews: PreviewProvider {
//    @Namespace static var collageNameSpace
//    static var previews: some View {
//        NavigationStack {
//            ImageFullScreenView(viewModel: ImageFullScreenViewModel(model: ImageFullScreenModel(mediaType: UIImage(named: "landscape1")!), coordinator: CollageCoordinator()))
//        }
//    }
//}
