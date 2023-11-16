import Foundation

public final class MemoryBasePersistenceManager: RemoteImageProviderPersistenceManager {
    private var store = [RemoteImageIdentifier: Data]()
    
    public func persist(_ imageData: Data, for identifier: RemoteImageIdentifier) {
        store[identifier] = imageData
    }
    
    public func imageData(for identifier: RemoteImageIdentifier) throws -> Data? {
        store[identifier]
    }
}
