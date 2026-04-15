import SwiftUI

struct MockPantryData {
    static let items: [PantryItem] = [
        PantryItem(name: "Milk", quantity: "1 bottle", location: "Fridge", icon: "carton.fill"),
        PantryItem(name: "Eggs", quantity: "12 units", location: "Fridge", icon: "circle.fill"),
        PantryItem(name: "Tomatoes", quantity: "6 pcs", location: "Fridge", icon: "leaf.fill"),
        PantryItem(name: "Pasta", quantity: "2 packs", location: "Pantry", icon: "fork.knife"),
        PantryItem(name: "Chicken", quantity: "1 tray", location: "Fridge", icon: "flame.fill"),
        PantryItem(name: "Rice", quantity: "1 bag", location: "Pantry", icon: "shippingbox.fill"),
        PantryItem(name: "Yogurt", quantity: "4 cups", location: "Fridge", icon: "cup.and.saucer.fill")
    ]
}
