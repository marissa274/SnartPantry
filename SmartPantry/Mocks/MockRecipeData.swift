import Foundation

struct MockRecipeData {
    static let sampleRecipe = Recipe(
        title: "Creamy Garlic Pasta",
        imageName: "pasta_recipe",
        prepTime: "20 min",
        servings: "2 servings",
        ingredients: [
            "200g pasta",
            "2 cloves garlic",
            "1 cup cream",
            "1/2 cup parmesan",
            "1 tbsp olive oil",
            "Salt",
            "Black pepper"
        ],
        steps: [
            "Boil the pasta in salted water until al dente.",
            "Heat olive oil in a pan and sauté the garlic.",
            "Add the cream and stir gently.",
            "Add parmesan, salt, and pepper.",
            "Mix in the cooked pasta.",
            "Serve hot and enjoy."
        ],
        isSaved: true
    )
}
