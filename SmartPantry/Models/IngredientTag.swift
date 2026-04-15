import SwiftUI

struct IngredientTag: Identifiable {
    let id = UUID()
    let name: String
    let x: CGFloat   // normalized 0...1
    let y: CGFloat   // normalized 0...1
}
