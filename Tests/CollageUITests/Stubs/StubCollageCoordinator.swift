//
//  StubCollageCoordinator.swift
//  
//
//  Created by Saumya Prakash on 20/03/24.
//

import XCTest
@testable import CollageUI

class StubCollageCoordinator: CollageCoordinatorProtocol {
    
    var makeMediaFullScreenCount = 0
    var content: Any?
    
    var collageViewModels: [UUID : any CollageViewModelProtocol] = [:]
    var parentCoordinator: (AppCoordinatorProtocol)? = nil
    
    func makeMediaFullScreen(_ media: MediaProtocol, _ initialFrameSize: CGRect, _ onFullScreenDismiss: (() -> Void)?) {
        makeMediaFullScreenCount += 1
        print("makeMediaFullScreenCount", makeMediaFullScreenCount)
        onFullScreenDismiss?()
    }
}
