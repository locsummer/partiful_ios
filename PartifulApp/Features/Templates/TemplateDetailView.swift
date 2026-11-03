import SwiftUI

public struct TemplateDetailView: View {
    public let template: Template
    public let onSelectUse: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundDark
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Large Preview Card
                    CanvasRenderView(design: template.cardDesign, isInteractive: false)
                        .frame(maxWidth: .infinity)
                        .frame(height: 440)
                        .cornerRadius(24)
                        .shadow(color: AppTheme.brightViolet.opacity(0.3), radius: 20, x: 0, y: 10)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(template.name)
                                .font(AppTypography.title1)
                                .foregroundColor(.white)
                            Spacer()
                            Text(template.category.rawValue)
                                .font(AppTypography.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(AppTheme.brightViolet.opacity(0.3))
                                .foregroundColor(AppTheme.brightViolet)
                                .cornerRadius(12)
                        }
                        
                        // Tags
                        HStack(spacing: 8) {
                            ForEach(template.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(AppTypography.caption)
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    NeonButton(
                        title: "Dùng mẫu này ngay",
                        icon: "paintbrush.fill",
                        gradient: AppTheme.partyGradient
                    ) {
                        onSelectUse()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Chi tiết mẫu thiệp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }
}
