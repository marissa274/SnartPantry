import SwiftUI
import Combine

struct RecipeAudioStepView: View {
    @Environment(\.dismiss) private var dismiss

    let recipe: Recipe

    @State private var currentStep: Int = 0
    @StateObject private var speechManager = RecipeSpeechManager()

    @State private var isAutoPlaying = true

    private let autoAdvanceTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    private var hasSteps: Bool {
        !recipe.steps.isEmpty
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text(recipe.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.smartRed)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                if hasSteps {
                    Text("STEP \(currentStep + 1)/\(recipe.steps.count)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.orange)
                } else {
                    Text("No audio steps available")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.orange)
                }

                recipeHeaderImage
                    .frame(height: 290)
                    .frame(maxWidth: .infinity)
                    .clipped()

                HStack {
                    Button {
                        guard hasSteps, currentStep > 0 else { return }
                        currentStep -= 1
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(currentStep == 0 ? .gray.opacity(0.4) : .gray)
                    }
                    .disabled(!hasSteps || currentStep == 0)

                    Spacer()

                    Button {
                        toggleSpeech()
                    } label: {
                        Image(systemName: isAutoPlaying ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .font(.system(size: 36))
                            .foregroundColor(
                                isAutoPlaying
                                ? .smartRed
                                : Color(red: 223/255, green: 205/255, blue: 193/255)
                            )
                    }
                    .disabled(!hasSteps)

                    Spacer()

                    Button {
                        guard hasSteps, currentStep < recipe.steps.count - 1 else { return }
                        currentStep += 1
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 30, weight: .medium))
                            .foregroundColor(currentStep >= recipe.steps.count - 1 ? .gray.opacity(0.4) : .smartRed)
                    }
                    .disabled(!hasSteps || currentStep >= recipe.steps.count - 1)
                }
                .padding(.horizontal, 28)

                VStack(alignment: .leading, spacing: 18) {
                    Text(hasSteps ? recipe.steps[currentStep] : "Return to recipe details and switch to Process to review steps.")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(isAutoPlaying ? "Lecture automatique toutes les 10 secondes" : "Lecture arrêtée")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.smartRed)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)

                if hasSteps {
                    HStack(spacing: 12) {
                        ForEach(0..<recipe.steps.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentStep ? Color.smartRed : Color.gray.opacity(0.3))
                                .frame(width: 14, height: 14)
                        }
                    }
                    .padding(.top, 4)
                }

                Spacer()
            }
            .padding(.top, 74)
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.black)
                        .frame(width: 52, height: 52)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(Circle())
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 6)
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startAutoPlayback()
        }
        .onChange(of: currentStep) { _, newValue in
            guard hasSteps, isAutoPlaying else { return }
            speechManager.speakStep(recipe.steps[newValue])
        }
        .onReceive(autoAdvanceTimer) { _ in
            guard hasSteps, isAutoPlaying else { return }

            if currentStep < recipe.steps.count - 1 {
                currentStep += 1
            } else {
                isAutoPlaying = false
                speechManager.stop()
            }
        }
        .onDisappear {
            isAutoPlaying = false
            speechManager.stop()
        }
    }

    private func startAutoPlayback() {
        guard hasSteps else { return }
        isAutoPlaying = true
        speechManager.prepareForPlayback()
        speechManager.speakStep(recipe.steps[currentStep])
    }

    private func toggleSpeech() {
        guard hasSteps else { return }

        if isAutoPlaying {
            isAutoPlaying = false
            speechManager.stop()
        } else {
            isAutoPlaying = true
            speechManager.speakStep(recipe.steps[currentStep])
        }
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
        RecipeAudioStepView(recipe: MockRecipeData.sampleRecipe)
    }
}
