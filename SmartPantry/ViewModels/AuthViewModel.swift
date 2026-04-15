import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var successMessage = ""

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func login(appState: AppState) async -> Bool {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return false
        }

        isLoading = true
        errorMessage = ""
        defer { isLoading = false }

        do {
            let user = try await authService.login(email: email, password: password)
            appState.currentUser = user
            appState.isAuthenticated = true
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func register() async -> Bool {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              password.count >= 8,
              password == confirmPassword else {
            errorMessage = "Check your name, email, and passwords."
            return false
        }

        isLoading = true
        errorMessage = ""
        successMessage = ""
        defer { isLoading = false }

        do {
            try await authService.register(name: name, email: email, password: password)
            successMessage = "Account created successfully."
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
