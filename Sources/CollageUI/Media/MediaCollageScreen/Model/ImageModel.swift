//
//  File.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import Foundation
import SwiftUI

/// A model to represent an Image
struct ImageModel: MediaProtocol{
    var mediaType: UIImage
    var id: UUID
    var orientation: Orientation
    var width: CGFloat
    var height: CGFloat
    var opacity: CGFloat
    
    init(mediaType: UIImage, id: UUID, orientation: Orientation, width: CGFloat, height: CGFloat, opacity: CGFloat) {
        self.mediaType = mediaType
        self.id = id
        self.orientation = orientation
        self.width = width
        self.height = height
        self.opacity = opacity
    }
}

extension ImageModel {
    init(model: ImageModel){
        self.id = model.id
        self.mediaType = model.mediaType
        self.orientation = model.orientation
        self.width = model.width
        self.height = model.height
        self.opacity = model.opacity
    }
    
    init(mediaType: UIImage){
        self.id = UUID()
        self.mediaType = mediaType
        self.orientation = mediaType.size.width > mediaType.size.height ? .Landscape : .Portrait
        self.width = mediaType.size.width
        self.height = mediaType.size.height
        self.opacity = 1
    }
    
    init(model: ImageModel, newWidth: CGFloat, newHeight: CGFloat){
        self.id = model.id
        self.mediaType = model.mediaType
        self.orientation = model.orientation
        self.width = newWidth
        self.height = newHeight
        self.opacity = model.opacity
    }
    
    
}
