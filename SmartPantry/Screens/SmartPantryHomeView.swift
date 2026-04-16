import SwiftUI

struct SmartPantryHomeView: View {
    @State private var likesCount: Int = 1600

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                        .padding(.bottom, 32)

                    heroCard

                    scanButton
                        .padding(.top, 28)
                        .padding(.horizontal, 36)

                    Spacer()
                }
                .padding(.horizontal, 22)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
            .navigationBarHidden(true)
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            Text("SmartPantry")
                .font(.system(size: 27, weight: .black, design: .rounded))
                .foregroundColor(.smartCream)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Spacer()

            HStack(spacing: 10) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.smartRedLight)

                Text("\(likesCount)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.smartCream)

                Text("likes")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.smartCream.opacity(0.72))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(Color.smartRedSoft.opacity(0.9))
                    .overlay(
                        Capsule()
                            .stroke(Color.smartRedLight.opacity(0.25), lineWidth: 1)
                    )
            )
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .bottom) {
            Image("bowl")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 500)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.00),
                            Color.black.opacity(0.08),
                            Color.black.opacity(0.30)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 38, style: .continuous)
                )
                .shadow(color: Color.smartRedSoft.opacity(0.20), radius: 16, x: 0, y: 12)

            VStack(spacing: 0) {
                Spacer()

                Text("Everything in your kitchen,\nscanned into something smart")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white.opacity(0.90))
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 26)
            }
        }
    }

    private var scanButton: some View {
        NavigationLink {
            AIScannerView() // 👉 mets ici TON vrai nom de view
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "camera.viewfinder")
                    .font(.system(size: 18, weight: .bold))

                Text("Scan ingredients now")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(.smartCream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 19)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.smartRed)
                    .shadow(color: Color.smartRedSoft.opacity(0.35), radius: 14, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.smartRedLight.opacity(0.45), lineWidth: 1.2)
            )
        }
    }
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.smartRedSoft,
                Color.smartRed,
                Color.black.opacity(0.96)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    SmartPantryHomeView()
}
