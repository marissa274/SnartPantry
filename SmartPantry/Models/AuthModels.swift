import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let name: String
}

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
    let tokenType: String
    let expiresIn: String

    enum CodingKeys: String, CodingKey {
        case token
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct UserProfileResponse: Codable {
    let user: UserProfile
}

struct UserProfile: Codable {
    let id: String
    let email: String
    let name: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, email, name
        case createdAt = "created_at"
    }
}
