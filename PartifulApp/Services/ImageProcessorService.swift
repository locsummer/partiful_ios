import Foundation
#if canImport(UIKit)
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

public final class ImageProcessorService {
    public static let shared = ImageProcessorService()
    private let ciContext = CIContext(options: [.useSoftwareRenderer: false])
    
    public init() {}
    
    public func applyFilter(image: UIImage, filter: FilterEffect) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }
        
        var outputImage = ciImage
        
        // 1. Color controls (Brightness, Contrast, Saturation)
        if filter.brightness != 0.0 || filter.contrast != 1.0 || filter.saturation != 1.0 {
            if let colorFilter = CIFilter(name: "CIColorControls") {
                colorFilter.setValue(outputImage, forKey: kCIInputImageKey)
                colorFilter.setValue(filter.brightness, forKey: kCIInputBrightnessKey)
                colorFilter.setValue(filter.contrast, forKey: kCIInputContrastKey)
                colorFilter.setValue(filter.saturation, forKey: kCIInputSaturationKey)
                if let result = colorFilter.outputImage {
                    outputImage = result
                }
            }
        }
        
        // 2. Blur effect
        if filter.blurRadius > 0.1 {
            if let blurFilter = CIFilter(name: "CIGaussianBlur") {
                blurFilter.setValue(outputImage, forKey: kCIInputImageKey)
                blurFilter.setValue(filter.blurRadius, forKey: kCIInputRadiusKey)
                if let result = blurFilter.outputImage {
                    outputImage = result.cropped(to: ciImage.extent)
                }
            }
        }
        
        // 3. Vignette
        if filter.vignetteIntensity > 0.05 {
            if let vignetteFilter = CIFilter(name: "CIVignette") {
                vignetteFilter.setValue(outputImage, forKey: kCIInputImageKey)
                vignetteFilter.setValue(filter.vignetteIntensity * 2.0, forKey: kCIInputIntensityKey)
                vignetteFilter.setValue(filter.vignetteIntensity * 1.5, forKey: kCIInputRadiusKey)
                if let result = vignetteFilter.outputImage {
                    outputImage = result
                }
            }
        }
        
        // Preset special effects
        switch filter.presetName {
        case "Neon":
            if let bloom = CIFilter(name: "CIBloom") {
                bloom.setValue(outputImage, forKey: kCIInputImageKey)
                bloom.setValue(0.8, forKey: kCIInputIntensityKey)
                bloom.setValue(10.0, forKey: kCIInputRadiusKey)
                if let res = bloom.outputImage { outputImage = res }
            }
        case "Vintage":
            if let sepia = CIFilter(name: "CISepiaTone") {
                sepia.setValue(outputImage, forKey: kCIInputImageKey)
                sepia.setValue(0.65, forKey: kCIInputIntensityKey)
                if let res = sepia.outputImage { outputImage = res }
            }
        case "B&W":
            if let bw = CIFilter(name: "CIPhotoEffectNoir") {
                bw.setValue(outputImage, forKey: kCIInputImageKey)
                if let res = bw.outputImage { outputImage = res }
            }
        default:
            break
        }
        
        guard let cgImage = ciContext.createCGImage(outputImage, from: ciImage.extent) else {
            return image
        }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    public func saveImageToDocuments(image: UIImage, fileName: String? = nil) throws -> String {
        let name = fileName ?? "\(UUID().uuidString).jpg"
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent(name)
        
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            throw NSError(domain: "ImageProcessor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image data"])
        }
        try data.write(to: fileURL)
        return name
    }
    
    public func loadImageFromDocuments(fileName: String) -> UIImage? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documents.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
#endif
