import Foundation

public protocol RemoteImageProviderPersistenceManager {
    func hasImageData(for identifier: RemoteImageIdentifier) throws -> Bool
    
    func imageData(for identifier: RemoteImageIdentifier) throws -> Data?
    
    func persist(_ imageData: Data, for identifier: RemoteImageIdentifier)
}

extension RemoteImageProviderPersistenceManager {
    public func hasImageData(for identifier: RemoteImageIdentifier) throws -> Bool {
        try imageData(for: identifier) != nil
    }
}
