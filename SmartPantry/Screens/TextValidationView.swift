import SwiftUI

struct TextValidationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var aiViewModel = AIRecipeViewModel()

    @State private var extractedText: String
    @State private var notesForAI = ""
    @State private var goToNextStep = false

    init(initialText: String = "") {
        _extractedText = State(initialValue: initialText)
    }

    var cleanedIngredients: [String] {
        extractedText
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Validate Extracted Text")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.smartRed)

                        Text("Correct any scanning mistakes before sending to AI.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Extracted Ingredients")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))

                        TextEditor(text: $extractedText)
                            .frame(height: 220)
                            .padding(10)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.smartRed.opacity(0.25), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.horizontal, 20)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Optional note for AI")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.8))

                        TextField("Example: high protein, budget meal, no dairy", text: $notesForAI)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(Color.smartRed.opacity(0.25), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.horizontal, 20)

                    if !aiViewModel.errorMessage.isEmpty {
                        Text(aiViewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 20)
                    }

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(cleanedIngredients, id: \.self) { item in
                                Text(item)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.smartRed)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.smartRed.opacity(0.10))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    Spacer()

                    VStack(spacing: 12) {
                        Button {
                            Task {
                                let success = await aiViewModel.generateRecipe(from: extractedText, note: notesForAI)
                                if success { goToNextStep = true }
                            }
                        } label: {
                            Text("Send to AI")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.smartRed)
                                .cornerRadius(30)
                        }

                        Button {
                            dismiss()
                        } label: {
                            Text("Back")
                                .font(.headline)
                                .foregroundColor(.smartRed)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.smartRed, lineWidth: 1.5)
                                )
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goToNextStep) {
                if let recipe = aiViewModel.generatedRecipe {
                    AIRecipeResultsView(ingredients: cleanedIngredients, generatedRecipe: recipe)
                }
            }
            .overlay {
                if aiViewModel.isLoading {
                    SmartPantryLoadingView(title: "Generating recipe...", subtitle: "SmartPantry is creating your dish with AI")
                }
            }
        }
    }
}

#Preview {
    TextValidationView(initialText: "Tomato\nGarlic\nRice")
}
