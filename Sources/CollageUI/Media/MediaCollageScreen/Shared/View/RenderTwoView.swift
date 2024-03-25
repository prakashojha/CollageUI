//
//  SwiftUIView.swift
//
//
//  Created by Saumya Prakash on 20/02/24.
//

import SwiftUI

struct RenderTwoView: View {
    @EnvironmentObject var coordinator: CollageCoordinator

    var body: some View {
        let imageModels = coordinator.modelsForViews
        let orientation1 = imageModels[0].orientation
        let orientation2 = imageModels[1].orientation
//        let orientation1 = imageModels[0].mediaModel.orientation
//        let orientation2 = imageModels[1].mediaModel.orientation
        
       // let _ = debugPrint("RenderTwoView" , imageModels[0].media, imageModels[1].media)

        ZStack{
            switch(orientation1, orientation2){
            case (.Landscape, .Landscape):
                VStack(spacing:1){
                    RenderView(imageModels[0])
                    RenderView(imageModels[1])
                }
            case (_, _):
                HStack(spacing:1){
                    RenderView(imageModels[0])
                    RenderView( imageModels[1])
                }
            }
        }
    }

}

struct RenderTwoView_Previews: PreviewProvider {
    @Namespace static var nameSpace
    static var previews: some View {
        RenderTwoView()
    }
}
