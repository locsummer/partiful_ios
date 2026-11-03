import SwiftUI

public struct CanvasRenderView: View {
    public let design: CardDesign
    public let selectedLayerId: UUID?
    public let isInteractive: Bool
    public var onSelectLayer: ((UUID) -> Void)?
    public var onUpdateLayerPosition: ((UUID, CGPoint) -> Void)?
    
    public init(
        design: CardDesign,
        selectedLayerId: UUID? = nil,
        isInteractive: Bool = false,
        onSelectLayer: ((UUID) -> Void)? = nil,
        onUpdateLayerPosition: ((UUID, CGPoint) -> Void)? = nil
    ) {
        self.design = design
        self.selectedLayerId = selectedLayerId
        self.isInteractive = isInteractive
        self.onSelectLayer = onSelectLayer
        self.onUpdateLayerPosition = onUpdateLayerPosition
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let scaleX = geometry.size.width / CGFloat(design.canvasWidth)
            let scaleY = geometry.size.height / CGFloat(design.canvasHeight)
            let canvasScale = min(scaleX, scaleY)
            
            ZStack {
                // Background Layer
                backgroundLayer
                
                // Sorted Canvas Layers
                ForEach(design.layers.sorted(by: { $0.zIndex < $1.zIndex })) { layer in
                    if layer.isVisible {
                        layerItemView(layer: layer, canvasScale: canvasScale)
                    }
                }
            }
            .frame(width: CGFloat(design.canvasWidth) * canvasScale, height: CGFloat(design.canvasHeight) * canvasScale)
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
    // MARK: - Background Layer
    @ViewBuilder
    private var backgroundLayer: some View {
        if let bgPath = design.backgroundImagePath, !bgPath.isEmpty {
            #if canImport(UIKit)
            if let uiImage = ImageProcessorService.shared.loadImageFromDocuments(fileName: bgPath) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                fallbackBackground
            }
            #else
            fallbackBackground
            #endif
        } else {
            fallbackBackground
        }
    }
    
    private var fallbackBackground: some View {
        Group {
            if design.backgroundGradientHexes.count > 1 {
                LinearGradient(
                    colors: design.backgroundGradientHexes.map { Color(hex: $0) },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                Color(hex: design.backgroundColorHex)
            }
        }
    }
    
    // MARK: - Layer Item View
    @ViewBuilder
    private func layerItemView(layer: CanvasLayer, canvasScale: CGFloat) -> some View {
        let isSelected = isInteractive && (selectedLayerId == layer.id)
        
        Group {
            switch layer.type {
            case .text:
                if let textData = layer.textData {
                    renderTextLayer(layer: layer, data: textData, scale: canvasScale)
                }
            case .sticker:
                if let stickerData = layer.stickerData {
                    renderStickerLayer(layer: layer, data: stickerData, scale: canvasScale)
                }
            case .image:
                if let imgData = layer.imageData {
                    renderImageLayer(layer: layer, data: imgData, scale: canvasScale)
                }
            case .background:
                EmptyView()
            }
        }
        .scaleEffect(CGFloat(layer.scale))
        .rotationEffect(.degrees(layer.rotation))
        .opacity(layer.opacity)
        .offset(
            x: CGFloat(layer.x) * canvasScale,
            y: CGFloat(layer.y) * canvasScale
        )
        .overlay {
            if isSelected {
                selectionBorder(layer: layer, scale: canvasScale)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isInteractive && !layer.isLocked {
                onSelectLayer?(layer.id)
            }
        }
    }
    
    // MARK: - Render Text Layer
    private func renderTextLayer(layer: CanvasLayer, data: TextLayerData, scale: CGFloat) -> some View {
        Text(data.text)
            .font(fontForLayer(data: data, scale: scale))
            .tracking(CGFloat(data.letterSpacing) * scale)
            .multilineTextAlignment(alignmentFromType(data.alignment))
            .foregroundColor(Color(hex: data.fontColorHex))
            .shadow(
                color: Color(hex: data.shadowColorHex),
                radius: CGFloat(data.shadowRadius) * scale,
                x: CGFloat(data.shadowOffsetX) * scale,
                y: CGFloat(data.shadowOffsetY) * scale
            )
            .frame(width: CGFloat(layer.width) * scale)
    }
    
    // MARK: - Render Sticker Layer
    private func renderStickerLayer(layer: CanvasLayer, data: StickerLayerData, scale: CGFloat) -> some View {
        Image(systemName: data.symbolOrName)
            .resizable()
            .scaledToFit()
            .frame(width: CGFloat(layer.width) * scale, height: CGFloat(layer.height) * scale)
            .foregroundColor(data.tintColorHex != nil ? Color(hex: data.tintColorHex!) : AppTheme.hotPink)
            .shadow(
                color: Color(hex: data.glowColorHex).opacity(data.glowRadius > 0 ? 0.9 : 0.0),
                radius: CGFloat(data.glowRadius) * scale
            )
    }
    
    // MARK: - Render Image Layer
    private func renderImageLayer(layer: CanvasLayer, data: ImageLayerData, scale: CGFloat) -> some View {
        Group {
            #if canImport(UIKit)
            if let path = data.localImagePath,
               let uiImage = ImageProcessorService.shared.loadImageFromDocuments(fileName: path) {
                let filtered = ImageProcessorService.shared.applyFilter(image: uiImage, filter: data.filter)
                Image(uiImage: filtered)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                placeholderImage
            }
            #else
            placeholderImage
            #endif
        }
        .frame(width: CGFloat(layer.width) * scale, height: CGFloat(layer.height) * scale)
        .cornerRadius(CGFloat(data.cornerRadius) * scale)
        .clipped()
    }
    
    private var placeholderImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.surfaceElevated)
            Image(systemName: "photo.fill")
                .font(.system(size: 32))
                .foregroundColor(AppTheme.textSecondary)
        }
    }
    
    // MARK: - Selection Border
    private func selectionBorder(layer: CanvasLayer, scale: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .strokeBorder(
                Color.cyan,
                style: StrokeStyle(lineWidth: 2, dash: [6, 4])
            )
            .padding(-8)
            .overlay(alignment: .topTrailing) {
                if layer.isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .padding(4)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.yellow)
                        .clipShape(Circle())
                        .offset(x: 10, y: -10)
                }
            }
    }
    
    private func fontForLayer(data: TextLayerData, scale: CGFloat) -> Font {
        let size = CGFloat(data.fontSize) * scale
        if data.fontFamily == "System" {
            var f = Font.system(size: size, weight: data.isBold ? .bold : .regular)
            if data.isItalic { f = f.italic() }
            return f
        } else {
            return Font.custom(data.fontFamily, size: size)
        }
    }
    
    private func alignmentFromType(_ type: TextAlignmentType) -> TextAlignment {
        switch type {
        case .left: return .leading
        case .center: return .center
        case .right: return .trailing
        }
    }
}
