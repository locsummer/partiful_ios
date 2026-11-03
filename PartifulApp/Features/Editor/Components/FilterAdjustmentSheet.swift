import SwiftUI

public struct FilterAdjustmentSheet: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var brightness: Double = 0.0
    @State private var contrast: Double = 1.0
    @State private var saturation: Double = 1.0
    @State private var blurRadius: Double = 0.0
    @State private var vignette: Double = 0.0
    @State private var selectedPreset: String = "Normal"
    
    let presets = ["Normal", "Neon", "Vintage", "B&W"]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Preset Badges
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Bộ lọc phong cách")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        HStack(spacing: 12) {
                            ForEach(presets, id: \.self) { preset in
                                Button(action: {
                                    selectedPreset = preset
                                    applyPreset(preset)
                                }) {
                                    Text(preset)
                                        .font(AppTypography.title3)
                                        .padding(.horizontal, 18)
                                        .padding(.vertical, 10)
                                        .background(selectedPreset == preset ? AppTheme.brightViolet : AppTheme.surfaceElevated)
                                        .cornerRadius(14)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                    Divider().background(AppTheme.surfaceBorder)
                    
                    // Sliders
                    sliderRow(title: "Độ sáng (Brightness)", value: $brightness, range: -0.5...0.5, step: 0.05, tint: AppTheme.amberGlow)
                    sliderRow(title: "Độ tương phản (Contrast)", value: $contrast, range: 0.5...2.0, step: 0.05, tint: AppTheme.sunsetCoral)
                    sliderRow(title: "Độ bão hòa (Saturation)", value: $saturation, range: 0.0...2.0, step: 0.05, tint: AppTheme.hotPink)
                    sliderRow(title: "Độ mờ nền (Blur)", value: $blurRadius, range: 0.0...10.0, step: 0.5, tint: AppTheme.cyanVibe)
                    sliderRow(title: "Hiệu ứng viền tối (Vignette)", value: $vignette, range: 0.0...1.0, step: 0.05, tint: AppTheme.neonPurple)
                    
                    // Reset Button
                    Button("Đặt lại mặc định") {
                        resetToDefault()
                    }
                    .foregroundColor(.red)
                    .padding(.top, 8)
                }
                .padding()
            }
            .background(AppTheme.backgroundDark)
            .navigationTitle("Bộ lọc & Hiệu ứng")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lưu") {
                        saveFilter()
                        dismiss()
                    }
                    .foregroundColor(AppTheme.brightViolet)
                }
            }
            .onAppear(perform: loadFilter)
        }
    }
    
    private func sliderRow(title: String, value: Binding<Double>, range: ClosedRange<Double>, step: Double, tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text(String(format: "%.2f", value.wrappedValue))
            }
            .font(AppTypography.caption)
            .foregroundColor(AppTheme.textSecondary)
            
            Slider(value: value, in: range, step: step)
                .tint(tint)
        }
    }
    
    private func loadFilter() {
        if let layer = viewModel.selectedLayer, let imgData = layer.imageData {
            brightness = imgData.filter.brightness
            contrast = imgData.filter.contrast
            saturation = imgData.filter.saturation
            blurRadius = imgData.filter.blurRadius
            vignette = imgData.filter.vignetteIntensity
            selectedPreset = imgData.filter.presetName
        }
    }
    
    private func applyPreset(_ name: String) {
        switch name {
        case "Neon":
            brightness = 0.05
            contrast = 1.3
            saturation = 1.6
            vignette = 0.2
        case "Vintage":
            brightness = -0.05
            contrast = 1.1
            saturation = 0.8
            vignette = 0.4
        case "B&W":
            saturation = 0.0
            contrast = 1.4
            brightness = 0.0
        default:
            resetToDefault()
        }
    }
    
    private func resetToDefault() {
        brightness = 0.0
        contrast = 1.0
        saturation = 1.0
        blurRadius = 0.0
        vignette = 0.0
        selectedPreset = "Normal"
    }
    
    private func saveFilter() {
        guard let id = viewModel.selectedLayerId,
              let index = viewModel.cardDesign.layers.firstIndex(where: { $0.id == id }) else { return }
        viewModel.saveCheckpoint()
        var effect = FilterEffect(
            brightness: brightness,
            contrast: contrast,
            saturation: saturation,
            blurRadius: blurRadius,
            vignetteIntensity: vignette,
            presetName: selectedPreset
        )
        if viewModel.cardDesign.layers[index].imageData != nil {
            viewModel.cardDesign.layers[index].imageData?.filter = effect
        }
    }
}
