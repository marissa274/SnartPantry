import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var showPassword = false
    @State private var goToLogin = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Image("cooking")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .padding(.top, 30)

                    VStack(spacing: 6) {
                        Text("Sign Up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.smartRed)
                    }

                    VStack(spacing: 16) {
                        CustomTextFieldView(icon: "person", placeholder: "User Name", text: $viewModel.name)
                        CustomTextFieldView(icon: "envelope", placeholder: "Email", text: $viewModel.email)
                        CustomSecureField(icon: "lock", placeholder: "Password", text: $viewModel.password, showPassword: $showPassword)
                        CustomSecureField(icon: "lock", placeholder: "Confirm Password", text: $viewModel.confirmPassword, showPassword: $showPassword)
                    }
                    .padding(.horizontal, 24)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }

                    if !viewModel.successMessage.isEmpty {
                        Text(viewModel.successMessage)
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.horizontal, 24)
                    }

                    Button(action: {
                        Task {
                            let success = await viewModel.register()
                            if success { goToLogin = true }
                        }
                    }) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.smartRed)
                            .cornerRadius(30)
                            .shadow(color: .smartRed.opacity(0.25), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 24)

                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.gray)

                        Button("Login") {
                            goToLogin = true
                        }
                        .foregroundColor(.smartRed)
                        .fontWeight(.bold)
                    }

                    Spacer(minLength: 30)
                }
            }

            if viewModel.isLoading {
                SmartPantryLoadingView(title: "Creating your account...", subtitle: "SmartPantry is setting up your kitchen profile")
            }
        }
        .sheet(isPresented: $goToLogin) {
            LoginView()
        }
    }
}

#Preview {
    SignUpView()
}
