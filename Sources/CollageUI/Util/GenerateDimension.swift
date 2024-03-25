//
//  File.swift
//  
//
//  Created by Saumya Prakash on 5/03/24.
//

import Foundation

struct GenerateDimension {
    typealias T = any MediaProtocol
    
    func getScale(media: T) -> CGFloat{
        let width = media.width
        let height = media.height
        
        return width / height
    }
    
    func getDimension(for media: T, refWidth: CGFloat) async -> (CGFloat, CGFloat) {
        let scale = getScale(media: media)
        let width = refWidth
        let height = width / scale
        
        return (width, height)
    }
    
    func getDimension(_ media1: T, _ media2: T, refWidth: CGFloat) async -> (CGFloat, CGFloat, CGFloat) {
        let S1 = getScale(media: media1)
        let S2 = getScale(media: media2)
        let height = refWidth / (S1 + S2)
        let image1Width = height * S1
        let image2Width = height * S2
        
        return (image1Width, image2Width, height)
    }
    
    func getPortraitDimension(leftMedia: T, rightMedias: [T],  refWidth: CGFloat) async -> (CGFloat, CGFloat) {
        let leftMediaScale: CGFloat =  getScale(media: leftMedia)
        let rightMediasScale = rightMedias.map { getScale(media: $0) }
        let sumOfInverseOfScale = rightMediasScale.reduce(0){ partialResult, rightMediaScale in
            partialResult + (1 / rightMediaScale)
        }
        
        let numerator = leftMediaScale * refWidth * sumOfInverseOfScale
        let denominator = 1 + ( leftMediaScale * sumOfInverseOfScale )
        
        let leftMediaWidth = numerator / denominator
        let rightMediasWidth = refWidth - leftMediaWidth
        
        let leftMediaHeight = rightMediasScale.reduce(0) { partialResult, rightMediaScale in
            partialResult + (rightMediasWidth / rightMediaScale)
        }
        
        return (leftMediaWidth, leftMediaHeight)
    }
    
    func getLandscapeDimension(topMedia: T, bottomMedias: [T],  refWidth: CGFloat) async -> (CGFloat, CGFloat){
        let bottomMediaScales = bottomMedias.map { getScale(media: $0) }
        let sumOfScales = bottomMediaScales.reduce(0) { partialResult, bottomMediaScale in
            partialResult + bottomMediaScale
        }
        
        let topMediaHeight = await getDimension(for: topMedia, refWidth: refWidth).1
        let bottomMediaHeight = refWidth / sumOfScales
        
        return (topMediaHeight, bottomMediaHeight)
    }
}
