import SwiftUI

struct CustomTextFieldView: View {
    var icon: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.smartRed)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    CustomTextFieldView(icon: "magnifyingglass", placeholder: "Search...", text: .constant(""))
}
