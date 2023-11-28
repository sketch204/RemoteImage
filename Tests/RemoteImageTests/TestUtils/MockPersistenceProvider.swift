import Foundation
@testable import RemoteImage

final class MockPersistenceProvider: RemoteImageProviderPersistenceManager {
    
    struct Call {
        let methodName: String
        let arguments: [String: Any]
    }
    
    var data: [RemoteImageIdentifier: Data] = [:]
    private(set) var calls: [Call] = []
    
    init(data: [RemoteImageIdentifier : Data] = [:]) {
        self.data = data
        self.calls = []
    }
    
    func imageData(for identifier: RemoteImageIdentifier) throws -> Data? {
        calls.append(
            Call(
                methodName: "imageData(for:)",
                arguments: ["identifier": identifier]
            )
        )
        return data[identifier]
    }
    
    func persist(
        _ imageData: Data,
        for identifier: RemoteImageIdentifier
    ) {
        calls.append(
            Call(
                methodName: "persist(_:for:)",
                arguments: [
                    "imagedata": imageData, 
                    "identifier": identifier,
                ]
            )
        )
        data[identifier] = imageData
    }
    
    
}
