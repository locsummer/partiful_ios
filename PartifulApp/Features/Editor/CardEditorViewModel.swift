import SwiftUI
import Combine
#if canImport(UIKit)
import UIKit
#endif

public enum ActiveToolSheet: String, Identifiable {
    case text
    case photoPicker
    case stickers
    case filters
    case layers
    case background
    
    public var id: String { self.rawValue }
}

@MainActor
public final class CardEditorViewModel: ObservableObject {
    @Published public var cardDesign: CardDesign
    @Published public var selectedLayerId: UUID?
    @Published public var activeSheet: ActiveToolSheet?
    @Published public var isExporting: Bool = false
    @Published public var exportError: String?
    
    // History & Undo/Redo
    private let historyManager = HistoryManager(maxHistory: 30)
    @Published public var canUndo: Bool = false
    @Published public var canRedo: Bool = false
    
    public var selectedLayer: CanvasLayer? {
        guard let id = selectedLayerId else { return nil }
        return cardDesign.layers.first { $0.id == id }
    }
    
    public init(initialDesign: CardDesign? = nil) {
        if let design = initialDesign {
            self.cardDesign = design
        } else if let draft = DraftStorageService.shared.loadDraft() {
            self.cardDesign = draft
        } else {
            // Default party template
            self.cardDesign = TemplateRepository.shared.templates.first?.cardDesign ?? CardDesign()
        }
        updateUndoRedoStatus()
    }
    
    // MARK: - Snapshot & History
    public func saveCheckpoint() {
        historyManager.saveCheckpoint(cardDesign)
        DraftStorageService.shared.saveDraft(cardDesign)
        updateUndoRedoStatus()
    }
    
    public func undo() {
        if let prev = historyManager.undo(currentState: cardDesign) {
            self.cardDesign = prev
            updateUndoRedoStatus()
        }
    }
    
    public func redo() {
        if let next = historyManager.redo(currentState: cardDesign) {
            self.cardDesign = next
            updateUndoRedoStatus()
        }
    }
    
    private func updateUndoRedoStatus() {
        canUndo = historyManager.canUndo
        canRedo = historyManager.canRedo
    }
    
    // MARK: - Layer Selection
    public func selectLayer(id: UUID) {
        if let layer = cardDesign.layers.first(where: { $0.id == id }), !layer.isLocked {
            selectedLayerId = id
        }
    }
    
    public func deselectLayer() {
        selectedLayerId = nil
    }
    
    // MARK: - Layer Manipulation
    public func addTextLayer(text: String = "PARTY TIME") {
        saveCheckpoint()
        let maxZ = (cardDesign.layers.map { $0.zIndex }.max() ?? 0) + 1
        let newLayer = CanvasLayer(
            name: "Text \(cardDesign.layers.count + 1)",
            type: .text,
            x: 0,
            y: 0,
            width: 700,
            height: 120,
            zIndex: maxZ,
            textData: TextLayerData(text: text)
        )
        cardDesign.layers.append(newLayer)
        selectedLayerId = newLayer.id
        activeSheet = .text
    }
    
    public func updateSelectedTextData(_ data: TextLayerData) {
        guard let id = selectedLayerId, let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        saveCheckpoint()
        cardDesign.layers[index].textData = data
    }
    
    #if canImport(UIKit)
    public func addImageLayer(uiImage: UIImage) {
        saveCheckpoint()
        if let fileName = try? ImageProcessorService.shared.saveImageToDocuments(image: uiImage) {
            let maxZ = (cardDesign.layers.map { $0.zIndex }.max() ?? 0) + 1
            let newLayer = CanvasLayer(
                name: "Image \(cardDesign.layers.count + 1)",
                type: .image,
                x: 0,
                y: 0,
                width: 600,
                height: 600,
                zIndex: maxZ,
                imageData: ImageLayerData(localImagePath: fileName)
            )
            cardDesign.layers.append(newLayer)
            selectedLayerId = newLayer.id
        }
    }
    #endif
    
    public func addStickerLayer(symbol: String, category: String) {
        saveCheckpoint()
        let maxZ = (cardDesign.layers.map { $0.zIndex }.max() ?? 0) + 1
        let newLayer = CanvasLayer(
            name: "Sticker \(cardDesign.layers.count + 1)",
            type: .sticker,
            x: 0,
            y: 0,
            width: 150,
            height: 150,
            zIndex: maxZ,
            stickerData: StickerLayerData(symbolOrName: symbol, category: category)
        )
        cardDesign.layers.append(newLayer)
        selectedLayerId = newLayer.id
    }
    
    public func deleteSelectedLayer() {
        guard let id = selectedLayerId else { return }
        saveCheckpoint()
        cardDesign.layers.removeAll { $0.id == id }
        selectedLayerId = nil
    }
    
    public func duplicateSelectedLayer() {
        guard let layer = selectedLayer else { return }
        saveCheckpoint()
        var dup = layer
        dup.id = UUID()
        dup.name = "\(layer.name) (Copy)"
        dup.x += 40
        dup.y += 40
        dup.zIndex = (cardDesign.layers.map { $0.zIndex }.max() ?? 0) + 1
        cardDesign.layers.append(dup)
        selectedLayerId = dup.id
    }
    
    public func bringForward() {
        guard let id = selectedLayerId, let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        saveCheckpoint()
        cardDesign.layers[index].zIndex += 1
    }
    
    public func sendBackward() {
        guard let id = selectedLayerId, let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        saveCheckpoint()
        cardDesign.layers[index].zIndex = max(0, cardDesign.layers[index].zIndex - 1)
    }
    
    public func toggleLockSelectedLayer() {
        guard let id = selectedLayerId, let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        cardDesign.layers[index].isLocked.toggle()
        if cardDesign.layers[index].isLocked {
            selectedLayerId = nil
        }
    }
    
    public func updatePosition(for id: UUID, newX: Double, newY: Double) {
        guard let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        cardDesign.layers[index].x = newX
        cardDesign.layers[index].y = newY
    }
    
    public func updateScaleAndRotation(for id: UUID, scaleDelta: Double, rotationDelta: Double) {
        guard let index = cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        let currentScale = cardDesign.layers[index].scale
        cardDesign.layers[index].scale = max(0.2, min(5.0, currentScale * scaleDelta))
        cardDesign.layers[index].rotation += rotationDelta
    }
    
    public func setBackgroundGradients(hexes: [String]) {
        saveCheckpoint()
        cardDesign.backgroundGradientHexes = hexes
    }
    
    public func saveProject() {
        try? DraftStorageService.shared.saveProject(cardDesign)
    }
}
