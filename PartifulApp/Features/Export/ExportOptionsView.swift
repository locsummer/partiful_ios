import SwiftUI
#if canImport(UIKit)
import UIKit
import PDFKit

public struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
    public let items: [Any]
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

public struct ExportOptionsView: View {
    public let cardDesign: CardDesign
    @Environment(\.dismiss) private var dismiss
    
    @State private var exportFormat: String = "PNG" // PNG, JPG, PDF
    @State private var resolutionScale: Double = 2.0 // 1x (Standard), 2x (HD), 3x (Print)
    @State private var jpegQuality: Double = 0.95
    @State private var isProcessing: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var shareItems: [Any] = []
    @State private var showSuccessAlert: Bool = false
    @State private var successMessage: String = ""
    @State private var pdfPreviewURL: URL?
    
    public init(cardDesign: CardDesign) {
        self.cardDesign = cardDesign
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Preview Card Thumbnail
                    CanvasRenderView(
                        design: cardDesign,
                        isInteractive: false
                    )
                    .frame(height: 280)
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.4), radius: 15, x: 0, y: 8)
                    .padding(.top, 8)
                    
                    // Format Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Định dạng xuất file")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        Picker("Định dạng", selection: $exportFormat) {
                            Text("PNG (Không nén)").tag("PNG")
                            Text("JPG / JPEG").tag("JPG")
                            Text("PDF (In ấn)").tag("PDF")
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // Resolution / Scale
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Độ phân giải")
                            Spacer()
                            Text(scaleDescription)
                        }
                        .font(AppTypography.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        
                        Picker("Độ phân giải", selection: $resolutionScale) {
                            Text("1x (Mạng xã hội)").tag(1.0)
                            Text("2x (Sắc nét HD)").tag(2.0)
                            Text("3x (Chất lượng in)").tag(3.0)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    // JPG Quality Slider (if JPG)
                    if exportFormat == "JPG" {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("Chất lượng nén JPG")
                                Spacer()
                                Text("\(Int(jpegQuality * 100))%")
                            }
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                            
                            Slider(value: $jpegQuality, in: 0.6...1.0, step: 0.05)
                                .tint(AppTheme.brightViolet)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        NeonButton(
                            title: "Lưu vào máy",
                            icon: "square.and.arrow.down.fill",
                            gradient: AppTheme.partyGradient,
                            isLoading: isProcessing
                        ) {
                            performExportAndSave()
                        }
                        
                        NeonButton(
                            title: "Mở bảng chia sẻ",
                            icon: "square.and.arrow.up",
                            gradient: LinearGradient(colors: [AppTheme.neonPurple, AppTheme.brightViolet], startPoint: .leading, endPoint: .trailing),
                            isOutlined: true,
                            isLoading: isProcessing
                        ) {
                            performExportAndShare()
                        }
                    }
                    .padding(.top, 12)
                }
                .padding()
            }
            .background(AppTheme.backgroundDark)
            .navigationTitle("Xuất thiệp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .sheet(isPresented: $showShareSheet) {
                ActivityViewControllerRepresentable(items: shareItems)
            }
            .alert("Thông báo", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(successMessage)
            }
        }
    }
    
    private var scaleDescription: String {
        switch resolutionScale {
        case 1.0: return "1080 x 1920 px"
        case 2.0: return "2160 x 3840 px (4K)"
        default: return "3240 x 5760 px (In ấn)"
        }
    }
    
    // MARK: - Export Logic
    private func renderBitmap() -> UIImage? {
        let renderView = CanvasRenderView(design: cardDesign, isInteractive: false)
            .frame(width: CGFloat(cardDesign.canvasWidth), height: CGFloat(cardDesign.canvasHeight))
        
        let controller = UIHostingController(rootView: renderView)
        let view = controller.view
        
        let targetSize = CGSize(
            width: CGFloat(cardDesign.canvasWidth) * CGFloat(resolutionScale),
            height: CGFloat(cardDesign.canvasHeight) * CGFloat(resolutionScale)
        )
        view?.bounds = CGRect(origin: .zero, size: CGSize(width: CGFloat(cardDesign.canvasWidth), height: CGFloat(cardDesign.canvasHeight)))
        view?.backgroundColor = .clear
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = CGFloat(resolutionScale)
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: view?.bounds.size ?? targetSize, format: format)
        return renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? .zero, afterScreenUpdates: true)
        }
    }
    
    private func performExportAndSave() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if exportFormat == "PDF" {
                if let image = renderBitmap(),
                   let pdfUrl = PDFExportService.shared.createPDF(from: image, title: cardDesign.title) {
                    successMessage = "Đã xuất file PDF thành công vào thư mục Tài liệu: \(pdfUrl.lastPathComponent)"
                    showSuccessAlert = true
                }
            } else {
                if let image = renderBitmap() {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    successMessage = "Đã lưu thiệp thành công vào Thư viện ảnh của bạn!"
                    showSuccessAlert = true
                }
            }
            isProcessing = false
        }
    }
    
    private func performExportAndShare() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if exportFormat == "PDF" {
                if let image = renderBitmap(),
                   let pdfUrl = PDFExportService.shared.createPDF(from: image, title: cardDesign.title) {
                    shareItems = [pdfUrl]
                    showShareSheet = true
                }
            } else {
                if let image = renderBitmap() {
                    if exportFormat == "JPG", let data = image.jpegData(compressionQuality: CGFloat(jpegQuality)), let jpgImg = UIImage(data: data) {
                        shareItems = [jpgImg]
                    } else {
                        shareItems = [image]
                    }
                    showShareSheet = true
                }
            }
            isProcessing = false
        }
    }
}
#endif
