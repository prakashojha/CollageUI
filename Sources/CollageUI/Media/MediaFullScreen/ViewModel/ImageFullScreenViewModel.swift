//
//  File.swift
//  
//
//  Created by Saumya Prakash on 28/02/24.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
class ImageFullScreenViewModel: ObservableObject {
 
    @Published var opacity: CGFloat = 1
    @Published var isImageFullScreenRequired: Bool = false
    @Published var isBorderRequired: Bool = false
    
   
    let borderWidth: CGFloat = 2
    
    var coordinator: any AppCoordinatorProtocol
    let model: ImageFullScreenModel
    
    init(model: ImageFullScreenModel, coordinator: any AppCoordinatorProtocol) {
        self.model = model
        self.coordinator = coordinator
    }
    
    var mediaType: UIImage{
        model.image
    }
    
    var animation: Animation {
        coordinator.animation
    }
    
    var viewFrame: CGRect {
        model.viewFrame
    }
    
    func handleTapGesture(){
        isImageFullScreenRequired = false
        isBorderRequired = true
        self.coordinator.onDismissMediaFullScreen()
    }
}
