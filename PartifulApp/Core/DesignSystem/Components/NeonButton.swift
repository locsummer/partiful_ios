import SwiftUI

public struct NeonButton: View {
    public let title: String
    public var icon: String? = nil
    public var gradient: LinearGradient = AppTheme.partyGradient
    public var height: CGFloat = 52
    public var isFullWidth: Bool = true
    public var isOutlined: Bool = false
    public var isLoading: Bool = false
    public let action: () -> Void
    
    public init(
        title: String,
        icon: String? = nil,
        gradient: LinearGradient = AppTheme.partyGradient,
        height: CGFloat = 52,
        isFullWidth: Bool = true,
        isOutlined: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.gradient = gradient
        self.height = height
        self.isFullWidth = isFullWidth
        self.isOutlined = isOutlined
        self.isLoading = isLoading
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .tint(isOutlined ? AppTheme.brightViolet : .white)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 17, weight: .bold))
                    }
                    Text(title)
                        .font(AppTypography.title3)
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: height)
            .background {
                if isOutlined {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(gradient, lineWidth: 2)
                        .background(AppTheme.surfaceDark.opacity(0.8).cornerRadius(16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(gradient)
                        .shadow(color: AppTheme.brightViolet.opacity(0.4), radius: 10, x: 0, y: 4)
                }
            }
        }
        .disabled(isLoading)
        .buttonStyle(ScaleTouchButtonStyle())
    }
}

public struct ScaleTouchButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
