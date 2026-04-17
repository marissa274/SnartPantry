import Foundation
import SwiftUI
import Combine

struct ProfileRecipeItem: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let imageName: String
    let remoteImageURL: String?

    init(recipe: Recipe) {
        self.id = recipe.title
        self.title = recipe.title
        self.imageName = recipe.imageName
        self.remoteImageURL = recipe.remoteImageURL
    }
}

final class SavedRecipesManager: ObservableObject {
    @Published private(set) var savedRecipes: [ProfileRecipeItem] = []
    @Published private(set) var listenedHistory: [ProfileRecipeItem] = []

    private let savedKey = "saved_recipes_profile"
    private let historyKey = "listened_recipes_profile"

    init() {
        savedRecipes = Self.loadItems(forKey: savedKey)
        listenedHistory = Self.loadItems(forKey: historyKey)
    }

    func isSaved(_ recipe: Recipe) -> Bool {
        savedRecipes.contains(where: { $0.id == recipe.title })
    }

    func toggleSaved(_ recipe: Recipe) {
        let item = ProfileRecipeItem(recipe: recipe)

        if let index = savedRecipes.firstIndex(where: { $0.id == item.id }) {
            savedRecipes.remove(at: index)
        } else {
            savedRecipes.insert(item, at: 0)
        }

        persist(savedRecipes, forKey: savedKey)
    }

    func markSaved(_ recipe: Recipe) {
        let item = ProfileRecipeItem(recipe: recipe)
        guard !savedRecipes.contains(where: { $0.id == item.id }) else { return }

        savedRecipes.insert(item, at: 0)
        persist(savedRecipes, forKey: savedKey)
    }

    func addToHistory(_ recipe: Recipe) {
        let item = ProfileRecipeItem(recipe: recipe)

        listenedHistory.removeAll(where: { $0.id == item.id })
        listenedHistory.insert(item, at: 0)

        if listenedHistory.count > 100 {
            listenedHistory = Array(listenedHistory.prefix(100))
        }

        persist(listenedHistory, forKey: historyKey)
    }

    private static func loadItems(forKey key: String) -> [ProfileRecipeItem] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([ProfileRecipeItem].self, from: data) else {
            return []
        }

        return decoded
    }

    private func persist(_ items: [ProfileRecipeItem], forKey key: String) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
