import Foundation
import CoreGraphics

public struct ImageLayerData: Codable, Equatable {
    public var localImagePath: String?
    public var filter: FilterEffect = FilterEffect()
    public var cornerRadius: Double = 0.0
    
    public init(localImagePath: String? = nil, filter: FilterEffect = FilterEffect(), cornerRadius: Double = 0.0) {
        self.localImagePath = localImagePath
        self.filter = filter
        self.cornerRadius = cornerRadius
    }
}

public struct TextLayerData: Codable, Equatable {
    public var text: String
    public var fontFamily: String = "System"
    public var fontSize: Double = 28.0
    public var fontColorHex: String = "#FFFFFF"
    public var alignment: TextAlignmentType = .center
    public var isBold: Bool = true
    public var isItalic: Bool = false
    public var letterSpacing: Double = 1.0
    public var strokeWidth: Double = 0.0
    public var strokeColorHex: String = "#000000"
    public var shadowRadius: Double = 4.0
    public var shadowColorHex: String = "#00000080"
    public var shadowOffsetX: Double = 2.0
    public var shadowOffsetY: Double = 2.0
    
    public init(
        text: String = "PARTY TIME",
        fontFamily: String = "System",
        fontSize: Double = 28.0,
        fontColorHex: String = "#FFFFFF",
        alignment: TextAlignmentType = .center,
        isBold: Bool = true,
        isItalic: Bool = false,
        letterSpacing: Double = 1.0,
        strokeWidth: Double = 0.0,
        strokeColorHex: String = "#000000",
        shadowRadius: Double = 4.0,
        shadowColorHex: String = "#00000080",
        shadowOffsetX: Double = 2.0,
        shadowOffsetY: Double = 2.0
    ) {
        self.text = text
        self.fontFamily = fontFamily
        self.fontSize = fontSize
        self.fontColorHex = fontColorHex
        self.alignment = alignment
        self.isBold = isBold
        self.isItalic = isItalic
        self.letterSpacing = letterSpacing
        self.strokeWidth = strokeWidth
        self.strokeColorHex = strokeColorHex
        self.shadowRadius = shadowRadius
        self.shadowColorHex = shadowColorHex
        self.shadowOffsetX = shadowOffsetX
        self.shadowOffsetY = shadowOffsetY
    }
}

public struct StickerLayerData: Codable, Equatable {
    public var symbolOrName: String
    public var category: String
    public var tintColorHex: String?
    public var glowRadius: Double = 0.0
    public var glowColorHex: String = "#FF007F"
    
    public init(
        symbolOrName: String,
        category: String = "Party",
        tintColorHex: String? = nil,
        glowRadius: Double = 0.0,
        glowColorHex: String = "#FF007F"
    ) {
        self.symbolOrName = symbolOrName
        self.category = category
        self.tintColorHex = tintColorHex
        self.glowRadius = glowRadius
        self.glowColorHex = glowColorHex
    }
}

public struct CanvasLayer: Identifiable, Codable, Equatable {
    public var id: UUID
    public var name: String
    public var type: LayerType
    public var x: Double
    public var y: Double
    public var width: Double
    public var height: Double
    public var rotation: Double // degrees
    public var scale: Double
    public var opacity: Double
    public var zIndex: Int
    public var isLocked: Bool
    public var isVisible: Bool
    
    public var imageData: ImageLayerData?
    public var textData: TextLayerData?
    public var stickerData: StickerLayerData?
    
    public init(
        id: UUID = UUID(),
        name: String = "Layer",
        type: LayerType,
        x: Double = 0.0,
        y: Double = 0.0,
        width: Double = 200.0,
        height: Double = 200.0,
        rotation: Double = 0.0,
        scale: Double = 1.0,
        opacity: Double = 1.0,
        zIndex: Int = 0,
        isLocked: Bool = false,
        isVisible: Bool = true,
        imageData: ImageLayerData? = nil,
        textData: TextLayerData? = nil,
        stickerData: StickerLayerData? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.rotation = rotation
        self.scale = scale
        self.opacity = opacity
        self.zIndex = zIndex
        self.isLocked = isLocked
        self.isVisible = isVisible
        self.imageData = imageData
        self.textData = textData
        self.stickerData = stickerData
    }
}
