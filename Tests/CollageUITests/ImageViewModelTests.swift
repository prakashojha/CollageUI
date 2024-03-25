//
//  ImageViewModelTests.swift
//
//
//  Created by Saumya Prakash on 20/03/24.
//

import XCTest
@testable import CollageUI

final class ImageViewModelTests: XCTestCase {

    var viewModel: ImageViewModel!
    var model: MediaProtocol!
    var coordinator: StubCollageCoordinator!
    
    override func setUpWithError() throws {
        coordinator =  StubCollageCoordinator()
    }

    override func tearDownWithError() throws {
        model = nil
        viewModel = nil
        coordinator = nil
    }
    
    func test_whenImageModelProvided_addsItToCoordinator() {
        let id = UUID()
        let model = ImageModel(mediaType: UIImage(), id: id, orientation: .Landscape, width: 250, height: 100, opacity: 1)
        viewModel = ImageViewModel(model: model, coordinator: coordinator)
        XCTAssertEqual(coordinator.collageViewModels[id]?.getModelWidth, 250 )
        XCTAssertEqual(coordinator.collageViewModels[id]?.getModelHeight, 100 )
    }
    
    @MainActor
    func test_ImageViewModel_HandleTapGesture() {
        let id = UUID()
        let model = ImageModel(mediaType: UIImage(), id: id, orientation: .Landscape, width: 250, height: 100, opacity: 1)
        viewModel = ImageViewModel(model: model, coordinator: coordinator)
       
        viewModel.handleTapGesture(frameSize: .zero)
        
        XCTAssertEqual(coordinator.makeMediaFullScreenCount, 1 )
    }
}
