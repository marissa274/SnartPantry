import Foundation

protocol AuthServiceProtocol {
    var hasToken: Bool { get }
    func register(name: String, email: String, password: String) async throws
    func login(email: String, password: String) async throws -> UserProfile
    func fetchCurrentUser() async throws -> UserProfile
    func logout()
}

final class AuthService: AuthServiceProtocol {
    private let apiClient: APIClientProtocol
    private let keychain: KeychainServiceProtocol

    init(apiClient: APIClientProtocol = APIClient(), keychain: KeychainServiceProtocol = KeychainService()) {
        self.apiClient = apiClient
        self.keychain = keychain
    }

    var hasToken: Bool { keychain.readToken() != nil }

    func register(name: String, email: String, password: String) async throws {
        try await apiClient.requestVoid(.register, body: RegisterRequest(email: email, password: password, name: name))
    }

    func login(email: String, password: String) async throws -> UserProfile {
        let response: LoginResponse = try await apiClient.request(.login, body: LoginRequest(email: email, password: password))
        try keychain.save(token: response.token)
        return try await fetchCurrentUser()
    }

    func fetchCurrentUser() async throws -> UserProfile {
        let response: UserProfileResponse = try await apiClient.requestWithoutBody(.me)
        return response.user
    }

    func logout() {
        keychain.deleteToken()
    }
}
