import SwiftUI

struct WelcomeView: View {
    @State private var showingSignUp = false
    @State private var showingLogin = false

    var body: some View {
        ZStack {
            Image("food")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [Color.black.opacity(0.05), Color.black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 14) {
                    Button {
                        showingSignUp = true
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 350, height: 56)
                            .background(Color.smartRed)
                            .cornerRadius(30)
                    }
                    .sheet(isPresented: $showingSignUp) {
                        SignUpView()
                    }

                    Button {
                        showingLogin = true
                    } label: {
                        Text("I Already Have an Account")
                            .font(.headline)
                            .foregroundColor(.smartRed)
                            .frame(width: 350, height: 56)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.smartRed, lineWidth: 1.5)
                            )
                            .cornerRadius(30)
                    }
                    .sheet(isPresented: $showingLogin) {
                        LoginView()
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    WelcomeView()
}
