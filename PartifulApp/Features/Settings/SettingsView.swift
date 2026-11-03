import SwiftUI

public struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("defaultExportFormat") private var defaultExportFormat: String = "PNG"
    @AppStorage("defaultResolution") private var defaultResolution: Double = 2.0
    @AppStorage("defaultReminderMinutes") private var defaultReminderMinutes: Int = 60
    
    @State private var showClearedAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Tùy chọn xuất file").foregroundColor(AppTheme.brightViolet)) {
                    Picker("Định dạng mặc định", selection: $defaultExportFormat) {
                        Text("PNG").tag("PNG")
                        Text("JPG").tag("JPG")
                        Text("PDF").tag("PDF")
                    }
                    
                    Picker("Độ phân giải mặc định", selection: $defaultResolution) {
                        Text("1x (1080p)").tag(1.0)
                        Text("2x (HD 4K)").tag(2.0)
                        Text("3x (In ấn 300 DPI)").tag(3.0)
                    }
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section(header: Text("Tích hợp Lịch & Lời nhắc").foregroundColor(AppTheme.brightViolet)) {
                    Picker("Thời gian nhắc mặc định", selection: $defaultReminderMinutes) {
                        Text("15 phút").tag(15)
                        Text("30 phút").tag(30)
                        Text("1 giờ").tag(60)
                        Text("2 giờ").tag(120)
                    }
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section(header: Text("Bộ nhớ & Dữ liệu").foregroundColor(AppTheme.brightViolet)) {
                    Button(action: {
                        DraftStorageService.shared.clearDraft()
                        showClearedAlert = true
                    }) {
                        Text("Xóa bản nháp đang chỉnh sửa")
                            .foregroundColor(.red)
                    }
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section(header: Text("Thông tin ứng dụng").foregroundColor(AppTheme.brightViolet)) {
                    HStack {
                        Text("Phiên bản")
                        Spacer()
                        Text("1.0.0 (Native Swift)")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    HStack {
                        Text("Nền tảng")
                        Spacer()
                        Text("iOS 17+ (SwiftUI & MVVM)")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    HStack {
                        Text("Bảo mật dữ liệu")
                        Spacer()
                        Text("Offline-first 100%")
                            .foregroundColor(AppTheme.emeraldMint)
                    }
                }
                .listRowBackground(AppTheme.surfaceElevated)
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.backgroundDark)
            .navigationTitle("Cài đặt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Đóng") { dismiss() }
                }
            }
            .alert("Đã xóa bản nháp!", isPresented: $showClearedAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}
