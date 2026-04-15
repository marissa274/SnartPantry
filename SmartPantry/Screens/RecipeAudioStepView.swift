import SwiftUI

struct RecipeAudioStepView: View {
    @Environment(\.dismiss) private var dismiss
    
    let recipe: Recipe
    @State private var currentStep: Int = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 24) {
                
                // Top bar
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Circle()
                            .fill(Color.gray.opacity(0.08))
                            .frame(width: 52, height: 52)
                            .overlay(
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.black)
                            )
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Text("STEP \(currentStep + 1)/\(recipe.steps.count)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.orange)

                // Dynamic image
                recipeHeaderImage
                    .frame(height: 330)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 20)

                HStack {
                    Button {
                        if currentStep > 0 { currentStep -= 1 }
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 34))
                        .foregroundColor(Color(red: 223/255, green: 205/255, blue: 193/255))

                    Spacer()

                    Button {
                        if currentStep < recipe.steps.count - 1 { currentStep += 1 }
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.smartRed)
                    }
                }
                .padding(.horizontal, 70)

                VStack(alignment: .leading, spacing: 18) {
                    Text(recipe.steps[currentStep])
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Set the timer")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.smartRed)
                }
                .padding(.horizontal, 28)

                HStack(spacing: 12) {
                    ForEach(0..<recipe.steps.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentStep ? Color.smartRed : Color.gray.opacity(0.35))
                            .frame(width: 14, height: 14)
                    }
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var recipeHeaderImage: some View {
        if let imageURL = normalizedRemoteImageURL,
           let url = URL(string: imageURL) {
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty:
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.gray.opacity(0.08))
                        .overlay(ProgressView())
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
    RecipeAudioStepView(recipe: MockRecipeData.sampleRecipe)
}
