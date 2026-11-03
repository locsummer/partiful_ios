import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

public struct AppTheme {
    // Primary Neon & Party Accents
    public static let neonPurple = Color(hex: "#8A2BE2")
    public static let brightViolet = Color(hex: "#A855F7")
    public static let hotPink = Color(hex: "#EC4899")
    public static let roseNeon = Color(hex: "#F43F5E")
    public static let sunsetCoral = Color(hex: "#FF6B6B")
    public static let amberGlow = Color(hex: "#FBBF24")
    public static let emeraldMint = Color(hex: "#10B981")
    public static let cyanVibe = Color(hex: "#06B6D4")
    public static let electricBlue = Color(hex: "#3B82F6")
    
    // Backgrounds & Surfaces (Velvet Dark Mode First)
    public static let backgroundDark = Color(hex: "#0F0E17")
    public static let surfaceDark = Color(hex: "#1A1926")
    public static let surfaceElevated = Color(hex: "#262338")
    public static let surfaceBorder = Color.white.opacity(0.12)
    
    // Text Colors
    public static let textPrimary = Color(hex: "#FFFFFE")
    public static let textSecondary = Color(hex: "#A7A9BE")
    public static let textMuted = Color.white.opacity(0.4)
    
    // Gradients
    public static let partyGradient = LinearGradient(
        colors: [neonPurple, hotPink, sunsetCoral],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let darkCardGradient = LinearGradient(
        colors: [surfaceElevated, surfaceDark],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let neonBorderGradient = LinearGradient(
        colors: [brightViolet, hotPink, amberGlow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

public extension Color {
    init(hex: String) {
        let cleanHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanHex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch cleanHex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex(includeAlpha: Bool = false) -> String {
        #if canImport(UIKit)
        let uic = UIColor(self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uic.getRed(&r, green: &g, blue: &b, alpha: &a)
        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(a * 255), Int(r * 255), Int(g * 255), Int(b * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
        #else
        return "#FFFFFF"
        #endif
    }
}
