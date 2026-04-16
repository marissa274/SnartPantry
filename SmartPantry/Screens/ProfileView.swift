import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject private var appState: AppState
    
    @State private var selectedTab = "Ingredients"
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @AppStorage("profilePhotoBase64") private var profilePhotoBase64: String = ""

    private let tabs = ["Ingredients", "Recipes", "Collections"]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(spacing: 0) {
                
                header

                userInfoSection

                profileActions

                tabSection
          
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
        
        .task(id: selectedPhotoItem) {
                   await loadSelectedPhoto()
               }
           }

           private var header: some View {
               ZStack(alignment: .bottom) {
                   LinearGradient(
                       colors: [Color.smartRed.opacity(0.85), Color.orange.opacity(0.7)],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   )
                   .frame(height: 180)

                   VStack(spacing: 8) {
                       profileImage

                       PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                           Text("Changer la photo")
                               .font(.system(size: 13, weight: .semibold))
                               .foregroundColor(.smartRed)
                               .padding(.horizontal, 12)
                               .padding(.vertical, 8)
                               .background(Color.white)
                               .clipShape(Capsule())
                       }
                   }
                   .offset(y: 62)
               }
           }

           @ViewBuilder
           private var profileImage: some View {
               if let image = profileUIImage {
                   Image(uiImage: image)
                       .resizable()
                       .scaledToFill()
                       .frame(width: 110, height: 110)
                       .clipShape(Circle())
                       .overlay(Circle().stroke(Color.white, lineWidth: 6))
               } else {
                   Image(systemName: "person.crop.circle.fill")
                       .resizable()
                       .scaledToFill()
                       .frame(width: 110, height: 110)
                       .foregroundStyle(Color.white, Color.smartRed.opacity(0.4))
                       .background(Color.white)
                       .clipShape(Circle())
                       .overlay(Circle().stroke(Color.white, lineWidth: 6))
               }
           }

           private var userInfoSection: some View {
               VStack(spacing: 8) {
                   Text(appState.currentUser?.name ?? "Utilisateur")
                       .font(.system(size: 26, weight: .bold))

                   Text(appState.currentUser?.email ?? "Aucun email")
                       .font(.system(size: 16))
                       .foregroundColor(.gray)

                   Text(memberSinceText)
                       .font(.system(size: 14, weight: .medium))
                       .foregroundColor(.gray)
               }
               .padding(.top, 82)
           }

           private var memberSinceText: String {
               guard let createdAt = appState.currentUser?.createdAt,
                     let date = ISO8601DateFormatter().date(from: createdAt) else {
                   return "Membre SmartPantry"
               }

               return "Membre depuis \(date.formatted(date: .abbreviated, time: .omitted))"
           }

           private var profileActions: some View {
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

                   Button {
                       appState.logout()
                   } label: {
                       Text("Logout")
                           .font(.system(size: 16, weight: .medium))
                           .foregroundColor(.white)
                           .padding(.horizontal, 18)
                           .padding(.vertical, 10)
                           .background(Color.smartRed)
                           .clipShape(Capsule())
                   }
               }
               .padding(.top, 16)
           }

           private var tabSection: some View {
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
           }

           private var profileUIImage: UIImage? {
               guard !profilePhotoBase64.isEmpty,
                     let data = Data(base64Encoded: profilePhotoBase64),
                     let image = UIImage(data: data) else {
                   return nil
               }

               return image
           }

           private func loadSelectedPhoto() async {
               guard let selectedPhotoItem else { return }

               if let imageData = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                   profilePhotoBase64 = imageData.base64EncodedString()
               }
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
        .environmentObject(AppState())
}
