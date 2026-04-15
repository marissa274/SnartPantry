import Foundation

struct MockAIRecipesData {
    static let items: [Recipe] = [
        Recipe(
            title: "Vegetables Shrimps Pasta",
            imageName: "ai_recipe_1",
            prepTime: "25 Min",
            servings: "2 servings",
            ingredients: ["Shrimp", "Spinach", "Egg", "Pasta"],
            steps: [
                "Boil the pasta until al dente.",
                "Cook shrimp with spinach and garlic.",
                "Mix everything together and serve."
            ],
            isSaved: false
        ),
        Recipe(
            title: "Shrimp Fried Rice Bowl",
            imageName: "ai_recipe_2",
            prepTime: "15 Min",
            servings: "2 servings",
            ingredients: ["Shrimp", "Rice", "Egg", "Chili"],
            steps: [
                "Cook the shrimp in a hot pan.",
                "Add rice, egg, and chili.",
                "Stir well and serve warm."
            ],
            isSaved: false
        ),
        Recipe(
            title: "Shrimp Tempura Curry",
            imageName: "ai_recipe_3",
            prepTime: "30 Min",
            servings: "2 servings",
            ingredients: ["Shrimp", "Curry", "Rice"],
            steps: [
                "Prepare the tempura shrimp.",
                "Heat the curry sauce.",
                "Serve together with rice."
            ],
            isSaved: false
        )
    ]
}
