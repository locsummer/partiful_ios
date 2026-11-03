import SwiftUI

public struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    public let onFinish: () -> Void
    
    public var body: some View {
        ZStack {
            AppTheme.backgroundDark
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppTheme.partyGradient)
                        .frame(width: isAnimating ? 130 : 90, height: isAnimating ? 130 : 90)
                        .blur(radius: 20)
                        .opacity(0.8)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 54, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.1 : 0.8)
                }
                
                VStack(spacing: 6) {
                    Text("PARTIFUL")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundStyle(AppTheme.partyGradient)
                        .tracking(3)
                    
                    Text("PARTY INVITE & POSTER MAKER")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.textSecondary)
                        .tracking(2)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onFinish()
            }
        }
    }
}
