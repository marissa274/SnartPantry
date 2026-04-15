import SwiftUI

struct EditPantryItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var quantity: String
    @State private var location: String
    
    let item: PantryItem
    let onSave: (PantryItem) -> Void
    
    init(item: PantryItem, onSave: @escaping (PantryItem) -> Void) {
        self.item = item
        self.onSave = onSave
        _name = State(initialValue: item.name)
        _quantity = State(initialValue: item.quantity)
        _location = State(initialValue: item.location)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Product Info") {
                    TextField("Name", text: $name)
                    TextField("Quantity", text: $quantity)
                    TextField("Location", text: $location)
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedItem = PantryItem(
                            id: item.id,
                            name: name,
                            quantity: quantity,
                            location: location,
                            icon: item.icon
                        )
                        onSave(updatedItem)
                        dismiss()
                    }
                    .foregroundColor(.smartRed)
                }
            }
        }
    }
}

#Preview {
    EditPantryItemView(
        item: PantryItem(name: "Sample", quantity: "1 unit", location: "Pantry", icon: "cart"),
        onSave: { _ in }
    )
}
