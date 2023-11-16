import SwiftUI

public struct RemoteImageLoaderView<Content>: View where Content: View {
    public enum State {
        case loading
        case success(Image)
        case failure(Error)
    }
    
    @SwiftUI.State private var state: State = .loading
    
    let url: URL
    let provider: RemoteImageProvider
    let contents: (State) -> Content
    
    public init(
        _ url: URL,
        provider: RemoteImageProvider = .shared,
        @ViewBuilder contents: @escaping (State) -> Content
    ) {
        self.url = url
        self.provider = provider
        self.contents = contents
    }
    
    public var body: some View {
        contents(state)
            .onAppear {
                load(url: url)
            }
            .onChange(of: url) { url in
                load(url: url)
            }
    }
    
    private func load(url: URL) {
        state = .loading
        
        Task {
            do {
                let rawImage = try await provider.image(at: url)
                state = .success(Image(platformImage: rawImage))
            } catch {
                state = .failure(error)
            }
        }
    }
}

//#Preview {
//    RemoteImageLoaderView(URL(string: "https://hello.mock/logo.png")!) { state in
//        switch state {
//        case .loading:
//            Text("Loading")
//        case .success(let image):
//            Text("Loaded")
//        case .failure(let error):
//            Text("Failed! \(String(describing: error))")
//        }
//    }
//}
