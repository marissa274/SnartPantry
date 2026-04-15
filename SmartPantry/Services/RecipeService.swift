import Foundation

struct MealDBSearchResponse: Decodable {
    let meals: [MealDBMeal]?
}

struct MealDBMeal: Decodable {
    let strMealThumb: String?
}

protocol RecipeServiceProtocol {
    func generateRecipe(input: String, prompt: String) async throws -> AIRecipeResponse
    func fetchRecipes() async throws -> [RecipeListItem]
    func fetchRecipe(id: String) async throws -> RecipeListItem
    func saveRecipe(_ recipe: AIRecipeResponse) async throws
    func deleteRecipe(id: String) async throws
}

final class RecipeService: RecipeServiceProtocol {
    private let apiClient: APIClientProtocol
    private let imageService: RecipeImageService

    init(
        apiClient: APIClientProtocol = APIClient(),
        imageService: RecipeImageService = RecipeImageService()
    ) {
        self.apiClient = apiClient
        self.imageService = imageService
    }

    func generateRecipe(input: String, prompt: String) async throws -> AIRecipeResponse {
        let schema = RecipeSchemaFactory.recipeSchema

        let payload = AIRecipeRequest(
            input: input,
            prompt: prompt,
            schemaName: "recipe_result",
            schema: schema
        )

        let envelope: AIRecipeEnvelope = try await apiClient.request(.ai, body: payload)
        var recipe = envelope.data

        do {
            let query = recipe.ingredients.prefix(3).joined(separator: " ")
            recipe.imageURL = try await imageService.fetchImageURL(for: query)
        } catch {
            print("Erreur récupération image: \(error.localizedDescription)")
            recipe.imageURL = nil
        }

        return recipe
    }

    func fetchRecipes() async throws -> [RecipeListItem] {
        let response: RecipesResponse = try await apiClient.requestWithoutBody(.recipes)
        return response.recipes
    }

    func fetchRecipe(id: String) async throws -> RecipeListItem {
        try await apiClient.requestWithoutBody(.recipe(id: id))
    }

    func saveRecipe(_ recipe: AIRecipeResponse) async throws {
        let payload = SavedRecipePayload(
            title: recipe.title,
            data: recipe.asRecipeData
        )
        try await apiClient.requestVoid(.addRecipe, body: payload)
    }

    func deleteRecipe(id: String) async throws {
        try await apiClient.requestVoid(.deleteRecipe(id: id))
    }
}
