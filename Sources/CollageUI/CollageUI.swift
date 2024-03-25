
import SwiftUI
import PhotosUI

public enum MediaItem {
    case Image(UIImage)
    case Video(URL)
}


public struct Model {
    public var item: MediaItem
    public init(item: MediaItem) {
        self.item = item
    }
}

public struct CollageUI: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @StateObject var collageCoordinator: CollageCoordinator = CollageCoordinator(generateModel: GenerateModel.shared,
                                                                                 photoPickerItemHandler: PhotosPickerItemHandler())
    
    @State private var modelCount: Int = 0
    @State private var showProgressView: Bool = true
    
    private var models: [Model] = []
   
    public init(mediaModels: [Model]? = nil) {
        if let mediaModels = mediaModels {
            self.models = mediaModels
        }
    }
    
    public var body: some View {
        VStack {
            if showProgressView && !models.isEmpty{
                VStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.black)
                        .scaleEffect(2.5)
                        .accessibilityIdentifier("CollageUIProgressView")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(Color.gray)
                .padding(2)
            }
            else {
                switch(modelCount){
                case 0:
                    MediaPickerView()
                default:
                    MediaRendererView(modelCount)
                        .transition(.scale(scale: 1))
                }
            }
        }
        .onAppear{
            collageCoordinator.parentCoordinator = appCoordinator
            if !models.isEmpty {
                collageCoordinator.generateModelsFrom(models)
            }
        }
       
        .onChange(of: collageCoordinator.modelsForViews.count, perform: { newValue in
            modelCount = newValue
            showProgressView = false
            
        })
        .allowsHitTesting(appCoordinator.allowHitTesting)
        .environmentObject(collageCoordinator)
    }
}










//
//struct CollageUI_Previews: PreviewProvider {
//    @Namespace static var collageNameSpace
//
//    @ViewBuilder
//    static var previews: some View {
//        CollageUI()
//    }
//}
