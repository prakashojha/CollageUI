//
//  File.swift
//  
//
//  Created by Saumya Prakash on 20/02/24.
//

import Foundation
import SwiftUI

struct ImageFullScreenModel {
    var image: UIImage
    var viewFrame: CGRect
    
    init(_ image: UIImage, viewFrame: CGRect) {
        self.image = image
        self.viewFrame = viewFrame
    }
}
