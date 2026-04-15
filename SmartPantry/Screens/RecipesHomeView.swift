import SwiftUI

struct RecipesHomeView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "Healthy"
    
    let categories = [
        "Healthy (208)",
        "Breakfast (78)",
        "Lunch (228)",
        "Snacks (88)"
    ]
    
    let ingredients = [
        "Chicken",
        "Lettuce",
        "Cherry Tomato"
    ]
    
    let recipes = MockRecipesHomeData.items
    
    // Convert a lightweight HomeRecipeItem into a full Recipe for the detail screen.
    private func detailRecipe(from item: HomeRecipeItem) -> Recipe {
        let base = MockRecipeData.sampleRecipe
        return Recipe(
            title: item.title,
            imageName: item.imageName,
            prepTime: item.time,
            servings: base.servings,
            ingredients: base.ingredients,
            steps: base.steps,
            isSaved: base.isSaved
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Search bar
                        HStack(spacing: 12) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("I want to make..", text: $searchText)
                                    .textFieldStyle(.plain)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            
                            Button {
                                print("Filters tapped")
                            } label: {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.smartRed)
                                    .frame(width: 44, height: 44)
                                    .background(Color.gray.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                        .padding(.top, 12)
                        
                        // Categories
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(categories, id: \.self) { category in
                                    let isSelected = selectedCategory == category
                                    
                                    Button {
                                        selectedCategory = category
                                    } label: {
                                        Text(category)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundColor(isSelected ? .white : .smartRed)
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 12)
                                            .background(
                                                isSelected
                                                ? Color.smartRed
                                                : Color.white
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(Color.smartRed, lineWidth: 1.5)
                                            )
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                        
                        // Ingredients section
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Use up the ingredients you have")
                                .font(.title3.weight(.semibold))
                                .foregroundColor(.gray.opacity(0.8))
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    Button {
                                        print("Add ingredient")
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: "plus")
                                            Text("Add")
                                        }
                                        .font(.headline)
                                        .foregroundColor(.smartRed)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 10)
                                        .background(Color.smartRed.opacity(0.10))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    
                                    ForEach(ingredients, id: \.self) { ingredient in
                                        Text(ingredient)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 10)
                                            .background(Color.smartRed.opacity(0.75))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                            }
                        }
                        
                        // Section title
                        Text("Find handpicked recipes for you")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black.opacity(0.8))
                        
                        // Cards
                        VStack(spacing: 24) {
                            ForEach(recipes) { recipe in
                                NavigationLink {
                                    RecipeDetailPremiumView(recipe: detailRecipe(from: recipe))
                                } label: {
                                    RecipeHomeCardView(recipe: recipe)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                
                
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    RecipesHomeView()
}
