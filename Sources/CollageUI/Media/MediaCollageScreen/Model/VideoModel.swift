//
//  File.swift
//  
//
//  Created by Saumya Prakash on 21/02/24.
//

import Foundation
import SwiftUI
import AVKit


/// A model adopting `Trnasferable`protocol, to import and export the asset URL.
struct Video: Transferable {
    var url: URL

    init(url: URL) {
        self.url = url
    }
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { receivedData in
            let fileName = receivedData.file.lastPathComponent
            let copy: URL = FileManager.default.temporaryDirectory.appending(component: fileName)
            
            if FileManager.default.fileExists(atPath: copy.path) {
                try FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: receivedData.file, to: copy)
            return Self.init(url: copy)
        }
    }
}

/// Model representing a video
struct VideoModel: MediaProtocol {
    var id: UUID
    var orientation: Orientation
    var width: CGFloat
    var height: CGFloat
    var opacity: CGFloat
    
    var scale: CGFloat
    // used to perform video related activities like play, pause etc
    // uses AVPlayer
    var mediaHandler: MediaHandlerProtocol
    
    init(videoHandler: MediaHandlerProtocol) async {
        self.id = UUID()
        self.width =  0
        self.height = 0
        self.orientation = .Portrait
        self.scale = self.width / self.height
        self.mediaHandler = videoHandler
        self.opacity = 1
        // Required to set width, height, scale and orientation of the video correctly after applying `preferredTransform`
        let size = await getVideoDimension(url: videoHandler.url)
        if let size = size {
            self.width = size.width
            self.height = size.height
            self.orientation = size.width > size.height ? .Landscape : .Portrait
            self.scale = size.width / size.height
        }
    }
    
    init(model: VideoModel) {
        self.id = model.id
        self.orientation = model.orientation
        self.width = model.width
        self.height = model.height
        self.scale = model.scale
        self.mediaHandler = model.mediaHandler
        self.opacity = model.opacity
    }
    
    init(model: VideoModel, newWidth: CGFloat, newHeight: CGFloat){
        self.init(model: model)
        self.width = newWidth
        self.height = newHeight
    }
}

extension VideoModel  {
    
//    init(videoHandler: MediaHandlerProtocol) async {
//        self.id = UUID()
//        self.width =  0
//        self.height = 0
//        self.orientation = .Portrait
//        self.scale = self.width / self.height
//        self.mediaHandler = videoHandler
//        self.opacity = 1
//        // Required to set width, height, scale and orientation of the video correctly after applying `preferredTransform`
//        let size = await getVideoDimension(url: videoHandler.url)
//        if let size = size {
//            self.width = size.width
//            self.height = size.height
//            self.orientation = size.width > size.height ? .Landscape : .Portrait
//            self.scale = size.width / size.height
//        }
//    }
    
    ///  Get dimension of a video.
    /// - Parameter url: URL of video
    /// - Returns: CGSize of video
    func getVideoDimension(url: URL) async -> CGSize? {
        guard let tracks = try? await AVURLAsset(url: url).load(.tracks) else { return nil }
        guard let track = tracks.first(where: { track in track.mediaType == .video }) else { return nil }
        
        // The `preferredTransform` property represents the transformation needed to correctly display the video.
        // This transformation includes any rotation, scaling, or translation required to display the video in its proper orientation
        guard let transform = try? await track.load(.naturalSize).applying(track.load(.preferredTransform)) else { return nil }
        return CGSize(width: abs(transform.width), height: abs(transform.height))
    }
}
