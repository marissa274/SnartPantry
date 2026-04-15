import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            RecipesHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            AIScannerView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }

            PantryView()
                .tabItem {
                    Label("Pantry", systemImage: "fork.knife")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(.smartRed)
    }
}

#Preview {
    MainTabView()
}
