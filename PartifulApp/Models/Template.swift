import Foundation

public struct Template: Identifiable, Codable, Equatable {
    public var id: String
    public var name: String
    public var category: TemplateCategory
    public var cardDesign: CardDesign
    public var previewColorHex: String
    public var tags: [String]
    
    public init(
        id: String,
        name: String,
        category: TemplateCategory,
        cardDesign: CardDesign,
        previewColorHex: String = "#8A2BE2",
        tags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.cardDesign = cardDesign
        self.previewColorHex = previewColorHex
        self.tags = tags
    }
}
