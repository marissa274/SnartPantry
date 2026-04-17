import SwiftUI
import PhotosUI

struct ProfileView: View {

    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var savedRecipesManager: SavedRecipesManager

    @State private var selectedSection = "Saved"

    @State private var selectedPhotoItem: PhotosPickerItem?
    @AppStorage("profilePhotoBase64") private var profilePhotoBase64: String = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                header
                userInfoSection
                profileActions
                recipesSection
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
            sectionButton("Saved", isSelected: selectedSection == "Saved")
            sectionButton("About", isSelected: selectedSection == "About")

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
        .padding(.horizontal, 16)
    }

    private func sectionButton(_ title: String, isSelected: Bool) -> some View {
        Button {
            selectedSection = title
        } label: {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.15))
                .clipShape(Capsule())
        }
    }

    private var recipesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(selectedSection == "Saved" ? "Saved recipes" : "Listening history")
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal, 20)
                .padding(.top, 28)

            let items = selectedSection == "Saved"
            ? savedRecipesManager.savedRecipes
            : savedRecipesManager.listenedHistory

            if items.isEmpty {
                Text(selectedSection == "Saved"
                     ? "Aucune recette sauvegardée pour le moment."
                     : "Aucune recette écoutée pour le moment.")
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.top, 6)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        HStack(spacing: 12) {
                            recipeImage(item)
                                .frame(width: 56, height: 56)
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            Text(item.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                .lineLimit(2)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.bottom, 26)
    }

    @ViewBuilder
    private func recipeImage(_ item: ProfileRecipeItem) -> some View {
        if let remote = normalizedRemoteImageURL(item.remoteImageURL),
           let url = URL(string: remote) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.1)
                        ProgressView()
                    }
                case .failure:
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                @unknown default:
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                }
            }
        } else {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
        }
    }

    private func normalizedRemoteImageURL(_ rawURL: String?) -> String? {
        guard let raw = rawURL?.trimmingCharacters(in: .whitespacesAndNewlines),
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

#Preview {
    ProfileView()
        .environmentObject(AppState())
        .environmentObject(SavedRecipesManager())
}
