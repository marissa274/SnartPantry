import SwiftUI

struct SmartPantryLoadingView: View {
    var title: String = "Analyzing..."
    var subtitle: String = "SmartPantry is preparing your recipe"

    @State private var animate = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.smartCream, .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.smartRedLight)
                        .frame(width: 132, height: 132)
                        .scaleEffect(animate ? 1.06 : 0.94)
                        .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: animate)

                    Image(systemName: "fork.knife.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.smartRed)
                }

                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundColor(.smartRed)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                }

                ProgressView()
                    .tint(.smartRed)
                    .scaleEffect(1.25)

                Spacer()
            }
            .padding()
        }
        .onAppear { animate = true }
    }
}

#Preview {
    SmartPantryLoadingView()
}
