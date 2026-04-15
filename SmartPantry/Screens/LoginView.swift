import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AuthViewModel()
    @State private var showPassword = false
    @State private var showSignUp = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    Image("cooking")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                        .shadow(color: .smartRed.opacity(0.15), radius: 12, x: 0, y: 6)

                    VStack(spacing: 6) {
                        Text("Welcome Back")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.smartRed)

                        Text("Log in to continue")
                            .foregroundColor(.gray)
                    }

                    VStack(spacing: 16) {
                        CustomTextFieldView(icon: "envelope", placeholder: "Email", text: $viewModel.email)

                        CustomSecureField(
                            icon: "lock",
                            placeholder: "Password",
                            text: $viewModel.password,
                            showPassword: $showPassword
                        )
                    }
                    .padding(.horizontal, 24)

                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal, 24)
                    }

                    Button(action: {
                        Task {
                            let success = await viewModel.login(appState: appState)
                            if success { dismiss() }
                        }
                    }) {
                        Text("Login")
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
                        Text("Don’t have an account?")
                            .foregroundColor(.gray)

                        Button("Sign Up") {
                            showSignUp = true
                        }
                        .foregroundColor(.smartRed)
                        .fontWeight(.bold)
                    }

                    Spacer(minLength: 30)
                }
                .padding(.top, 20)
            }

            if viewModel.isLoading {
                SmartPantryLoadingView(title: "Signing in...", subtitle: "We are opening your SmartPantry")
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
