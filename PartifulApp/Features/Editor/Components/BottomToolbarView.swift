import SwiftUI

public struct BottomToolbarView: View {
    @ObservedObject var viewModel: CardEditorViewModel
    
    public var body: some View {
        VStack(spacing: 8) {
            // Selected Layer Quick Actions Bar (if a layer is selected)
            if let layer = viewModel.selectedLayer {
                quickLayerActionBar(layer: layer)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // Primary Creation Tools
            HStack(spacing: 16) {
                toolButton(title: "Văn bản", icon: "textformat", sheet: .text)
                toolButton(title: "Ảnh", icon: "photo.badge.plus", sheet: .photoPicker)
                toolButton(title: "Sticker", icon: "sparkles", sheet: .stickers)
                toolButton(title: "Hiệu ứng", icon: "slider.horizontal.3", sheet: .filters)
                toolButton(title: "Nền", icon: "paintpalette.fill", sheet: .background)
                toolButton(title: "Lớp", icon: "square.3.layers.3d", sheet: .layers)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppTheme.surfaceDark.opacity(0.95))
            .cornerRadius(24)
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(AppTheme.surfaceBorder, lineWidth: 1)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
    }
    
    @ViewBuilder
    private func quickLayerActionBar(layer: CanvasLayer) -> some View {
        HStack(spacing: 18) {
            Button(action: { viewModel.duplicateSelectedLayer() }) {
                Label("Nhân bản", systemImage: "plus.square.on.square")
            }
            Divider().frame(height: 18)
            Button(action: { viewModel.bringForward() }) {
                Image(systemName: "arrow.up.square")
            }
            Button(action: { viewModel.sendBackward() }) {
                Image(systemName: "arrow.down.square")
            }
            Divider().frame(height: 18)
            Button(action: { viewModel.toggleLockSelectedLayer() }) {
                Image(systemName: layer.isLocked ? "lock.fill" : "lock.open")
                    .foregroundColor(layer.isLocked ? .yellow : .white)
            }
            Divider().frame(height: 18)
            Button(action: { viewModel.deleteSelectedLayer() }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(AppTheme.surfaceElevated)
        .cornerRadius(16)
    }
    
    private func toolButton(title: String, icon: String, sheet: ActiveToolSheet) -> some View {
        Button(action: {
            if sheet == .text && viewModel.selectedLayer?.type != .text {
                viewModel.addTextLayer(text: "HAPPY BIRTHDAY")
            } else {
                viewModel.activeSheet = sheet
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(AppTypography.caption)
            }
            .foregroundColor(viewModel.activeSheet == sheet ? AppTheme.brightViolet : AppTheme.textPrimary)
            .frame(maxWidth: .infinity)
        }
    }
}
