import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserProfile?
    @Published var isCheckingSession = true

    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        Task { await restoreSession() }
    }

    func restoreSession() async {
        defer { isCheckingSession = false }

        guard authService.hasToken else {
            isAuthenticated = false
            return
        }

        do {
            let user = try await authService.fetchCurrentUser()
            currentUser = user
            isAuthenticated = true
        } catch {
            authService.logout()
            currentUser = nil
            isAuthenticated = false
        }
    }

    func logout() {
        authService.logout()
        currentUser = nil
        isAuthenticated = false
    }
}
