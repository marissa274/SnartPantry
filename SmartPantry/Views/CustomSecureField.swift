import SwiftUI

struct CustomSecureField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.smartRed)

            if showPassword {
                TextField(placeholder, text: $text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } else {
                SecureField(placeholder, text: $text)
            }

            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    CustomSecureField(icon: "lock", placeholder: "Password", text: .constant(""), showPassword: .constant(false))
}
