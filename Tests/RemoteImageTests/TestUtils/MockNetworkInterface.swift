import Foundation
@testable import RemoteImage

struct UnsupportedTestData: Error {}

struct MockNetworkInterface: RemoteImageProviderNetworkInterface {
    func data(from url: URL) async throws -> Data {
        switch url {
        case mockImage1Url: return mockImage1Data
        case mockImage2Url: return mockImage2Data
        case mockImage3Url: return mockImage3Data
        default: throw UnsupportedTestData()
        }
    }
}
