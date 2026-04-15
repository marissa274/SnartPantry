import SwiftUI

struct ProfileView: View {
    
    @State private var selectedTab = "Ingredients"
    
    let tabs = ["Ingredients", "Recipes", "Collections"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 0) {
                
                // 🔴 HEADER IMAGE
                ZStack(alignment: .bottom) {
                    
                    Image("profile_cover")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .clipped()
                    
                    // 👤 PROFILE IMAGE
                    Image("profile_avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                        )
                        .offset(y: 55)
                }
                
                // 🔤 NAME + INFO
                VStack(spacing: 6) {
                    Text("John Smith")
                        .font(.system(size: 26, weight: .bold))
                    
                    Text("Member since April 2020")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top, 70)
                
                // ❤️ BUTTONS
                HStack(spacing: 14) {
                    
                    Text("Liked")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.orange)
                        .clipShape(Capsule())
                    
                    Text("About")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                    
                    Text("Collections")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                }
                .padding(.top, 14)
                
                // 🧭 TABS
                HStack(spacing: 30) {
                    ForEach(tabs, id: \.self) { tab in
                        VStack(spacing: 6) {
                            Text(tab)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(selectedTab == tab ? .smartRed : .gray)
                            
                            Rectangle()
                                .fill(selectedTab == tab ? Color.orange : Color.clear)
                                .frame(height: 3)
                                .frame(width: 40)
                        }
                        .onTapGesture {
                            selectedTab = tab
                        }
                    }
                }
                .padding(.top, 24)
                
                // 📦 CONTENT
                if selectedTab == "Ingredients" {
                    ingredientsGrid
                } else if selectedTab == "Recipes" {
                    recipesGrid
                } else {
                    collectionsGrid
                }
            }
        }
        .background(Color.white)
    }
}
private var ingredientsGrid: some View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    return LazyVGrid(columns: columns, spacing: 16) {
        ForEach(MockProfileIngredients.items) { item in
            VStack {
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.smartRed)
            }
        }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
}

private var recipesGrid: some View {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    return LazyVGrid(columns: columns, spacing: 16) {
        ForEach(MockProfileRecipes.items) { recipe in
            VStack(alignment: .leading) {
                Image(recipe.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(recipe.title)
                    .font(.system(size: 16, weight: .bold))
            }
        }
    }
    .padding(.horizontal, 20)
    .padding(.top, 20)
}

private var collectionsGrid: some View {
    VStack(spacing: 16) {
        Text("No collections yet")
            .foregroundColor(.gray)
    }
    .padding(.top, 40)
}

#Preview {
    ProfileView()
}
