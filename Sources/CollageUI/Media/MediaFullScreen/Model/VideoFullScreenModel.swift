//
//  File.swift
//  
//
//  Created by Saumya Prakash on 21/02/24.
//

import Foundation
import SwiftUI
import AVKit

struct VideoFullScreenModel {
    let model: VideoModel
    var viewFrame: CGRect
    var snapShotImage: UIImage
    var snapShotTime: CMTime
   
    init(_ model: VideoModel, _ viewFrame: CGRect, _ snapShotImage: UIImage, _ snapShotTime: CMTime) {
        self.model = model
        self.viewFrame = viewFrame
        self.snapShotImage = snapShotImage
        self.snapShotTime = snapShotTime
    }
    
}
