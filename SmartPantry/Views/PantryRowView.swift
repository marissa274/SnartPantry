import SwiftUI

struct PantryRowView: View {
    let item: PantryItem
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.smartRed.opacity(0.10))
                    .frame(width: 58, height: 58)
                
                Image(systemName: item.icon)
                    .font(.system(size: 22))
                    .foregroundColor(.smartRed)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(item.quantity)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(item.location)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.smartRed)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.smartRed.opacity(0.10))
                .clipShape(Capsule())
        }
        .padding(16)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.20), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
    }
}

#Preview {
    PantryRowView(
        item: MockPantryData.items.first ??
        PantryItem(name: "Sample", quantity: "1 unit", location: "Preview", icon: "cart")
    )
}
