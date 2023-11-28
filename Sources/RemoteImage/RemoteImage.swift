import SwiftUI

struct RemoteImage: View {
    let url: URL
    let provider: RemoteImageProvider
    
    public init(
        _ url: URL,
        provider: RemoteImageProvider = .shared
    ) {
        self.url = url
        self.provider = provider
    }
    
    var body: some View {
        RemoteImageLoaderView(url, provider: provider) {
            ProgressView()
        } successContents: { image in
            image
        } failureContents: { error in
            Image(systemName: "exclamationmark.triangle")
        }
    }
}
