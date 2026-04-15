import Foundation
import Combine
import SwiftUI

@MainActor
final class PantryViewModel: ObservableObject {
    @Published var recipes: [RecipeListItem] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    private let recipeService: RecipeServiceProtocol

    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }

    func loadRecipes() async {
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }

        do {
            recipes = try await recipeService.fetchRecipes()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteRecipe(at offsets: IndexSet) async {
        let itemsToDelete = offsets.map { recipes[$0] }
        do {
            for item in itemsToDelete {
                try await recipeService.deleteRecipe(id: item.id)
            }
            recipes.remove(atOffsets: offsets)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
