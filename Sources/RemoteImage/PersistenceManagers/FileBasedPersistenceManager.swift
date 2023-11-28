import Foundation
import os

public struct FileBasedPersistenceManager {
    let fileManager = FileManager.default
    let baseUrl: URL
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func readData(at url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
    
    func writeData(_ data: Data, to url: URL) throws {
        try data.write(to: url)
    }
}


extension FileBasedPersistenceManager: RemoteImageProviderPersistenceManager {
    public func imageData(for identifier: RemoteImageIdentifier) throws -> Data? {
        let url = baseUrl.appendingPathComponent(identifier.rawValue)
        
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        
        return try readData(at: url)
    }
    
    public func persist(_ imageData: Data, for identifier: RemoteImageIdentifier) {
        let url = baseUrl.appendingPathComponent(identifier.rawValue)
        
        do {
            try writeData(imageData, to: url)
        } catch {
            Logger().error("Failed to write data to \(url) -- \(error)")
        }
    }
}

extension FileBasedPersistenceManager {
    init() throws {
        let fileManager = FileManager.default
        let cacheUrl = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        
        let url = cacheUrl.appendingPathComponent("remoteImages")
        var isDirectory: ObjCBool = false
        var directoryExists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        directoryExists = directoryExists && isDirectory.boolValue
        if !directoryExists {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
        }
        
        self.init(baseUrl: url)
    }
}
