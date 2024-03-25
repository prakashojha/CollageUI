//
//  File.swift
//  
//
//  Created by Saumya Prakash on 5/03/24.
//

import Foundation

struct GenerateModel {
    
    typealias input = any MediaProtocol
    typealias output = any MediaProtocol
    
    private let generateDimension: GenerateDimension
    static let shared = GenerateModel()
    private init() {
        self.generateDimension = GenerateDimension()
    }
    
    func prepareModelsForView(_ models: [input], refWidth: CGFloat) async -> [output]{
        let imageCount = models.count
        var outputModels: [output] = []
        switch(imageCount){
        case 0:
            outputModels = []
        case 1:
            let model = await prepareSingleModelForView(from: models[0], refWidth: refWidth)
            outputModels.append(model)
        case 2:
            outputModels = await prepareDoubleModelsForView(from: models[0], and: models[1], refWidth: refWidth)
        default:
            outputModels = await prepareMultipleModelsForView(from: models, refWidth: refWidth)
        }
        
        return outputModels
    }
    
    private func prepareSingleModelForView(from model: input, refWidth: CGFloat) async -> output {
        let dimensions = await generateDimension.getDimension(for: model , refWidth: refWidth)
        let width = dimensions.0
        let height = dimensions.1
        
        return prepareModel(media: model, newWidth: width, newHeight: height)
    }
    
    private func prepareDoubleModelsForView(from model1: input, and model2: input, refWidth: CGFloat) async -> [output]{
        var newModel1: output
        var newModel2: output

        let orient1: Orientation = model1.orientation
        let orient2: Orientation = model2.orientation

        switch(orient1, orient2){
        case(.Landscape, .Landscape):
            newModel1 = await prepareSingleModelForView(from: model1, refWidth: refWidth)
            newModel2 = await prepareSingleModelForView(from: model2, refWidth: refWidth)

        default:
            let dim = await generateDimension.getDimension(model1, model2, refWidth: refWidth)
            let image1Width = dim.0, image2Width = dim.1, height = dim.2
            newModel1 = prepareModel(media: model1, newWidth: image1Width, newHeight: height)
            newModel2 = prepareModel(media: model2, newWidth: image2Width, newHeight: height)
        }
        return [newModel1, newModel2]
    }
    
    private func prepareMultipleModelsForView(from models: [input], refWidth: CGFloat) async -> [output]{
        var outputModels: [output] = []
        let modelCount: Int = models.count
        let firstModel: input = models[0]
        let otherModels: [input] = modelCount > 3 ? Array(models[1...3]) : Array(models[1...])
        
        let orient: Orientation = firstModel.orientation
        var dim: (CGFloat, CGFloat) = (0, 0)
        
        switch(orient){
        case .Landscape:
            dim = await generateDimension.getLandscapeDimension(topMedia: firstModel,
                                                                bottomMedias: otherModels,
                                                                refWidth: refWidth)
            outputModels = await prepareLandScapeModels(topModel: firstModel,
                                                        bottomModels: otherModels,
                                                        topWidth: refWidth,
                                                        topHeight: dim.0,
                                                        bottomHeight: dim.1)
        case .Portrait:
            dim = await generateDimension.getPortraitDimension(leftMedia: firstModel,
                                                               rightMedias: otherModels,
                                                               refWidth: refWidth)
            outputModels = await preparePortraitModels(leftModel: firstModel,
                                                       rightModels: otherModels,
                                                       leftWidth: dim.0,
                                                       leftHeight: dim.1,
                                                       refWidth: refWidth)
        }
        
        return outputModels
    }
    
    private func prepareLandScapeModels(topModel: input, bottomModels: [input], topWidth: CGFloat, topHeight: CGFloat, bottomHeight: CGFloat) async -> [output] {
        var models: [output] = []
        let bottomModelCount: CGFloat = CGFloat(bottomModels.count)
        let topImageModel = prepareModel(media: topModel, newWidth: topWidth, newHeight: topHeight)
        models.append(topImageModel)
        for model in bottomModels{
            let width = topWidth / bottomModelCount
            let height = bottomHeight
            let newModel = prepareModel(media: model, newWidth: width, newHeight: height)
            models.append(newModel)
        }
        
        return models
    }
    
    private func preparePortraitModels(leftModel: input, rightModels: [input], leftWidth: CGFloat, leftHeight: CGFloat, refWidth: CGFloat) async -> [output]{
        var models: [output] = []
        let rightModelCount: CGFloat = CGFloat(rightModels.count)
        let newLeftModel: output = prepareModel(media: leftModel, newWidth: leftWidth, newHeight: leftHeight)
        models.append(newLeftModel)
        for model in rightModels{
            let width = refWidth - leftWidth
            let height = leftHeight / rightModelCount
            let newModel = prepareModel(media: model, newWidth: width, newHeight: height)
            models.append(newModel)
        }
        return models
    }
    
    private func prepareModel(media: input, newWidth: CGFloat, newHeight: CGFloat) -> output {
        var newMedia = media
        newMedia.width = newWidth
        newMedia.height = newHeight
        return newMedia
       // let mediaModel: MediaModel = MediaModel(mediaModel: media)
       // return MediaModel(media: mediaModel, newWidth: newWidth, newHeight: newHeight)
    }
}
