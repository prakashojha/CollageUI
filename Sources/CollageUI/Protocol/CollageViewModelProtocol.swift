//
//  File.swift
//  
//
//  Created by Saumya Prakash on 4/03/24.
//

import Foundation
import SwiftUI

protocol CollageViewModelProtocol: ObservableObject {
    associatedtype ModelType: MediaProtocol
    init(model: ModelType, coordinator: any CollageCoordinatorProtocol)
    func handleTapGesture(frameSize: CGRect)
    var getModelWidth:  CGFloat { get }
    var getModelHeight: CGFloat { get }
}
