import CryptoKit
import Foundation

/// A stable identifier for an image URL
public struct RemoteImageIdentifier: RawRepresentable, Hashable {
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension RemoteImageIdentifier {
    public init?(url: URL) {
        self.init(string: url.absoluteString)
    }
    
    public init?(string: String) {
        guard let stringData = string.data(using: .utf8) else { return nil }
        let digest = Insecure.SHA1.hash(data: stringData)
        let rawValue = digest.compactMap { String(format: "%02x", $0) }.joined()
        self.init(rawValue: rawValue)
    }
}
