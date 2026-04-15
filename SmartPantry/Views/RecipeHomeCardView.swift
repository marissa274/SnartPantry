import SwiftUI

struct RecipeHomeCardView: View {
    let recipe: HomeRecipeItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                ZStack(alignment: .topLeading) {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 230)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                        Text(recipe.time)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.black.opacity(0.75))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.85))
                    .clipShape(Capsule())
                    .padding(12)
                }
                
                Text("+ Add to planner")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.smartRed.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(12)
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(recipe.title)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundColor(.black.opacity(0.8))
                    
                    Text(recipe.subtitle)
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                Image(systemName: "bookmark")
                    .foregroundColor(.smartRed)
                    .font(.title3)
            }
        }
    }
}

#Preview {
    RecipeHomeCardView(recipe: MockRecipesHomeData.items[0])
        .padding()
}
