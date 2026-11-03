import SwiftUI
import PhotosUI

public struct HomeScreenView: View {
    @State private var selectedCategory: TemplateCategory = .all
    @State private var selectedTemplate: Template?
    @State private var openEditorWithDesign: CardDesign?
    @State private var showSettings: Bool = false
    @State private var showSavedProjects: Bool = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    
    private let templateRepo = TemplateRepository.shared
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundDark
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header Bar
                        headerSection
                        
                        // Quick Action Cards
                        quickCreateSection
                        
                        // Category Horizontal Pills
                        categorySection
                        
                        // Featured Templates
                        featuredSection
                        
                        // Category Grid
                        categoryGridSection
                    }
                    .padding(.bottom, 32)
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(item: $openEditorWithDesign) { design in
                CardEditorView(initialDesign: design)
            }
            .sheet(item: $selectedTemplate) { tpl in
                TemplateDetailView(template: tpl) {
                    selectedTemplate = nil
                    openEditorWithDesign = tpl.cardDesign
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showSavedProjects) {
                SavedProjectsView { project in
                    showSavedProjects = false
                    openEditorWithDesign = project
                }
            }
            .onChange(of: selectedPhotoItem) { item in
                Task {
                    #if canImport(UIKit)
                    if let data = try? await item?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        if let savedName = try? ImageProcessorService.shared.saveImageToDocuments(image: uiImage) {
                            var blank = CardDesign(title: "Thiệp từ ảnh cá nhân")
                            blank.backgroundImagePath = savedName
                            blank.layers.append(
                                CanvasLayer(
                                    name: "Chữ mời",
                                    type: .text,
                                    x: 0, y: -200, width: 750, height: 120,
                                    textData: TextLayerData(text: "LET'S PARTY TOGETHER", fontSize: 36, fontColorHex: "#FFFFFF")
                                )
                            )
                            await MainActor.run {
                                openEditorWithDesign = blank
                            }
                        }
                    }
                    #endif
                }
            }
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("PARTIFUL")
                    .font(.system(size: 26, weight: .black, design: .rounded))
                    .foregroundStyle(AppTheme.partyGradient)
                Text("Thiết kế thiệp & poster sự kiện")
                    .font(AppTypography.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: { showSavedProjects = true }) {
                    Image(systemName: "folder.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(AppTheme.surfaceElevated)
                        .clipShape(Circle())
                }
                
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(AppTheme.surfaceElevated)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Quick Create Cards
    private var quickCreateSection: some View {
        HStack(spacing: 14) {
            // Create Blank
            Button(action: {
                openEditorWithDesign = CardDesign(title: "Thiết kế mới")
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.neonPurple.opacity(0.3))
                            .frame(width: 44, height: 44)
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.brightViolet)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tạo thiệp mới")
                            .font(AppTypography.bodyBold)
                            .foregroundColor(.white)
                        Text("Thiết kế tự do")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(14)
                .background(AppTheme.surfaceElevated)
                .cornerRadius(18)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(AppTheme.surfaceBorder, lineWidth: 1)
                }
            }
            
            // Create from Photo
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.hotPink.opacity(0.3))
                            .frame(width: 44, height: 44)
                        Image(systemName: "photo.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.hotPink)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Từ ảnh cá nhân")
                            .font(AppTypography.bodyBold)
                            .foregroundColor(.white)
                        Text("Chọn từ thư viện")
                            .font(AppTypography.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(14)
                .background(AppTheme.surfaceElevated)
                .cornerRadius(18)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(AppTheme.surfaceBorder, lineWidth: 1)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Categories Pills
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TemplateCategory.allCases) { cat in
                    Button(action: { selectedCategory = cat }) {
                        HStack(spacing: 6) {
                            Image(systemName: cat.iconName)
                                .font(.system(size: 13))
                            Text(cat.rawValue)
                                .font(AppTypography.bodyBold)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == cat ? AppTheme.brightViolet : AppTheme.surfaceElevated)
                        .foregroundColor(selectedCategory == cat ? .white : AppTheme.textSecondary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Featured Horizontal Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Mẫu nổi bật")
                .font(AppTypography.title2)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(templateRepo.templates.prefix(4)) { tpl in
                        templateCard(tpl, width: 220, height: 320)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Category Grid Section
    private var categoryGridSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(selectedCategory == .all ? "Khám phá tất cả mẫu" : selectedCategory.rawValue)
                    .font(AppTypography.title2)
                    .foregroundColor(.white)
                Spacer()
                Text("\(templateRepo.getTemplates(for: selectedCategory).count) mẫu")
                    .font(AppTypography.caption)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.horizontal, 20)
            
            let columns = [
                GridItem(.flexible(), spacing: 14),
                GridItem(.flexible(), spacing: 14)
            ]
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(templateRepo.getTemplates(for: selectedCategory)) { tpl in
                    templateCard(tpl, width: nil, height: 260)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Reusable Template Card
    private func templateCard(_ tpl: Template, width: CGFloat?, height: CGFloat) -> some View {
        Button(action: { selectedTemplate = tpl }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    CanvasRenderView(design: tpl.cardDesign, isInteractive: false)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                }
                .frame(width: width, height: height)
                .cornerRadius(18)
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(AppTheme.surfaceBorder, lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.4), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(tpl.name)
                        .font(AppTypography.bodyBold)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(tpl.category.rawValue)
                        .font(AppTypography.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
