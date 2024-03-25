//
//  File.swift
//
//
//  Created by Saumya Prakash on 5/03/24.
//

import Foundation
import SwiftUI


public protocol MediaProtocol {
    var id: UUID { get set }
    var orientation: Orientation { get set }
    var width: CGFloat { get set}
    var height: CGFloat { get set }
    var opacity: CGFloat { get set }

    
//    init(mediaType: MediaType)
//    init(model: Self)
//    init(model: Self, newWidth: CGFloat, newHeight: CGFloat)
}
