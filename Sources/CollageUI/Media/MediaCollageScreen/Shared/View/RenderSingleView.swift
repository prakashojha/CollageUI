//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import SwiftUI

struct RenderSingleView: View {
    @EnvironmentObject var coordinator: CollageCoordinator
    
    var body: some View {
        ZStack{
            //let media = coordinator.modelsForViews[0]
            //let _ = debugPrint(coordinator.modelsForViews[0].media.opacity)
            RenderView(coordinator.modelsForViews[0])
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RenderSingleView()
    }
}
