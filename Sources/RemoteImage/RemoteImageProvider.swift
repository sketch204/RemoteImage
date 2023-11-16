import Foundation
import os

public final class RemoteImageProvider {
    public static let shared = RemoteImageProvider(
        networkInterface: URLSessionBasedNetworkInterface(),
        persistenceManagers: [
            MemoryBasePersistenceManager(),
        ]
    )
    
    public var networkInterface: RemoteImageProviderNetworkInterface
    public var persistenceManagers: [RemoteImageProviderPersistenceManager]
    
    public init(
        networkInterface: RemoteImageProviderNetworkInterface,
        persistenceManagers: [RemoteImageProviderPersistenceManager]
    ) {
        self.networkInterface = networkInterface
        self.persistenceManagers = persistenceManagers
    }
    
    func image(at url: URL) async throws -> PlatformImage {
        let imageData: Data
        
        if let persistedImageData = try persistedImageData(for: url) {
            imageData = persistedImageData
        } else {
            imageData = try await networkInterface.data(from: url)
            do {
                try persistImage(imageData, for: url)
            } catch {
                Logger().error("Could not persist image at \(url)")
            }
        }
        
        
        guard let output = PlatformImage(data: imageData) else {
            throw CannotParseImageData()
        }
        
        return output
    }
    
    private func persistedImageData(for url: URL) throws -> Data? {
        guard let identifier = RemoteImageIdentifier(url: url) else {
            throw CannotHashURL(url: url)
        }
        
        let manager = try persistenceManagers.first(where: { manager in
            try manager.hasImageData(for: identifier)
        })
        
        return try manager?.imageData(for: identifier)
    }
    
    private func persistImage(_ imageData: Data, for url: URL) throws {
        guard let identifier = RemoteImageIdentifier(url: url) else {
            throw CannotHashURL(url: url)
        }
        
        persistenceManagers.forEach { manager in
            manager.persist(imageData, for: identifier)
        }
    }
}
