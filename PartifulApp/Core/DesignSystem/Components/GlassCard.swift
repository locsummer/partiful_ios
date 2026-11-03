import SwiftUI

public struct GlassCard<Content: View>: View {
    public var cornerRadius: CGFloat = 20
    public var borderColor: Color = AppTheme.surfaceBorder
    public var backgroundColor: Color = AppTheme.surfaceDark.opacity(0.7)
    public let content: () -> Content
    
    public init(
        cornerRadius: CGFloat = 20,
        borderColor: Color = AppTheme.surfaceBorder,
        backgroundColor: Color = AppTheme.surfaceDark.opacity(0.7),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.content = content
    }
    
    public var body: some View {
        content()
            .padding()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(borderColor, lineWidth: 1)
                    }
                    .shadow(color: Color.black.opacity(0.3), radius: 12, x: 0, y: 6)
            }
    }
}
