import Foundation

public struct CardDesign: Identifiable, Codable, Equatable {
    public var id: UUID
    public var title: String
    public var canvasWidth: Double
    public var canvasHeight: Double
    public var backgroundColorHex: String
    public var backgroundGradientHexes: [String]
    public var backgroundGradientAngle: Double
    public var backgroundImagePath: String?
    public var layers: [CanvasLayer]
    public var eventInfo: PartyEvent
    public var createdAt: Date
    public var updatedAt: Date
    public var isDraft: Bool
    public var thumbnailPath: String?
    
    public var aspectRatio: Double {
        guard canvasHeight > 0 else { return 9.0 / 16.0 }
        return canvasWidth / canvasHeight
    }
    
    public init(
        id: UUID = UUID(),
        title: String = "Thiệp mời mới",
        canvasWidth: Double = 1080.0,
        canvasHeight: Double = 1920.0,
        backgroundColorHex: String = "#0F0E17",
        backgroundGradientHexes: [String] = ["#1A0B2E", "#0F0E17", "#2D0A4E"],
        backgroundGradientAngle: Double = 45.0,
        backgroundImagePath: String? = nil,
        layers: [CanvasLayer] = [],
        eventInfo: PartyEvent = PartyEvent(),
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isDraft: Bool = true,
        thumbnailPath: String? = nil
    ) {
        self.id = id
        self.title = title
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        self.backgroundColorHex = backgroundColorHex
        self.backgroundGradientHexes = backgroundGradientHexes
        self.backgroundGradientAngle = backgroundGradientAngle
        self.backgroundImagePath = backgroundImagePath
        self.layers = layers
        self.eventInfo = eventInfo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isDraft = isDraft
        self.thumbnailPath = thumbnailPath
    }
}
