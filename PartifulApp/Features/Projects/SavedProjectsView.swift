import SwiftUI

public struct SavedProjectsView: View {
    public let onOpenProject: (CardDesign) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var projects: [CardDesign] = []
    
    public init(onOpenProject: @escaping (CardDesign) -> Void) {
        self.onOpenProject = onOpenProject
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundDark
                    .ignoresSafeArea()
                
                if projects.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "folder.badge.questionmark")
                            .font(.system(size: 64))
                            .foregroundColor(AppTheme.textSecondary)
                        Text("Chưa có bản thiết kế nào")
                            .font(AppTypography.title2)
                            .foregroundColor(.white)
                        Text("Các thiệp và bản nháp bạn đã lưu sẽ hiển thị ở đây.")
                            .font(AppTypography.body)
                            .foregroundColor(AppTheme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    ScrollView {
                        let columns = [
                            GridItem(.flexible(), spacing: 14),
                            GridItem(.flexible(), spacing: 14)
                        ]
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(projects) { project in
                                Button(action: {
                                    onOpenProject(project)
                                }) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            CanvasRenderView(design: project, isInteractive: false)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .clipped()
                                        }
                                        .frame(height: 240)
                                        .cornerRadius(16)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(AppTheme.surfaceBorder, lineWidth: 1)
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(project.title)
                                                    .font(AppTypography.bodyBold)
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                Text(project.updatedAt.formatted(date: .abbreviated, time: .shortened))
                                                    .font(AppTypography.caption)
                                                    .foregroundColor(AppTheme.textSecondary)
                                            }
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                delete(project: project)
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.red.opacity(0.8))
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Thiết kế đã lưu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .onAppear(perform: loadProjects)
        }
    }
    
    private func loadProjects() {
        projects = DraftStorageService.shared.getAllProjects()
    }
    
    private func delete(project: CardDesign) {
        DraftStorageService.shared.deleteProject(id: project.id)
        loadProjects()
    }
}
