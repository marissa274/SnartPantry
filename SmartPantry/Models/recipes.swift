import Foundation

struct Recipe: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageName: String
    let prepTime: String
    let servings: String
    let ingredients: [String]
    let steps: [String]
    var isSaved: Bool
    var remoteImageURL: String? = nil
}
