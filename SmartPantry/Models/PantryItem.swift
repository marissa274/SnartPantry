import SwiftUI

struct PantryItem: Identifiable {
    let id: UUID
    let name: String
    let quantity: String
    let location: String
    let icon: String

    init(id: UUID = UUID(), name: String, quantity: String, location: String, icon: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.location = location
        self.icon = icon
    }
}
