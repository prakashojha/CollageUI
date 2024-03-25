//
//  VideoViewModelTests.swift
//  
//
//  Created by Saumya Prakash on 20/03/24.
//

import XCTest
import AVKit
import Combine
@testable import CollageUI

final class VideoViewModelTests: XCTestCase {

    var model: VideoModel!
    var viewModel: VideoViewModel!
    var coordinator: StubCollageCoordinator!
   // var publisher: AnyCancellable!
    var expect: XCTestExpectation!
    
    override func setUpWithError() throws {
        //coordinator = StubCollageCoordinator()
        
    }

    override func tearDownWithError() throws {
        model = nil
        viewModel = nil
        coordinator = nil
        expect = nil
    }

    func test_handleTapGesture_WhenPerformedTapGesture_RelavantActivitiesPerformed() async {
        let expect = expectation(description: "test_handleTapGesture_WhenPerformedTapGesture_RelavantActivitiesPerformed")
        let handler = SpyMediaHandler(url: URL(string: "NotImportant")!, player: AVPlayer())
        let coordinator = StubCollageCoordinator()
        let task1 = Task {
            model = await VideoModel(videoHandler: handler)
        }
        await task1.value
        viewModel = VideoViewModel(model: model, coordinator: coordinator)
        
        //Act
        let task2 = Task {
            viewModel.handleTapGesture(frameSize: .zero)
        }
        await task2.value
        _ = XCTWaiter.wait(for: [expect], timeout: 2)
       
        //Assert
        XCTAssertEqual(coordinator.makeMediaFullScreenCount, 1)
        XCTAssertEqual(handler.playMediaCount, 1)
       
    }
    
    var viewOpacity: CGFloat = -1
    func test_handleTapGesture_WhenPerformedTapGesture_thenOpacityIsReset() {
        let dummyUrl = URL(string: "dummyUrl")!
        let handler = SpyMediaHandler(url: dummyUrl, player: AVPlayer())
        let coordinator = StubCollageCoordinator()
        let expect = expectation(description: "global_test_handleTapGesture_WhenPerformedTapGesture_thenOpacityIsReset")
        
        Task {
            let model = await VideoModel(videoHandler: handler)
            let viewModel = VideoViewModel(model: model, coordinator: coordinator)
            let subscriber = viewModel.$opacity.sink { opacity in
                self.viewOpacity = opacity
                    expect.fulfill()
                
            }
            //Act
            viewModel.handleTapGesture(frameSize: .zero)
            subscriber.cancel()
        }
        //Assert
        waitForExpectations(timeout: 3)
        XCTAssertEqual(viewOpacity, 1)
    }
    
    var isPlayerReadyToPlay: Bool = false
    func test_setObserver_whenObserverIsSet_thenGotNotifiedWhenPlayerIsReadyAndLoaded() {
        //Arrange
        let dummyUrl = URL(string: "dummyUrl")!
        let handler = SpyMediaHandler(url: dummyUrl, player: AVPlayer())
        let coordinator = StubCollageCoordinator()
        let expect = expectation(description: "test_setObserver_whenObserverIsSet_thenGotNotifiedWhenPlayerIsReadyAndLoaded")
        expect.assertForOverFulfill = false
      
        Task {
            let model = await VideoModel(videoHandler: handler)
            let viewModel = VideoViewModel(model: model, coordinator: coordinator)
            let subscriber = viewModel.$isPlayerReadyToPlay.sink { status in
                if status == true {
                    self.isPlayerReadyToPlay = status
                    expect.fulfill()
                }
            }
            //Act
            viewModel.setObserver()
            handler.player.isMuted = true
            subscriber.cancel()
        }
        
        //Assert
        waitForExpectations(timeout: 3)
        XCTAssertTrue(isPlayerReadyToPlay)
    }
    
    func test_playMedia_checkIfFunctionISCalled() async  {
        //Arrange
        let dummyUrl = URL(string: "dummyUrl")!
        let handler = SpyMediaHandler(url: dummyUrl, player: AVPlayer())
        let coordinator = StubCollageCoordinator()
        let model = await VideoModel(videoHandler: handler)
        let viewModel = VideoViewModel(model: model, coordinator: coordinator)
        
        //Act
        viewModel.playMedia(withMuteOn: true)
        
        //Assert
        XCTAssertEqual(handler.playMediaCount, 1)
    }

}
