import SwiftUI

public struct AppTypography {
    public static let heroTitle = Font.system(size: 34, weight: .black, design: .rounded)
    public static let title1 = Font.system(size: 26, weight: .bold, design: .rounded)
    public static let title2 = Font.system(size: 20, weight: .semibold, design: .rounded)
    public static let title3 = Font.system(size: 17, weight: .semibold, design: .default)
    public static let body = Font.system(size: 15, weight: .regular, design: .default)
    public static let bodyBold = Font.system(size: 15, weight: .semibold, design: .default)
    public static let caption = Font.system(size: 12, weight: .medium, design: .default)
    public static let badge = Font.system(size: 11, weight: .bold, design: .rounded)
    
    // Preset party fonts
    public static let availableFonts: [String] = [
        "System",
        "HelveticaNeue-Bold",
        "AvenirNext-Heavy",
        "Futura-Bold",
        "MarkerFelt-Wide",
        "Chalkduster",
        "Didot-Bold",
        "Georgia-Bold",
        "Impact",
        "SnellRoundhand-Bold",
        "TrebuchetMS-Bold"
    ]
}
