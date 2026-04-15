import Foundation

struct PexelsSearchResponse: Decodable {
    let photos: [PexelsPhoto]
}

struct PexelsPhoto: Decodable {
    let src: PexelsPhotoSource
    let photographer: String
    let url: String
}

struct PexelsPhotoSource: Decodable {
    let medium: String
    let large: String
}
