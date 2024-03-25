//
//  File.swift
//  
//
//  Created by Saumya Prakash on 28/02/24.
//

import Foundation
import SwiftUI
import AVKit


public final class AppCoordinator: AppCoordinatorProtocol, ObservableObject{
   
    @Published var allowHitTesting: Bool = true
    @Published public var isMediaFullScreenRequired: Bool = false
   
    var fullScreenView: RenderFullScreenView? = nil
    
    let animationDuration: Double = 0.825
    let animation: Animation = .spring(response: 0.5, dampingFraction: 0.825, blendDuration: 0)
    var onFullScreenDismiss: (()->Void)?

    
    public init() {}
    

    @MainActor
    func makeMediaFullScreen(_ media: MediaProtocol, _ initialFrameSize: CGRect, _ onFullScreenDismiss: (() -> Void)?) {
        allowHitTesting = false
        self.onFullScreenDismiss = onFullScreenDismiss
        self.fullScreenView =  RenderFullScreenView(media, frameSize: initialFrameSize, coordinator: self)
        isMediaFullScreenRequired = true
    }
    
    @MainActor
    func onDismissMediaFullScreen() {
        self.fullScreenView = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
            self.isMediaFullScreenRequired = false
            self.onFullScreenDismiss?()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration + 0.15, execute: {
            self.allowHitTesting = true
        })
        
    }
    
    @ViewBuilder
    public func renderFullScreen() -> some View {
        if let fullScreenView = self.fullScreenView {
            fullScreenView
        }
        else {
            Text("Full screen not available")
        }
    }
}
