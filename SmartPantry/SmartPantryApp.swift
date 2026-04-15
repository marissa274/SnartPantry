import SwiftUI

@main
struct SmartPantryApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var savedRecipesManager = SavedRecipesManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(savedRecipesManager)
        }
    }
}
