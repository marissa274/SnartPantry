import SwiftUI

struct RecipeDetailPremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var savedRecipesManager: SavedRecipesManager

    @State private var selectedTab = "Ingredients"
    @State private var portions = 3
    @State private var showingAudioSteps = false

    let recipe: Recipe

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack(alignment: .topLeading) {
                    headerImage
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipped()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()

                    HStack {
                        Spacer()
                        Button {
                            savedRecipesManager.toggleSaved(recipe)
                        } label: {
                            Text(savedRecipesManager.isSaved(recipe) ? "Saved" : "+ Save")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color.smartRed.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding()
                    }

                    VStack {
                        Spacer()
                        HStack(spacing: 24) {
                            Label(recipe.prepTime, systemImage: "clock")
                            Label("\(portions) portions", systemImage: "person.2")
                        }
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                    }
                }

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(recipe.title)
                            .font(.system(size: 26, weight: .bold))
                        Spacer()
                    }

                    HStack {
                        Button {
                            if portions > 1 { portions -= 1 }
                        } label: {
                            Text("-")
                                .frame(width: 40, height: 40)
                        }

                        HStack {
                            Image(systemName: "bowl.fill")
                            Text("\(portions) Portions")
                        }
                        .frame(maxWidth: .infinity)

                        Button {
                            portions += 1
                        } label: {
                            Text("+")
                                .frame(width: 40, height: 40)
                                .background(Color.smartRed)
                                .foregroundColor(.white)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.smartRed.opacity(0.3))
                    )

                    HStack {
                        tabButton("Ingredients")
                        tabButton("Process")
                    }

                    Divider()

                    if selectedTab == "Ingredients" {
                        VStack(spacing: 16) {
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                HStack {
                                    Image(systemName: "square")
                                        .foregroundColor(.smartRed)
                                    Text(ingredient)
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("STEP \(index + 1)")
                                        .font(.headline)
                                        .foregroundColor(.smartRed)
                                    Text(step)
                                        .foregroundColor(.gray)
                                }
                            }

                            Button {
                                showingAudioSteps = true
                            } label: {
                                Text("Read Recipe")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.smartRed)
                                    .cornerRadius(18)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .offset(y: -20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showingAudioSteps) {
            RecipeAudioStepView(recipe: recipe)
        }
    }

    private func tabButton(_ title: String) -> some View {
        Button {
            selectedTab = title
        } label: {
            VStack {
                Text(title.uppercased())
                    .font(.subheadline.bold())
                    .foregroundColor(selectedTab == title ? .smartRed : .gray)
                if selectedTab == title {
                    Circle().fill(Color.smartRed).frame(width: 6, height: 6)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    @ViewBuilder
        private var headerImage: some View {
            if let remoteImageURL = normalizedRemoteImageURL,
               let url = URL(string: remoteImageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        fallbackImage
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.1))
                    @unknown default:
                        fallbackImage
                    }
                }
            } else {
                fallbackImage
            }
        }

        private var normalizedRemoteImageURL: String? {
            guard let raw = recipe.remoteImageURL?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !raw.isEmpty else {
                return nil
            }

            if raw.hasPrefix("//") {
                return "https:\(raw)"
            }

            if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://") {
                return raw
            }

            return "https://\(raw)"
        }

        private var fallbackImage: some View {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
        }
}

#Preview {
    NavigationStack {
        RecipeDetailPremiumView(recipe: MockRecipeData.sampleRecipe)
            .environmentObject(SavedRecipesManager())
    }
}
