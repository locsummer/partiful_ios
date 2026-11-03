import Foundation
#if canImport(UIKit)
import UIKit
import PDFKit

public final class PDFExportService {
    public static let shared = PDFExportService()
    
    public init() {}
    
    public func createPDF(from image: UIImage, title: String = "Party Invitation") -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Partiful Party Invite Maker Native iOS",
            kCGPDFContextAuthor: "Partiful Host",
            kCGPDFContextTitle: title
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Use aspect ratio matching image, e.g., 595.2 x 841.8 (A4) or exact ratio
        let pageWidth: CGFloat = 595.2 // Standard A4 width in points
        let pageHeight: CGFloat = pageWidth * (image.size.height / max(1.0, image.size.width))
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let tempDirectory = FileManager.default.temporaryDirectory
        let safeTitle = title.replacingOccurrences(of: " ", with: "_")
        let pdfURL = tempDirectory.appendingPathComponent("\(safeTitle)_\(UUID().uuidString.prefix(6)).pdf")
        
        do {
            try renderer.writePDF(to: pdfURL) { context in
                context.beginPage()
                // Draw background image scaled to fit
                image.draw(in: pageRect)
            }
            return pdfURL
        } catch {
            print("Failed to export PDF: \(error)")
            return nil
        }
    }
}
#endif
