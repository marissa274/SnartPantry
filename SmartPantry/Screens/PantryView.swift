import SwiftUI

struct PantryView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var savedRecipesManager: SavedRecipesManager
    @StateObject private var viewModel = PantryViewModel()
    @State private var showScanner = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    header

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }

                    if viewModel.recipes.isEmpty && !viewModel.isLoading {
                        emptyState
                    } else {
                        List {
                            ForEach(viewModel.recipes) { item in
                                NavigationLink {
                                    RecipeDetailPremiumView(recipe: item.asUIRecipe)
                                        .environmentObject(savedRecipesManager)
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(item.title)
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text(item.data.summary)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(2)
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .onDelete { offsets in
                                Task { await viewModel.deleteRecipe(at: offsets) }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showScanner) {
                AIScannerView()
            }
            .task {
                await viewModel.loadRecipes()
            }
            
            .onReceive(NotificationCenter.default.publisher(for: .recipeDidSaveToPantry)) { _ in
                            Task { await viewModel.loadRecipes() }
                        }
            .overlay {
                if viewModel.isLoading {
                    SmartPantryLoadingView(title: "Loading pantry...", subtitle: "SmartPantry is fetching your saved recipes")
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Pantry")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.smartRed)
                    Text(appState.currentUser?.name ?? "Your saved recipes")
                        .foregroundColor(.gray)
                }

                Spacer()

                Button {
                    Task { await viewModel.loadRecipes() }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title3)
                        .foregroundColor(.smartRed)
                }

                Button {
                    showScanner = true
                } label: {
                    Image(systemName: "plus.viewfinder")
                        .font(.title2)
                        .foregroundColor(.smartRed)
                }
            }

            HStack {
                Text("\(viewModel.recipes.count) saved recipe\(viewModel.recipes.count == 1 ? "" : "s")")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.smartRed)

                Spacer()

                Button("Logout") {
                    appState.logout()
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.smartRed)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()
            Image(systemName: "fork.knife.circle")
                .font(.system(size: 70))
                .foregroundColor(.smartRed)
            Text("No recipes saved yet")
                .font(.title3.bold())
                .foregroundColor(.smartRed)
            Text("Scan ingredients and generate your first SmartPantry recipe.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Button {
                showScanner = true
            } label: {
                Text("Start Scanning")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.smartRed)
                    .cornerRadius(28)
                    .padding(.horizontal, 20)
            }
            Spacer()
        }
    }
}

#Preview {
    PantryView()
        .environmentObject(AppState())
        .environmentObject(SavedRecipesManager())
}
