//
//  File.swift
//  
//
//  Created by Saumya Prakash on 28/02/24.
//

import Foundation
import SwiftUI

protocol AppCoordinatorProtocol {
    var animationDuration: Double { get }
    var animation: Animation { get }
    func makeMediaFullScreen(_ : MediaProtocol, _ : CGRect, _ : (() -> Void)?)
    func onDismissMediaFullScreen()
}

protocol CollageCoordinatorProtocol: ObservableObject {
    var collageViewModels: [UUID: any CollageViewModelProtocol] { get set }
    var parentCoordinator: (any AppCoordinatorProtocol)? { get set }
    func makeMediaFullScreen(_ media: any MediaProtocol, _ initialFrameSize: CGRect, _ onFullScreenDismiss: (()->Void)?)
}

