import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public struct CardPreviewView: View {
    public let cardDesign: CardDesign
    @Environment(\.dismiss) private var dismiss
    
    @State private var showExportSheet: Bool = false
    @State private var showCalendarForm: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var renderedImage: UIImage?
    @State private var exportedPdfURL: URL?
    
    public init(cardDesign: CardDesign) {
        self.cardDesign = cardDesign
    }
    
    public var body: some View {
        ZStack {
            AppTheme.backgroundDark
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Main Clean Card Preview
                CanvasRenderView(
                    design: cardDesign,
                    isInteractive: false
                )
                .cornerRadius(24)
                .shadow(color: AppTheme.brightViolet.opacity(0.3), radius: 25, x: 0, y: 10)
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                // Bottom Action Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        NeonButton(
                            title: "Xuất file",
                            icon: "square.and.arrow.up",
                            gradient: AppTheme.partyGradient,
                            height: 48
                        ) {
                            showExportSheet = true
                        }
                        
                        NeonButton(
                            title: "Lưu vào Lịch",
                            icon: "calendar.badge.plus",
                            gradient: LinearGradient(colors: [AppTheme.emeraldMint, AppTheme.cyanVibe], startPoint: .leading, endPoint: .trailing),
                            height: 48
                        ) {
                            showCalendarForm = true
                        }
                    }
                    
                    Button("Tiếp tục chỉnh sửa") {
                        dismiss()
                    }
                    .font(AppTypography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("Xem trước thiệp")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showExportSheet) {
            ExportOptionsView(cardDesign: cardDesign)
        }
        .sheet(isPresented: $showCalendarForm) {
            EventFormView(event: cardDesign.eventInfo)
        }
    }
}
