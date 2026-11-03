import XCTest
@testable import PartifulApp

final class CardDesignTests: XCTestCase {
    
    func testCardDesignInitialization() {
        let design = CardDesign(
            title: "Sinh nhật 25 tuổi",
            canvasWidth: 1080,
            canvasHeight: 1920
        )
        
        XCTAssertEqual(design.title, "Sinh nhật 25 tuổi")
        XCTAssertEqual(design.aspectRatio, 1080.0 / 1920.0, accuracy: 0.001)
        XCTAssertTrue(design.layers.isEmpty)
        XCTAssertTrue(design.isDraft)
    }
    
    func testLayerHierarchyAndZIndex() {
        var design = CardDesign()
        let textLayer = CanvasLayer(name: "Title", type: .text, zIndex: 1)
        let stickerLayer = CanvasLayer(name: "Sticker", type: .sticker, zIndex: 2)
        let imageLayer = CanvasLayer(name: "Photo", type: .image, zIndex: 0)
        
        design.layers = [textLayer, stickerLayer, imageLayer]
        
        let sorted = design.layers.sorted(by: { $0.zIndex < $1.zIndex })
        XCTAssertEqual(sorted[0].name, "Photo")
        XCTAssertEqual(sorted[1].name, "Title")
        XCTAssertEqual(sorted[2].name, "Sticker")
    }
    
    func testDesignJSONEncodingAndDecoding() throws {
        var original = CardDesign(title: "EDM Rave Poster")
        original.layers.append(CanvasLayer(name: "Headline", type: .text, textData: TextLayerData(text: "ELECTRIC PULSE")))
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(original)
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CardDesign.self, from: data)
        
        XCTAssertEqual(decoded.title, "EDM Rave Poster")
        XCTAssertEqual(decoded.layers.count, 1)
        XCTAssertEqual(decoded.layers.first?.textData?.text, "ELECTRIC PULSE")
    }
}
