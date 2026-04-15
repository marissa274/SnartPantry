import SwiftUI

struct RecipeAudioStepView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var speechManager = RecipeSpeechManager()

    let recipe: Recipe
    @State private var currentStepIndex = 0

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 0) {

                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.black.opacity(0.8))
                    }

                    Spacer()

                    Text("STEP \(currentStepIndex + 1)/\(recipe.steps.count)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.orange)

                    Spacer()

                    Color.clear.frame(width: 28)
                }
                .padding(.horizontal, 18)
                .padding(.top, 18)
                .padding(.bottom, 20)

                Image(recipe.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 370)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 10)

                HStack {
                    Button {
                        previousStep()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 34))
                            .foregroundColor(currentStepIndex == 0 ? .gray.opacity(0.5) : .gray)
                    }
                    .disabled(currentStepIndex == 0)

                    Spacer()

                    Button {
                        toggleSpeech()
                    } label: {
                        Image(systemName: speechManager.isSpeaking ? "stop.fill" : "speaker.wave.2.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.brown.opacity(0.45))
                    }

                    Spacer()

                    Button {
                        nextStep()
                    } label: {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 34))
                            .foregroundColor(currentStepIndex == recipe.steps.count - 1 ? .gray.opacity(0.5) : .smartRed)
                    }
                    .disabled(currentStepIndex == recipe.steps.count - 1)
                }
                .padding(.horizontal, 58)
                .padding(.top, 22)

                VStack(alignment: .leading, spacing: 22) {
                    highlightedInstructionText(recipe.steps[currentStepIndex])
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black.opacity(0.78))
                        .lineSpacing(8)

                    Button {
                        print("Set timer tapped")
                    } label: {
                        Text("Set the timer")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.smartRed)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 24)

                Spacer()

                HStack(spacing: 10) {
                    ForEach(0..<recipe.steps.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentStepIndex ? Color.smartRed : Color.gray.opacity(0.5))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.bottom, 34)
            }
        }
        .onAppear {
            speechManager.speakStep(recipe.steps[currentStepIndex])
        }
        .onDisappear {
            speechManager.stop()
        }
    }

    private func toggleSpeech() {
        if speechManager.isSpeaking {
            speechManager.stop()
        } else {
            speechManager.speakStep(recipe.steps[currentStepIndex])
        }
    }

    private func previousStep() {
        guard currentStepIndex > 0 else { return }
        currentStepIndex -= 1
        speechManager.speakStep(recipe.steps[currentStepIndex])
    }

    private func nextStep() {
        guard currentStepIndex < recipe.steps.count - 1 else { return }
        currentStepIndex += 1
        speechManager.speakStep(recipe.steps[currentStepIndex])
    }

    @ViewBuilder
    private func highlightedInstructionText(_ text: String) -> some View {
        let wordsToHighlight = ["garlic", "tomatoes", "olive oil", "parmesan"]
        let parts = text.split(separator: " ")

        let fragments: [Text] = parts.map { word -> Text in
            let cleanWord = word.lowercased()
            let shouldHighlight = wordsToHighlight.contains { cleanWord.contains($0) }
            let piece = Text(word + " ")
            return shouldHighlight ? piece.foregroundColor(.orange) : piece.foregroundColor(.black.opacity(0.78))
        }

        fragments.dropFirst().reduce(fragments.first ?? Text(""), +)
    }
}
#Preview {
    RecipeAudioStepView(recipe: MockRecipeData.sampleRecipe)
}
