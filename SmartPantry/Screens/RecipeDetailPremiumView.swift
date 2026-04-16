import SwiftUI

struct RecipeDetailPremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var savedRecipesManager: SavedRecipesManager

    let recipe: Recipe

    @State private var selectedTab: String = "Ingredients"
    @State private var portions: Int = 3
    @State private var showingAudioSteps = false

    private let headerHeight: CGFloat = 250
    private let cardOverlap: CGFloat = 22

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        headerSection
                            .frame(height: headerHeight)

                        ZStack(alignment: .top) {
                            // Full white sheet filling all remaining visible space
                            RoundedCorner(radius: 34, corners: [.topLeft, .topRight])
                                .fill(Color.white)
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: geometry.size.height - headerHeight + cardOverlap + geometry.safeAreaInsets.bottom + 140,
                                    alignment: .top
                                )

                            contentCardContent
                        }
                        .offset(y: -cardOverlap)
                    }
                }
                .ignoresSafeArea(edges: .bottom)

                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, geometry.safeAreaInsets.top + 10)
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showingAudioSteps) {
            RecipeAudioStepView(recipe: recipe)
        }
    }

    private var topBar: some View {
        HStack(spacing: 10) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 52, height: 52)
                    .background(Color.white.opacity(0.94))
                    .clipShape(Circle())
            }

            Spacer(minLength: 8)

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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            HStack(spacing: 28) {
                Label(recipe.prepTime, systemImage: "clock")
                Label("\(portions) portions", systemImage: "person.2")
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 22)
            .padding(.vertical, 12)
            .background(
                Color(red: 210/255, green: 184/255, blue: 160/255).opacity(0.97)
            )
            .clipShape(Capsule())
            .padding(.bottom, 40)
        }
    }

    private var contentCardContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 14) {
                    Text(recipe.title)
                        .font(.system(size: 27, weight: .bold))
                        .foregroundColor(.black)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)
                        .layoutPriority(1)

                    Spacer(minLength: 10)

                    audioButton
                }

                VStack(alignment: .leading, spacing: 14) {
                    Text(recipe.title)
                        .font(.system(size: 27, weight: .bold))
                        .foregroundColor(.black)
                        .lineSpacing(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack {
                        Spacer()
                        audioButton
                    }
                }
            }

            portionsControl

            Picker("", selection: $selectedTab) {
                Text("Ingredients").tag("Ingredients")
                Text("Process").tag("Process")
            }
            .pickerStyle(.segmented)
            .padding(.top, 2)

            if selectedTab == "Ingredients" {
                ingredientsSection
            } else {
                processSection
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 40)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var audioButton: some View {
        Button {
            showingAudioSteps = true
        } label: {
            Label("Audio", systemImage: "speaker.wave.2.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.smartRed)
                .clipShape(Capsule())
        }
        .accessibilityLabel("Open audio mode")
    }

    private var portionsControl: some View {
        HStack(spacing: 0) {
            Button {
                if portions > 1 { portions -= 1 }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.smartRed)
                    .frame(width: 52, height: 52)
                    .contentShape(Rectangle())
            }

            Spacer()

            Text("\(portions) Portions")
                .font(.system(size: 19, weight: .medium))
                .foregroundColor(.black)

            Spacer()

            Button {
                portions += 1
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.smartRed)
                    .frame(width: 52, height: 52)
                    .contentShape(Rectangle())
            }
        }
        .frame(height: 56)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.smartRed.opacity(0.18), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
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

struct RoundedCorner: Shape {
    var radius: CGFloat = 34
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        RecipeDetailPremiumView(recipe: MockRecipeData.sampleRecipe)
            .environmentObject(SavedRecipesManager())
    }
}
