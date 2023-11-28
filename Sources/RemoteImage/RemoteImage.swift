import SwiftUI

public struct RemoteImage<ImageContent, PlaceholderContent>: View where ImageContent: View, PlaceholderContent: View {
    private let url: URL
    private let provider: RemoteImageProvider
    
    private let imageContent: (Image) -> ImageContent
    private let placeholderContent: PlaceholderContent
    
    public init(
        _ url: URL,
        provider: RemoteImageProvider = .shared,
        @ViewBuilder imageContent: @escaping (Image) -> ImageContent,
        placeholderContent: PlaceholderContent = Image(systemName: "photo")
    ) {
        self.url = url
        self.provider = provider
        self.imageContent = imageContent
        self.placeholderContent = placeholderContent
    }
    
    public var body: some View {
        RemoteImageLoaderView(url, provider: provider) {
            placeholderContent
        } successContents: { image in
            imageContent(image)
        } failureContents: { error in
            placeholderContent
        }
    }
}

extension RemoteImage {
    public init(
        _ url: URL,
        provider: RemoteImageProvider = .shared,
        @ViewBuilder imageContent: @escaping (Image) -> ImageContent,
        @ViewBuilder placeholderContent: () -> PlaceholderContent
    ) {
        self.url = url
        self.provider = provider
        self.imageContent = imageContent
        self.placeholderContent = placeholderContent()
    }
}
