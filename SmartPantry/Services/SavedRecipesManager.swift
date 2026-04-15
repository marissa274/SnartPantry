import Foundation
import SwiftUI
import Combine

final class SavedRecipesManager: ObservableObject {
    @Published var savedRecipeTitles: Set<String> = []

    func isSaved(_ recipe: Recipe) -> Bool {
        savedRecipeTitles.contains(recipe.title)
    }

    func toggleSaved(_ recipe: Recipe) {
        if savedRecipeTitles.contains(recipe.title) {
            savedRecipeTitles.remove(recipe.title)
        } else {
            savedRecipeTitles.insert(recipe.title)
        }
    }
}
