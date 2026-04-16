import SwiftUI

struct RecipeDetailPremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var savedRecipesManager: SavedRecipesManager

    let recipe: Recipe

    @State private var selectedTab: String = "Ingredients"
    @State private var portions: Int = 3
    @State private var showingAudioSteps = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection

                    // Added horizontal padding so the rounded corners are visible
                    contentCard
                        .padding(.horizontal, 16)
                        .padding(.top, -18)
                }
                .padding(.top, 72)
                // Increased bottom padding so content isn't cramped near the bottom edge
                .padding(.bottom, 40)
            }
        }
        .safeAreaInset(edge: .top) {
            topBar
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 6)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showingAudioSteps) {
            RecipeAudioStepView(recipe: recipe)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.92))
                    .clipShape(Circle())
            }

            Spacer()

            Button {
                savedRecipesManager.toggleSaved(recipe)
            } label: {
                Text(savedRecipesManager.isSaved(recipe) ? "Saved" : "+ Save")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 14)
                    .background(Color.smartRed)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            headerImage
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .clipped()

            HStack(spacing: 28) {
                Label(recipe.prepTime, systemImage: "clock")
                Label("\(portions) portions", systemImage: "person.2")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(Color(red: 210/255, green: 184/255, blue: 160/255).opacity(0.97))
            .clipShape(Capsule())
            .padding(.bottom, 16)
        }
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                Text(recipe.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button {
                    showingAudioSteps = true
                } label: {
                    Label("Audio", systemImage: "speaker.wave.2.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.smartRed)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("Open audio mode")
            }

            portionsControl

            Picker("", selection: $selectedTab) {
                Text("Ingredients").tag("Ingredients")
                Text("Process").tag("Process")
            }
            .pickerStyle(.segmented)
            .padding(.top, 4)
            .padding(.bottom, 4)

            if selectedTab == "Ingredients" {
                ingredientsSection
            } else {
                processSection
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 26)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
        )
    }

    private var portionsControl: some View {
        HStack(spacing: 0) {
            Button {
                if portions > 1 { portions -= 1 }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.smartRed)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }

            Spacer()

            Text("\(portions) Portions")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Button {
                portions += 1
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.smartRed)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
        .frame(height: 50)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.smartRed.opacity(0.22), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(recipe.ingredients, id: \.self) { ingredient in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "square")
                        .foregroundColor(.smartRed)
                        .padding(.top, 3)

                    Text(ingredient)
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var processSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { index, step in
                VStack(alignment: .leading, spacing: 8) {
                    Text("STEP \(index + 1)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.smartRed)

                    Text(step)
                        .font(.system(size: 17))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
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

                case .empty:
                    ZStack {
                        Color.gray.opacity(0.08)
                        ProgressView()
                    }

                case .failure:
                    fallbackImage

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
