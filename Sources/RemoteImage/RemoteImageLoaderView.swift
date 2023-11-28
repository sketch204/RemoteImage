import SwiftUI

public struct RemoteImageLoaderView<LoadingContent, SuccessContent, FailureContent>: View
where LoadingContent: View, SuccessContent: View, FailureContent: View
{
    public enum State {
        case loading
        case success(Image)
        case failure(Error)
    }
    
    @SwiftUI.State private var state: State = .loading
    @SwiftUI.State private var task: Task<Void, Never>?
    
    let url: URL
    let provider: RemoteImageProvider
    let loadingContents: () -> LoadingContent
    let successContents: (Image) -> SuccessContent
    let failureContents: (Error) -> FailureContent
    
    public init(
        _ url: URL,
        provider: RemoteImageProvider = .shared,
        @ViewBuilder loadingContents: @escaping () -> LoadingContent,
        @ViewBuilder successContents: @escaping (Image) -> SuccessContent,
        @ViewBuilder failureContents: @escaping (Error) -> FailureContent
    ) {
        self.url = url
        self.provider = provider
        self.loadingContents = loadingContents
        self.successContents = successContents
        self.failureContents = failureContents
    }
    
    public var body: some View {
        Group {
            switch state {
            case .loading:
                loadingContents()
            case .success(let image):
                successContents(image)
            case .failure(let error):
                failureContents(error)
            }
        }
        .onAppear {
            load(url: url)
        }
        .onChange(of: url) { url in
            load(url: url)
        }
    }
    
    private func load(url: URL) {
        state = .loading
        
        task?.cancel()
        task = Task {
            do {
                let rawImage = try await provider.image(at: url)
                guard !(task?.isCancelled ?? true) else { return }
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
