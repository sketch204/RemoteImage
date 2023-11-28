import XCTest
@testable import RemoteImage

final class RemoteImageProviderTests: XCTestCase {
    func test_whenNoPersistenceManagersProvided_fetchesImages() async throws {
        let sut = RemoteImageProvider(
            networkInterface: MockNetworkInterface(),
            persistenceManagers: []
        )
        
        let image = try await sut.image(at: mockImage1Url)
        let expectedImage = mockImage1
        
        XCTAssertEqual(image.tiffRepresentation, expectedImage?.tiffRepresentation)
    }
    
    func test_whenPersistenceManagerProvided_fetchesImages() async throws {
        let sut = RemoteImageProvider(
            networkInterface: MockNetworkInterface(),
            persistenceManagers: [MockPersistenceProvider()]
        )
        
        let image = try await sut.image(at: mockImage1Url)
        let expectedImage = mockImage1
        
        XCTAssertEqual(image.tiffRepresentation, expectedImage?.tiffRepresentation)
    }
}

extension RemoteImageProviderTests {
    func test_whenPersistenceManagerProvided_persistsImagesOnFetch() async throws {
        let manager = MockPersistenceProvider()
        
        let sut = RemoteImageProvider(
            networkInterface: MockNetworkInterface(),
            persistenceManagers: [manager]
        )
        
        let _ = try await sut.image(at: mockImage1Url)

        XCTAssertTrue(
            manager.calls.contains(where: {
                $0.methodName == "persist(_:for:)"
                && ($0.arguments["identifier"] as? RemoteImageIdentifier) == mockImage1Identifier
            })
        )
    }
    
    func test_whenPersistenceManagerProvided_usesPersistedeCacheOnFetch() async throws {
        let manager = MockPersistenceProvider(data: [
            mockImage1Identifier: mockImage1Data
        ])
        
        let sut = RemoteImageProvider(
            networkInterface: MockNetworkInterface(),
            persistenceManagers: [manager]
        )
        
        let _ = try await sut.image(at: mockImage1Url)
        
        XCTAssertTrue(
            manager.calls.contains(where: {
                $0.methodName == "imageData(for:)"
                && ($0.arguments["identifier"] as? RemoteImageIdentifier) == mockImage1Identifier
            })
        )
    }
}
