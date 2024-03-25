# CollageUI

A description of this package.

## Usage
import SwiftUI
import CollageUI


struct ContentView: View {
   // Both coordinators are required internally by other views to communicate.
    @StateObject var appCoordinator: AppCoordinator = AppCoordinator()
    @EnvironmentObject private var viewModel: CollageUIExampleViewModel
    
    var body: some View {
        GeometryReader { _ in
            ScrollView {
            /* YOU APP GOES INSIDE HERE */
            // By default asks the used to select media from library
             CollageUI(mediaModels: [ /*array medias(images or videos)*/] )
             CollageUI()
            }
            // let the render media in full screen when clicked
            if appCoordinator.isMediaFullScreenRequired {
                appCoordinator.renderFullScreen()
            }
        }
        // need by other views.
        .environmentObject(appCoordinator)
    }
}
