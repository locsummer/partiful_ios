import SwiftUI

public struct TextEditorSheet: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var textContent: String = ""
    @State private var fontSize: Double = 32.0
    @State private var fontColorHex: String = "#FFFFFF"
    @State private var selectedFont: String = "System"
    @State private var alignment: TextAlignmentType = .center
    @State private var isBold: Bool = true
    @State private var isItalic: Bool = false
    @State private var letterSpacing: Double = 1.0
    @State private var shadowRadius: Double = 4.0
    
    let presets = [
        "YOU ARE INVITED",
        "HAPPY BIRTHDAY",
        "LET'S PARTY",
        "PARTY TONIGHT",
        "SAVE THE DATE",
        "CELEBRATE WITH US",
        "VIP ACCESS ONLY",
        "DRINKS & GOOD VIBES"
    ]
    
    let colorPalette = [
        "#FFFFFF", "#FF007F", "#8A2BE2", "#00F0FF",
        "#FBBF24", "#10B981", "#FF5400", "#E5C3A6",
        "#000000", "#71717A"
    ]
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Text Input Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nội dung văn bản")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        TextField("Nhập chữ...", text: $textContent, axis: .vertical)
                            .lineLimit(3)
                            .font(.system(size: 18, weight: .semibold))
                            .padding()
                            .background(AppTheme.surfaceElevated)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    // Presets Carousel
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mẫu câu có sẵn")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(presets, id: \.self) { preset in
                                    Button(action: { textContent = preset }) {
                                        Text(preset)
                                            .font(AppTypography.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(AppTheme.surfaceElevated)
                                            .cornerRadius(20)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Color Palette
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Màu chữ")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                        
                        HStack(spacing: 12) {
                            ForEach(colorPalette, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 32, height: 32)
                                    .overlay {
                                        if fontColorHex == hex {
                                            Circle().stroke(Color.white, lineWidth: 3)
                                        }
                                    }
                                    .onTapGesture {
                                        fontColorHex = hex
                                    }
                            }
                        }
                    }
                    
                    // Font Size Slider
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Cỡ chữ")
                            Spacer()
                            Text("\(Int(fontSize)) pt")
                        }
                        .font(AppTypography.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        
                        Slider(value: $fontSize, in: 14...100, step: 1)
                            .tint(AppTheme.brightViolet)
                    }
                    
                    // Style & Alignment Controls
                    HStack(spacing: 20) {
                        Button(action: { isBold.toggle() }) {
                            Image(systemName: "bold")
                                .frame(width: 44, height: 44)
                                .background(isBold ? AppTheme.brightViolet : AppTheme.surfaceElevated)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: { isItalic.toggle() }) {
                            Image(systemName: "italic")
                                .frame(width: 44, height: 44)
                                .background(isItalic ? AppTheme.brightViolet : AppTheme.surfaceElevated)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        // Alignment
                        HStack(spacing: 4) {
                            alignButton(icon: "text.alignleft", type: .left)
                            alignButton(icon: "text.aligncenter", type: .center)
                            alignButton(icon: "text.alignright", type: .right)
                        }
                        .padding(4)
                        .background(AppTheme.surfaceElevated)
                        .cornerRadius(12)
                    }
                    
                    // Letter Spacing Slider
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Khoảng cách chữ")
                            Spacer()
                            Text(String(format: "%.1f", letterSpacing))
                        }
                        .font(AppTypography.caption)
                        .foregroundColor(AppTheme.textSecondary)
                        
                        Slider(value: $letterSpacing, in: 0...10, step: 0.5)
                            .tint(AppTheme.hotPink)
                    }
                }
                .padding()
            }
            .background(AppTheme.backgroundDark)
            .navigationTitle("Chỉnh sửa văn bản")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Áp dụng") {
                        applyChanges()
                        dismiss()
                    }
                    .foregroundColor(AppTheme.brightViolet)
                }
            }
            .onAppear(perform: loadInitialData)
        }
    }
    
    private func alignButton(icon: String, type: TextAlignmentType) -> some View {
        Button(action: { alignment = type }) {
            Image(systemName: icon)
                .frame(width: 36, height: 36)
                .background(alignment == type ? AppTheme.brightViolet : Color.clear)
                .cornerRadius(8)
                .foregroundColor(.white)
        }
    }
    
    private func loadInitialData() {
        if let data = viewModel.selectedLayer?.textData {
            textContent = data.text
            fontSize = data.fontSize
            fontColorHex = data.fontColorHex
            selectedFont = data.fontFamily
            alignment = data.alignment
            isBold = data.isBold
            isItalic = data.isItalic
            letterSpacing = data.letterSpacing
            shadowRadius = data.shadowRadius
        }
    }
    
    private func applyChanges() {
        var updated = viewModel.selectedLayer?.textData ?? TextLayerData()
        updated.text = textContent.isEmpty ? "PARTY TIME" : textContent
        updated.fontSize = fontSize
        updated.fontColorHex = fontColorHex
        updated.fontFamily = selectedFont
        updated.alignment = alignment
        updated.isBold = isBold
        updated.isItalic = isItalic
        updated.letterSpacing = letterSpacing
        updated.shadowRadius = shadowRadius
        viewModel.updateSelectedTextData(updated)
    }
}
