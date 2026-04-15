import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        NavigationStack {
            Group {
                if appState.isCheckingSession {
                    SmartPantryLoadingView(
                        title: "Checking your session...",
                        subtitle: "SmartPantry is preparing your kitchen space"
                    )
                } else if appState.isAuthenticated {
                    MainTabView()
                } else {
                    WelcomeView()
                }
            }
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
        .environmentObject(SavedRecipesManager())
}
