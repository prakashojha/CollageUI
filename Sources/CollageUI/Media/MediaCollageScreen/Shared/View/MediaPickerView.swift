//
//  SwiftUIView.swift
//  
//
//  Created by Saumya Prakash on 21/02/24.
//

import SwiftUI
import PhotosUI
import AVKit

struct MediaPickerView: View {
    
    @State private var selectedItem = [PhotosPickerItem]()
    @State private var imageLoadingStarted: Bool = false
    
    @EnvironmentObject var coordinator: CollageCoordinator
    
    var body: some View {
        VStack{
            if imageLoadingStarted == false {
                PhotosPicker(selection: $selectedItem, matching: .any(of: [.images, .videos])) {
                    Label("Select from Media", systemImage: "photo")
                }
                .tint(.purple)
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
            else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.black)
                    .scaleEffect(2.5)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(Color.gray)
        .padding(2)
        .onChange(of: selectedItem){ newValue in
            // No need to make it false once image is loaded on the screen
            // After image is loaded, this whole screen will not be rendered, as its mutually exclusive with the rendered screen
            imageLoadingStarted = true
            Task {
                coordinator.photPickerItemsFromMediaLibrary = selectedItem
            }
        }
    }
}

struct MediaPickerView_Previews: PreviewProvider {
    
    static var previews: some View {
        MediaPickerView()
    }
}
