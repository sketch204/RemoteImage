import Foundation
@testable import RemoteImage

let mockImage1 = PlatformImage(data: mockImage1Data)
let mockImage1Url = URL(string: "https://hello.mock/images/1")!
let mockImage1Identifier = RemoteImageIdentifier(rawValue: "b197f081ee140689c2f0e3be8aa49de877883145")

let mockImage2 = PlatformImage(data: mockImage2Data)
let mockImage2Url = URL(string: "https://hello.mock/images/2")!
let mockImage2Identifier = RemoteImageIdentifier(rawValue: "1913a51e3efacfdd2bfda6adc4fdbbcdfe671001")

let mockImage3 = PlatformImage(data: mockImage3Data)
let mockImage3Url = URL(string: "https://hello.mock/images/3")!
let mockImage3Identifier = RemoteImageIdentifier(rawValue: "dc6e2325cdb0c1b87d8edf59497375dfcf0b6da9")
