import Foundation

struct HomeRecipeItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let time: String
}
