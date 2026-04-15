import SwiftUI

struct AIRecipeResultsView: View {
    @EnvironmentObject private var savedRecipesManager: SavedRecipesManager
    @StateObject private var saveViewModel = AIRecipeViewModel()

    let ingredients: [String]
    let generatedRecipe: AIRecipeResponse

    @State private var goToDetail = false
    @State private var showSuccess = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(red: 248/255, green: 241/255, blue: 230/255)
                .ignoresSafeArea()

            VStack(spacing: 16) {

                // 🔥 HEADER
                VStack(spacing: 8) {
                    Text("Your recipe is ready")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.smartRed)

                    Text("SmartPantry created something delicious for you")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)

                // 🔥 IMAGE (NEW)
                if let imageURL = normalizedImageURL,
                   let url = URL(string: imageURL) {

                    AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            case .empty:
                                                RoundedRectangle(cornerRadius: 24)
                                                    .fill(Color.gray.opacity(0.1))
                                                    .overlay(ProgressView())
                                            case .failure:
                                                fallbackImage
                                            @unknown default:
                                                fallbackImage
                                            }
                        
                        
                        
                    }
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal, 20)

                } else {
                    // fallback
                    fallbackImage
                }

                // 🔥 INGREDIENTS SCROLLER
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ingredients, id: \.self) { ingredient in
                            Text(ingredient)
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                                .padding(.horizontal, 18)
                                .padding(.vertical, 10)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                }

                // 🔥 RECIPE CARD
                VStack(alignment: .leading, spacing: 14) {

                    Text(generatedRecipe.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black.opacity(0.85))

                    Text(generatedRecipe.summary)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    HStack(spacing: 16) {
                        Label(generatedRecipe.cookTime, systemImage: "clock")
                        Label("\(generatedRecipe.servings) servings", systemImage: "person.2")
                    }
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.smartRed)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.horizontal, 20)

                // 🔥 BUTTONS
                VStack(spacing: 14) {

                    Button {
                        goToDetail = true
                    } label: {
                        Text("View Full Recipe")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.smartRed)
                            .clipShape(Capsule())
                    }

                    Button {
                        Task {
                            saveViewModel.generatedRecipe = generatedRecipe
                            let success = await saveViewModel.saveCurrentRecipe()
                            showSuccess = success
                        }
                    } label: {
                        Text("Add to Pantry")
                            .font(.headline)
                            .foregroundColor(.smartRed)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(Color.smartRed, lineWidth: 1.5)
                            )
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 20)

                if !saveViewModel.errorMessage.isEmpty {
                    Text(saveViewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }

                Spacer()
            }
        }
        .navigationDestination(isPresented: $goToDetail) {
            RecipeDetailPremiumView(recipe: generatedRecipe.asUIRecipe)
                .environmentObject(savedRecipesManager)
        }
        .sheet(isPresented: $showSuccess) {
            SmartPantryFeedbackView(
                title: "Recipe added",
                message: "Your recipe has been saved to your pantry successfully.",
                icon: "checkmark.circle.fill",
                buttonTitle: "Continue"
            ) {
                showSuccess = false
            }
        }
        .overlay {
            if saveViewModel.isLoading {
                SmartPantryLoadingView(
                    title: "Saving recipe...",
                    subtitle: "SmartPantry is adding it to your pantry"
                )
            }
            
            
        }
    }
    
    private var normalizedImageURL: String? {
           guard let raw = generatedRecipe.imageURL?.trimmingCharacters(in: .whitespacesAndNewlines),
                 !raw.isEmpty else {
               return nil
           }

           if raw.hasPrefix("//") {
               return "https:\(raw)"
           }

           if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://") {
               return raw
           }

           return "https://\(raw)"
       }

       private var fallbackImage: some View {
           Image("food")
               .resizable()
               .scaledToFill()
               .frame(height: 220)
               .clipShape(RoundedRectangle(cornerRadius: 24))
               .padding(.horizontal, 20)
       }
}
#Preview {
    NavigationStack {
        AIRecipeResultsView(
            ingredients: ["Tomato", "Garlic"],
            generatedRecipe: AIRecipeResponse(
                title: "Tomato Garlic Pasta",
                summary: "A quick cozy pasta recipe.",
                ingredients: ["Tomato", "Garlic", "Pasta"],
                steps: ["Boil pasta", "Cook garlic", "Mix everything"],
                cookTime: "20 min",
                servings: 2
            )
        )
        .environmentObject(SavedRecipesManager())
    }
}
