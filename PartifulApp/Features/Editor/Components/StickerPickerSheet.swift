import SwiftUI

public struct StickerItem: Identifiable {
    public let id = UUID()
    public let name: String
    public let symbol: String
    public let category: String
}

public struct StickerPickerSheet: View {
    @ObservedObject var viewModel: CardEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedCategory: String = "Tất cả"
    
    let categories = ["Tất cả", "Sinh nhật", "Tiệc & Rượu", "Âm nhạc", "Tình yêu", "Lễ hội"]
    
    let stickers: [StickerItem] = [
        // Sinh nhật
        StickerItem(name: "Bánh kem", symbol: "birthday.cake.fill", category: "Sinh nhật"),
        StickerItem(name: "Bóng bay", symbol: "balloon.fill", category: "Sinh nhật"),
        StickerItem(name: "Hộp quà", symbol: "gift.fill", category: "Sinh nhật"),
        StickerItem(name: "Vương miện", symbol: "crown.fill", category: "Sinh nhật"),
        
        // Tiệc & Rượu
        StickerItem(name: "Ly cocktail", symbol: "wineglass.fill", category: "Tiệc & Rượu"),
        StickerItem(name: "Bia", symbol: "mug.fill", category: "Tiệc & Rượu"),
        StickerItem(name: "Pháo hoa", symbol: "sparkles", category: "Tiệc & Rượu"),
        StickerItem(name: "Lửa trại", symbol: "flame.fill", category: "Tiệc & Rượu"),
        
        // Âm nhạc
        StickerItem(name: "Nốt nhạc", symbol: "music.note", category: "Âm nhạc"),
        StickerItem(name: "Tai nghe", symbol: "headphones", category: "Âm nhạc"),
        StickerItem(name: "Guitar", symbol: "guitars.fill", category: "Âm nhạc"),
        StickerItem(name: "Loa", symbol: "speaker.wave.3.fill", category: "Âm nhạc"),
        
        // Tình yêu & Ngôi sao
        StickerItem(name: "Trái tim", symbol: "heart.fill", category: "Tình yêu"),
        StickerItem(name: "Ngôi sao", symbol: "star.fill", category: "Tình yêu"),
        StickerItem(name: "Mặt trăng", symbol: "moon.stars.fill", category: "Tình yêu"),
        StickerItem(name: "Mặt trời", symbol: "sun.max.fill", category: "Tình yêu"),
        
        // Lễ hội
        StickerItem(name: "Mũ cử nhân", symbol: "graduationcap.fill", category: "Lễ hội"),
        StickerItem(name: "Bông tuyết", symbol: "snowflake", category: "Lễ hội"),
        StickerItem(name: "Cờ tiệc", symbol: "flag.fill", category: "Lễ hội"),
        StickerItem(name: "Chuông", symbol: "bell.fill", category: "Lễ hội")
    ]
    
    var filteredStickers: [StickerItem] {
        if selectedCategory == "Tất cả" {
            return stickers
        }
        return stickers.filter { $0.category == selectedCategory }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 75), spacing: 16)
    ]
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: { selectedCategory = cat }) {
                                Text(cat)
                                    .font(AppTypography.caption)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedCategory == cat ? AppTheme.brightViolet : AppTheme.surfaceElevated)
                                    .cornerRadius(20)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(AppTheme.surfaceDark)
                
                // Sticker Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredStickers) { sticker in
                            Button(action: {
                                viewModel.addStickerLayer(symbol: sticker.symbol, category: sticker.category)
                                dismiss()
                            }) {
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(AppTheme.surfaceElevated)
                                            .frame(height: 75)
                                        Image(systemName: sticker.symbol)
                                            .font(.system(size: 32))
                                            .foregroundColor(AppTheme.hotPink)
                                    }
                                    Text(sticker.name)
                                        .font(AppTypography.caption)
                                        .foregroundColor(AppTheme.textSecondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .background(AppTheme.backgroundDark)
            }
            .navigationTitle("Thư viện Sticker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
        }
    }
}
