import Foundation

public enum LayerType: String, Codable, CaseIterable {
    case background
    case image
    case text
    case sticker
}

public enum TextAlignmentType: String, Codable, CaseIterable {
    case left
    case center
    case right
}

public struct FilterEffect: Codable, Equatable {
    public var brightness: Double = 0.0     // -1.0 to 1.0
    public var contrast: Double = 1.0       // 0.0 to 2.0
    public var saturation: Double = 1.0     // 0.0 to 2.0
    public var blurRadius: Double = 0.0     // 0.0 to 20.0
    public var vignetteIntensity: Double = 0.0 // 0.0 to 1.0
    public var presetName: String = "Normal"
    
    public init(
        brightness: Double = 0.0,
        contrast: Double = 1.0,
        saturation: Double = 1.0,
        blurRadius: Double = 0.0,
        vignetteIntensity: Double = 0.0,
        presetName: String = "Normal"
    ) {
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.blurRadius = blurRadius
        self.vignetteIntensity = vignetteIntensity
        self.presetName = presetName
    }
}
