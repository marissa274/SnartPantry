import SwiftUI

struct SelectedIngredientChip: View {
    let name: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Color.black.opacity(0.65))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.12), lineWidth: 1)
        )
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SelectedIngredientChip(name: "Shrimp", onRemove: {})
        .padding()
        .background(Color.gray.opacity(0.1))
}
