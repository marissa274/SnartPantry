import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unauthorized
    case invalidCredentials
    case serverError(String)
    case decodingError
    case emptyData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .unauthorized:
            return "Session expired. Please log in again."
        case .invalidCredentials:
            return "Invalid email or password."
        case .serverError(let message):
            return message
        case .decodingError:
            return "Unable to read server data."
        case .emptyData:
            return "No data received."
        }
    }
}
