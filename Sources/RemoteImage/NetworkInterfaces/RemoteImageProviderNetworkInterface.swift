import Foundation

public protocol RemoteImageProviderNetworkInterface {
    func data(from url: URL) async throws -> Data
}
