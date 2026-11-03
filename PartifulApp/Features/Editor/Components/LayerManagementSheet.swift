import SwiftUI

public struct LayerManagementSheet: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.cardDesign.layers.sorted(by: { $0.zIndex > $1.zIndex })) { layer in
                    HStack(spacing: 12) {
                        Image(systemName: iconForLayer(layer))
                            .foregroundColor(AppTheme.brightViolet)
                            .frame(width: 28)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(layer.name)
                                .font(AppTypography.bodyBold)
                                .foregroundColor(.white)
                            Text("Thứ tự Z: \(layer.zIndex)")
                                .font(AppTypography.caption)
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        // Visibility toggle
                        Button(action: {
                            if let idx = viewModel.cardDesign.layers.firstIndex(where: { $0.id == layer.id }) {
                                viewModel.cardDesign.layers[idx].isVisible.toggle()
                            }
                        }) {
                            Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                                .foregroundColor(layer.isVisible ? .white : .gray)
                        }
                        
                        // Lock toggle
                        Button(action: {
                            if let idx = viewModel.cardDesign.layers.firstIndex(where: { $0.id == layer.id }) {
                                viewModel.cardDesign.layers[idx].isLocked.toggle()
                            }
                        }) {
                            Image(systemName: layer.isLocked ? "lock.fill" : "lock.open")
                                .foregroundColor(layer.isLocked ? .yellow : .gray)
                        }
                    }
                    .padding(.vertical, 4)
                    .listRowBackground(viewModel.selectedLayerId == layer.id ? AppTheme.surfaceElevated : AppTheme.surfaceDark)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectLayer(id: layer.id)
                    }
                }
                .onDelete { indexSet in
                    viewModel.saveCheckpoint()
                    let sorted = viewModel.cardDesign.layers.sorted(by: { $0.zIndex > $1.zIndex })
                    for index in indexSet {
                        let id = sorted[index].id
                        viewModel.cardDesign.layers.removeAll { $0.id == id }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .background(AppTheme.backgroundDark)
            .scrollContentBackground(.hidden)
            .navigationTitle("Quản lý các lớp (Layers)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Xong") { dismiss() }
                }
            }
        }
    }
    
    private func iconForLayer(_ layer: CanvasLayer) -> String {
        switch layer.type {
        case .text: return "textformat"
        case .sticker: return "sparkles"
        case .image: return "photo.fill"
        case .background: return "paintpalette.fill"
        }
    }
}
