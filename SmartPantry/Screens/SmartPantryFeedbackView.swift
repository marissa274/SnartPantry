import SwiftUI

struct SmartPantryFeedbackView: View {
    let title: String
    let message: String
    let icon: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.smartCream, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.smartRedLight)
                        .frame(width: 120, height: 120)
                    Image(systemName: icon)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.smartRed)
                }

                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.smartRed)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }

                Button(action: action) {
                    Text(buttonTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.smartRed)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .padding(.horizontal, 24)

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    SmartPantryFeedbackView(title: "Recipe saved", message: "Your recipe was added successfully.", icon: "checkmark.circle.fill", buttonTitle: "Continue") {}
}
