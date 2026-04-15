import Foundation

protocol APIClientProtocol {
    func request<T: Decodable, U: Encodable>(_ endpoint: Endpoint, body: U?) async throws -> T
    func requestWithoutBody<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func requestVoid<U: Encodable>(_ endpoint: Endpoint, body: U?) async throws
    func requestVoid(_ endpoint: Endpoint) async throws
}

final class APIClient: APIClientProtocol {
    private let session: URLSession
    private let keychain: KeychainServiceProtocol

    init(
        session: URLSession = .shared,
        keychain: KeychainServiceProtocol = KeychainService()
    ) {
        self.session = session
        self.keychain = keychain
    }

    func request<T: Decodable, U: Encodable>(
        _ endpoint: Endpoint,
        body: U? = nil
    ) async throws -> T {
        let request = try buildRequest(endpoint: endpoint, body: body)
        let (data, response) = try await session.data(for: request)

        return try handleResponse(
            data: data,
            response: response,
            endpoint: endpoint
        )
    }

    func requestWithoutBody<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {
        let request = try buildRequest(endpoint: endpoint, body: Optional<String>.none)
        let (data, response) = try await session.data(for: request)

        return try handleResponse(
            data: data,
            response: response,
            endpoint: endpoint
        )
    }

    func requestVoid<U: Encodable>(
        _ endpoint: Endpoint,
        body: U? = nil
    ) async throws {
        let request = try buildRequest(endpoint: endpoint, body: body)
        let (data, response) = try await session.data(for: request)

        try validateStatus(
            response: response,
            data: data,
            endpoint: endpoint
        )
    }

    func requestVoid(_ endpoint: Endpoint) async throws {
        let request = try buildRequest(endpoint: endpoint, body: Optional<String>.none)
        let (data, response) = try await session.data(for: request)

        try validateStatus(
            response: response,
            data: data,
            endpoint: endpoint
        )
    }

    private func buildRequest<U: Encodable>(
        endpoint: Endpoint,
        body: U?
    ) throws -> URLRequest {
        let url = APIConstants.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if endpoint.requiresAuth {
            guard let token = keychain.readToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body {
            request.httpBody = try JSONEncoder().encode(body)
        }

        return request
    }

    private func handleResponse<T: Decodable>(
        data: Data,
        response: URLResponse,
        endpoint: Endpoint
    ) throws -> T {
        try validateStatus(
            response: response,
            data: data,
            endpoint: endpoint
        )

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("❌ Decoding failed for endpoint:", endpoint.path)
            print("📦 Raw response:", String(data: data, encoding: .utf8) ?? "No body")
            throw APIError.decodingError
        }
    }

    private func validateStatus(
        response: URLResponse,
        data: Data?,
        endpoint: Endpoint
    ) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return

        case 401:
            if endpoint.path == "/smartpantry/login" && endpoint.method == .post {
                throw APIError.invalidCredentials
            } else {
                throw APIError.unauthorized
            }

        default:
            if let data,
               let message = String(data: data, encoding: .utf8),
               !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw APIError.serverError(message)
            }

            throw APIError.invalidResponse
        }
    }
}
