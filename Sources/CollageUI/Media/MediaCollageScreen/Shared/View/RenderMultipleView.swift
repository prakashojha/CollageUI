//
//  SwiftUIView.swift
//
//
//  Created by Saumya Prakash on 20/02/24.
//

import SwiftUI

struct RenderMultipleView: View {
    @EnvironmentObject private var coordinator: CollageCoordinator
   
    @ViewBuilder
    func renderLandScapeTop(models: [MediaProtocol]) -> some View{
        let topImageModel = models[0]
        let hStackImageModels = Array(models[1...])
        
        VStack(spacing:0){
            RenderView(topImageModel)
                .transition(.scale(scale: 1))
            
            HStack(spacing:0){
                ForEach(hStackImageModels, id: \.id){ model in
                    RenderView(model)
                        .transition(.scale(scale: 1))
                }
            }
            .transition(.scale(scale: 1))
        }
        .transition(.scale(scale: 1))
    }
    
    @ViewBuilder
    func renderPortraitLeft(models: [MediaProtocol]) -> some View{
        let leftImageModel = models[0]
        let vStackImageModels = Array(models[1...])
        HStack(alignment: .center, spacing:0){
            RenderView(leftImageModel)
                .transition(.scale(scale: 1))
            VStack(alignment: .center, spacing:0){
                ForEach(vStackImageModels, id: \.id){ model in
                    RenderView(model /*, viewModel: viewModel, viewModelIndex: viewModelIndex */)
                        .transition(.scale(scale: 1))
                }
            }
        }
        // .padding()
    }
    
    @ViewBuilder
    func remainingImages(count: Int) -> some View{
        Text("+\(count)")
            .font(.custom("AvenirNext-Bold", size: 32))
            .foregroundStyle(Color.white)
        
    }
    
    var body: some View {
       
        let imageCount = coordinator.photPickerItemsFromMediaLibrary.count
        let extraImageCount = imageCount - 4
        let imageModels = coordinator.modelsForViews
        
        ZStack(alignment: .bottomTrailing){
            let orientation = imageModels[0].orientation
            switch(orientation){
            case .Landscape:
                renderLandScapeTop(models: imageModels)
                    .transition(.scale(scale: 1))
            case .Portrait:
                renderPortraitLeft(models: imageModels)
                    .transition(.scale(scale: 1))
            }
            if extraImageCount > 0{
                remainingImages(count: extraImageCount)
                    .frame(width: imageModels.last!.width , height: imageModels.last!.height)
                    .allowsHitTesting(false)
            }
        }
    }
    
}

struct RenderMultipleView_Previews: PreviewProvider {
    @Namespace static var nameSpace
    static var previews: some View {
        RenderMultipleView()
    }
}
