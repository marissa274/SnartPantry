import SwiftUI

struct AIRecipeCardView: View {
    let recipe: Recipe

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(recipe.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 110, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 10) {
                Text(recipe.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black.opacity(0.75))

                Text(recipeDescription(for: recipe))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .lineLimit(3)

                HStack(spacing: 18) {
                    Label(difficulty(for: recipe), systemImage: "chart.bar.fill")
                    Label(recipe.prepTime, systemImage: "clock")
                    Label(calories(for: recipe), systemImage: "flame.fill")
                }
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black.opacity(0.7))
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func recipeDescription(for recipe: Recipe) -> String {
        switch recipe.title {
        case "Vegetables Shrimps Pasta":
            return "A hearty mix of shrimp, pasta, spinach, and pesto — rich in protein and full of balanced nutrition."
        case "Shrimp Fried Rice Bowl":
            return "Juicy shrimp meets fragrant rice, garlic, and chili, high protein comfort meal with a spicy twist."
        case "Shrimp Tempura Curry":
            return "Golden, crispy shrimp tempura with creamy Japanese curry — your cozy bowl of happiness."
        default:
            return "A delicious recipe generated from your scanned ingredients."
        }
    }

    private func difficulty(for recipe: Recipe) -> String {
        switch recipe.title {
        case "Vegetables Shrimps Pasta": return "Easy"
        case "Shrimp Fried Rice Bowl": return "Medium"
        default: return "Hard"
        }
    }

    private func calories(for recipe: Recipe) -> String {
        switch recipe.title {
        case "Vegetables Shrimps Pasta": return "610 kcal"
        case "Shrimp Fried Rice Bowl": return "520 kcal"
        default: return "480 kcal"
        }
    }
 }


#Preview {
    AIRecipeCardView(
        recipe: Recipe(
            title: "Vegetables Shrimps Pasta",
            imageName: "pasta_recipe",
            prepTime: "30 min",
            servings: "3",
            ingredients: ["Pasta", "Shrimp", "Spinach", "Pesto"],
            steps: ["Boil pasta", "Cook shrimp", "Combine"],
            isSaved: false
        )
    )
}
