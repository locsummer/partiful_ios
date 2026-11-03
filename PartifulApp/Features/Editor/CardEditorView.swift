import SwiftUI
import PhotosUI

public struct CardEditorView: View {
    @StateObject private var viewModel: CardEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var navigateToPreview: Bool = false
    @State private var showSaveAlert: Bool = false
    
    // Drag and gesture state
    @State private var dragOffset: CGSize = .zero
    
    public init(initialDesign: CardDesign? = nil) {
        _viewModel = StateObject(wrappedValue: CardEditorViewModel(initialDesign: initialDesign))
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                // Background of workspace
                AppTheme.backgroundDark
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Navigation Bar
                    topEditorBar
                    
                    // Main Canvas Area
                    GeometryReader { proxy in
                        ZStack {
                            // Canvas Render with Gestures
                            CanvasRenderView(
                                design: viewModel.cardDesign,
                                selectedLayerId: viewModel.selectedLayerId,
                                isInteractive: true,
                                onSelectLayer: { layerId in
                                    viewModel.selectLayer(id: layerId)
                                }
                            )
                            .shadow(color: Color.black.opacity(0.6), radius: 20, x: 0, y: 10)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if let id = viewModel.selectedLayerId {
                                            viewModel.updatePosition(
                                                for: id,
                                                newX: Double(value.translation.width * 2),
                                                newY: Double(value.translation.height * 2)
                                            )
                                        }
                                    }
                                    .onEnded { _ in
                                        viewModel.saveCheckpoint()
                                    }
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.deselectLayer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    // Bottom Toolbars
                    BottomToolbarView(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToPreview) {
                CardPreviewView(cardDesign: viewModel.cardDesign)
            }
            // Tool Sheets
            .sheet(item: $viewModel.activeSheet) { sheet in
                switch sheet {
                case .text:
                    TextEditorSheet(viewModel: viewModel)
                case .stickers:
                    StickerPickerSheet(viewModel: viewModel)
                case .filters:
                    FilterAdjustmentSheet(viewModel: viewModel)
                case .layers:
                    LayerManagementSheet(viewModel: viewModel)
                case .photoPicker:
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                        Text("Mở thư viện ảnh")
                    }
                case .background:
                    backgroundPickerSheet
                }
            }
            .onChange(of: selectedPhotoItem) { newItem in
                Task {
                    #if canImport(UIKit)
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        viewModel.addImageLayer(uiImage: uiImage)
                    }
                    #endif
                }
            }
            .alert("Bản thiết kế đã lưu!", isPresented: $showSaveAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
    
    // MARK: - Top Editor Bar
    private var topEditorBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(AppTheme.surfaceElevated)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Undo & Redo
            HStack(spacing: 8) {
                Button(action: { viewModel.undo() }) {
                    Image(systemName: "arrow.uturn.backward")
                        .foregroundColor(viewModel.canUndo ? .white : AppTheme.textMuted)
                        .padding(8)
                        .background(AppTheme.surfaceElevated)
                        .clipShape(Circle())
                }
                .disabled(!viewModel.canUndo)
                
                Button(action: { viewModel.redo() }) {
                    Image(systemName: "arrow.uturn.forward")
                        .foregroundColor(viewModel.canRedo ? .white : AppTheme.textMuted)
                        .padding(8)
                        .background(AppTheme.surfaceElevated)
                        .clipShape(Circle())
                }
                .disabled(!viewModel.canRedo)
            }
            
            Spacer()
            
            // Save Draft & Preview
            HStack(spacing: 8) {
                Button(action: {
                    viewModel.saveProject()
                    showSaveAlert = true
                }) {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(AppTheme.surfaceElevated)
                        .clipShape(Circle())
                }
                
                Button(action: { navigateToPreview = true }) {
                    HStack(spacing: 6) {
                        Text("Xem trước")
                            .font(AppTypography.caption)
                        Image(systemName: "eye.fill")
                            .font(.system(size: 14))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(AppTheme.partyGradient)
                    .cornerRadius(18)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(AppTheme.surfaceDark.opacity(0.8))
    }
    
    // MARK: - Background Color Picker Sheet
    private var backgroundPickerSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Chọn màu nền gradient")
                        .font(AppTypography.bodyBold)
                        .foregroundColor(.white)
                    
                    let gradients: [[String]] = [
                        ["#0F051D", "#2E0249", "#570A57"],
                        ["#0B132B", "#1C2541", "#3A506B"],
                        ["#160000", "#370617", "#03071E"],
                        ["#0A2E20", "#1E4D2B", "#05160E"],
                        ["#1A181B", "#372549", "#000000"],
                        ["#0B032D", "#1C0F4F", "#030219"],
                        ["#3D1300", "#7C2D12", "#EA580C"],
                        ["#18181B", "#27272A", "#09090B"]
                    ]
                    
                    ForEach(gradients, id: \.self) { grad in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: grad.map { Color(hex: $0) },
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(height: 60)
                            .overlay {
                                Text("Gradient")
                                    .font(AppTypography.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .onTapGesture {
                                viewModel.setBackgroundGradients(hexes: grad)
                                viewModel.activeSheet = nil
                            }
                    }
                }
                .padding()
            }
            .background(AppTheme.backgroundDark)
            .navigationTitle("Nền thiệp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { viewModel.activeSheet = nil }
                }
            }
        }
    }
}
