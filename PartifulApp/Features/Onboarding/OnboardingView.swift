import SwiftUI

public struct OnboardingSlide: Identifiable {
    public let id = UUID()
    public let title: String
    public let description: String
    public let iconName: String
    public let gradient: LinearGradient
}

public struct OnboardingView: View {
    public let onComplete: () -> Void
    @State private var currentStep: Int = 0
    
    let slides: [OnboardingSlide] = [
        OnboardingSlide(
            title: "Thiết kế thiệp tiệc\nđẳng cấp & độc đáo",
            description: "Hơn 11 danh mục mẫu thiệp sinh nhật, đám cưới, lễ hội, âm nhạc và tiệc ngoài trời được thiết kế sẵn theo chuẩn visual Partiful hiện đại.",
            iconName: "wand.and.stars",
            gradient: AppTheme.partyGradient
        ),
        OnboardingSlide(
            title: "Trình chỉnh sửa\nđa lớp chuyên nghiệp",
            description: "Thêm ảnh cá nhân, chỉnh sửa typography với hiệu ứng neon glow, sticker sôi động và bộ lọc màu nghệ thuật trực tiếp trên điện thoại.",
            iconName: "square.3.layers.3d.down.right",
            gradient: LinearGradient(colors: [AppTheme.brightViolet, AppTheme.cyanVibe], startPoint: .topLeading, endPoint: .bottomTrailing)
        ),
        OnboardingSlide(
            title: "Xuất file sắc nét &\nĐồng bộ Lịch 1 chạm",
            description: "Xuất ảnh PNG, JPG chất lượng cao hoặc file PDF in ấn. Chia sẻ nhanh qua Zalo, Messenger và lưu trực tiếp sự kiện vào Apple Calendar.",
            iconName: "calendar.badge.clock",
            gradient: LinearGradient(colors: [AppTheme.emeraldMint, AppTheme.amberGlow], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    ]
    
    public var body: some View {
        ZStack {
            AppTheme.backgroundDark
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Bỏ qua") {
                        onComplete()
                    }
                    .font(AppTypography.caption)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding()
                }
                
                TabView(selection: $currentStep) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        let slide = slides[index]
                        VStack(spacing: 28) {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(slide.gradient)
                                    .frame(width: 160, height: 160)
                                    .blur(radius: 25)
                                    .opacity(0.6)
                                
                                Image(systemName: slide.iconName)
                                    .font(.system(size: 80))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 12) {
                                Text(slide.title)
                                    .font(AppTypography.heroTitle)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                
                                Text(slide.description)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppTheme.textSecondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                            
                            Spacer()
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                NeonButton(
                    title: currentStep == slides.count - 1 ? "Bắt đầu sáng tạo" : "Tiếp theo",
                    icon: currentStep == slides.count - 1 ? "sparkles" : "arrow.right",
                    gradient: slides[currentStep].gradient
                ) {
                    if currentStep < slides.count - 1 {
                        withAnimation { currentStep += 1 }
                    } else {
                        onComplete()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}
