import SwiftUI

struct IngredientTagView: View {
    let tag: IngredientTag

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Color.smartRed)
                .frame(width: 8, height: 8)

            Text(tag.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black.opacity(0.8))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        IngredientTagView(tag: IngredientTag(name: "Tomato", x: 0.5, y: 0.5))
    }
}
