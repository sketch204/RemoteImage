import XCTest
@testable import RemoteImage

final class RemoteImageIdentifierTests: XCTestCase {
    func test_whenValidUrlProvided_createsIdentifier() {
        let identifier = RemoteImageIdentifier(url: mockImage1Url)
        
        XCTAssertNotNil(identifier)
    }
    
    func test_identifierIsStableAcrossRuns() {
        let identifier = RemoteImageIdentifier(url: mockImage1Url)!
        
        let expectedIdentifier = mockImage1Identifier
        
        XCTAssertEqual(identifier, expectedIdentifier)
    }
    
    func test_identifierIsDistinct() {
        let identifier1 = RemoteImageIdentifier(url: mockImage1Url)!
        let identifier2 = RemoteImageIdentifier(url: mockImage2Url)!
        let identifier3 = RemoteImageIdentifier(url: mockImage3Url)!
        
        XCTAssertNotEqual(identifier1, identifier2)
        XCTAssertNotEqual(identifier2, identifier3)
        XCTAssertNotEqual(identifier1, identifier3)
    }
}
