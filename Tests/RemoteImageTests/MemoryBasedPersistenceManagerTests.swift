//
//  MemoryBasedPersistenceManagerTests.swift
//  
//
//  Created by Inal Gotov on 2023-11-28.
//

import XCTest
@testable import RemoteImage

final class MemoryBasedPersistenceManagerTests: XCTestCase {
    func test_whenImageDataPersisted_savesImage() throws {
        let sut = MemoryBasedPersistenceManager()
        
        sut.persist(mockImage1Data, for: mockImage1Identifier)
        
        let savedImageData = try sut.imageData(for: mockImage1Identifier)
        let expectedImageData = mockImage1Data
        
        XCTAssertEqual(savedImageData, expectedImageData)
    }
}
