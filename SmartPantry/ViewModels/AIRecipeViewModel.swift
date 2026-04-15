import Foundation
import Combine


extension Notification.Name {
    static let recipeDidSaveToPantry = Notification.Name("recipeDidSaveToPantry")
}

@MainActor
final class AIRecipeViewModel: ObservableObject {
    @Published var prompt = "Create a simple recipe in French with a title, a short summary, ingredients, steps, cook time and number of servings."
    @Published var generatedRecipe: AIRecipeResponse?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var successMessage = ""

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }

    func generateRecipe(from extractedText: String, note: String = "") async -> Bool {
        guard !extractedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "There is no extracted text to send to AI."
            return false
        }

        let finalPrompt = note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? prompt
            : "\(prompt) Additional note: \(note)"

        isLoading = true
        errorMessage = ""
        successMessage = ""
        defer { isLoading = false }

        do {
            generatedRecipe = try await recipeService.generateRecipe(input: extractedText, prompt: finalPrompt)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func saveCurrentRecipe() async -> Bool {
        guard let generatedRecipe else {
            errorMessage = "No recipe available to save."
            return false
        }

        isLoading = true
        errorMessage = ""
        successMessage = ""
        defer { isLoading = false }

        do {
            try await recipeService.saveRecipe(generatedRecipe)
            successMessage = "Recipe added to your pantry."
            NotificationCenter.default.post(name: .recipeDidSaveToPantry, object: nil)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
