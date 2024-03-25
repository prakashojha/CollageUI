//
//  PhotosPickerItemHandler.swift
//  
//
//  Created by Saumya Prakash on 21/03/24.
//

import SwiftUI
import PhotosUI

enum MediaType {
    case image(UIImage)
    case url(URL)
}

enum PhotPickerItemLoadError: Error {
    case reason(String)
}

struct PhotosPickerItemHandler {
   
    func generateMedia(from item: PhotosPickerItem) async throws -> MediaProtocol{
        if let movie: Video = try await item.loadTransferable(type: Video.self) {
            let videoModel: VideoModel = await VideoModel(videoHandler: VideoHandler(url: movie.url))
            return videoModel
        } else if let data = try await item.loadTransferable(type: Data.self) {
            if let image: UIImage = .init(data: data) {
                return ImageModel(mediaType: image)
            }
        }
        throw PhotPickerItemLoadError.reason("This app supports image and videos only")
    }
    
    /// Converts PhotPickerItem to respective Image and Video Models
    /// - Parameter items: Items selected from photo library
    /// - Returns: Image and Video Models as MediaProtocol items
    func generateMedias(from items: [PhotosPickerItem]) async -> [MediaProtocol]{
        var allMedias:[MediaProtocol] = []
        for item in items {
            if let mediaData = try? await generateMedia(from: item) {
                allMedias.append(mediaData)
            }
        }
        return allMedias
    }
    
    func generateMedias(from models: [Model]) async -> [MediaProtocol] {
        var pickedItems:[MediaProtocol] = []
        for media in models {
            switch(media.item){
            case .Image(let image):
                pickedItems.append(ImageModel(mediaType: image))
            case .Video(let url):
                let videoModel = await VideoModel(videoHandler: VideoHandler(url: url))
                pickedItems.append(videoModel)
                
            }
        }
        return pickedItems
    }
    
}
