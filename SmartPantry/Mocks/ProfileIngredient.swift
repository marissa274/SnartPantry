import Foundation
struct ProfileIngredient: Identifiable {
    let id = UUID()
    let name: String
    let image: String
}

struct MockProfileIngredients {
    static let items: [ProfileIngredient] = [
        .init(name: "Carob", image: "ingredient1"),
        .init(name: "Tomato", image: "ingredient2"),
        .init(name: "Spinach", image: "ingredient3"),
        .init(name: "Shrimp", image: "ingredient4")
    ]
}

struct ProfileRecipe: Identifiable {
    let id = UUID()
    let title: String
    let image: String
}

struct MockProfileRecipes {
    static let items: [ProfileRecipe] = [
        .init(title: "Shrimp Pasta", image: "recipe1"),
        .init(title: "Healthy Bowl", image: "recipe2")
    ]
}
