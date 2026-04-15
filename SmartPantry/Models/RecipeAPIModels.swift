import Foundation

struct AIRecipeRequest: Encodable {
    let input: String
    let prompt: String
    let schemaName: String
    let schema: [String: JSONValue]
}

struct SavedRecipePayload: Encodable {
    let title: String
    let data: RecipeData
}

// MARK: - Recipes GET /smartpantry/recipes response wrapper
struct RecipesResponse: Codable {
    let recipes: [RecipeListItem]
}

// MARK: - Single saved recipe item
struct RecipeListItem: Codable, Identifiable {
    let id: String
    let title: String
    let data: RecipeData
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case data
        case createdAt
    }
}

struct RecipeData: Codable {
    let title: String
    let summary: String
    let ingredients: [String]
    let steps: [String]
    let cookTime: String
    let servings: Int
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case ingredients
        case steps
        case servings
        case imageURL = "image_url"
        case cookTime = "cook_time"
    }
}

// MARK: - AI POST /smartpantry/ai response wrapper
struct AIRecipeEnvelope: Codable {
    let data: AIRecipeResponse
}

struct AIRecipeResponse: Codable {
    let title: String
    let summary: String
    let ingredients: [String]
    let steps: [String]
    let cookTime: String
    let servings: Int
    var imageURL: String?

    enum CodingKeys: String, CodingKey {
        case title
        case summary
        case ingredients
        case steps
        case servings
        case imageURL = "image_url"
        case cookTime = "cook_time"
    }

    var asRecipeData: RecipeData {
        RecipeData(
            title: title,
            summary: summary,
            ingredients: ingredients,
            steps: steps,
            cookTime: cookTime,
            servings: servings,
            imageURL: imageURL
        )
    }

    var asUIRecipe: Recipe {
        Recipe(
            title: title,
            imageName: "food",
            prepTime: cookTime,
            servings: "\(servings)",
            ingredients: ingredients,
            steps: steps,
            isSaved: false,
            remoteImageURL: imageURL
        )
    }
}

extension RecipeListItem {
    var asUIRecipe: Recipe {
        Recipe(
            title: data.title,
            imageName: "food",
            prepTime: data.cookTime,
            servings: "\(data.servings)",
            ingredients: data.ingredients,
            steps: data.steps,
            isSaved: false,
            remoteImageURL: data.imageURL
        )
    }
}
