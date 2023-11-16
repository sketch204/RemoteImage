import Foundation

public struct URLSessionBasedNetworkInterface {
    public func data(from url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

extension URLSessionBasedNetworkInterface: RemoteImageProviderNetworkInterface {}
