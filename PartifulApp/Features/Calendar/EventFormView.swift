import SwiftUI

public struct EventFormView: View {
    @State private var event: PartyEvent
    @Environment(\.dismiss) private var dismiss
    
    @State private var isSaving: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var confirmationMessage: String = ""
    @State private var errorMessage: String?
    @State private var showErrorAlert: Bool = false
    
    public init(event: PartyEvent) {
        _event = State(initialValue: event)
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Thông tin bữa tiệc").foregroundColor(AppTheme.brightViolet)) {
                    TextField("Tên sự kiện", text: $event.title)
                        .foregroundColor(.white)
                    TextField("Địa điểm tổ chức", text: $event.location)
                        .foregroundColor(.white)
                    TextField("Mô tả sự kiện", text: $event.eventDescription, axis: .vertical)
                        .lineLimit(3)
                        .foregroundColor(.white)
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section(header: Text("Thời gian").foregroundColor(AppTheme.brightViolet)) {
                    DatePicker("Bắt đầu", selection: $event.startDate)
                        .tint(AppTheme.brightViolet)
                    DatePicker("Kết thúc", selection: $event.endDate, in: event.startDate...)
                        .tint(AppTheme.brightViolet)
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section(header: Text("Nhắc nhở & Lịch").foregroundColor(AppTheme.brightViolet)) {
                    Toggle("Thêm lời nhắc trước giờ tiệc", isOn: $event.hasReminder)
                        .tint(AppTheme.brightViolet)
                    
                    if event.hasReminder {
                        Picker("Nhắc trước", selection: $event.reminderMinutesBefore) {
                            Text("15 phút").tag(15)
                            Text("30 phút").tag(30)
                            Text("1 giờ").tag(60)
                            Text("2 giờ").tag(120)
                            Text("1 ngày").tag(1440)
                        }
                    }
                    
                    TextField("Ghi chú bổ sung (VD: trang phục, đồ uống mang theo)", text: $event.notes, axis: .vertical)
                        .lineLimit(2)
                        .foregroundColor(.white)
                }
                .listRowBackground(AppTheme.surfaceElevated)
                
                Section {
                    Button(action: saveToCalendar) {
                        HStack {
                            Spacer()
                            if isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "calendar.badge.plus")
                                Text("Lưu vào Apple Calendar")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(AppTheme.partyGradient)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppTheme.backgroundDark)
            .navigationTitle("Lưu sự kiện vào Lịch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") { dismiss() }
                }
            }
            .navigationDestination(isPresented: $showConfirmation) {
                CalendarConfirmationView(event: event, confirmationMessage: confirmationMessage) {
                    dismiss()
                }
            }
            .alert("Lỗi", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "Đã xảy ra lỗi khi thêm vào Lịch.")
            }
        }
    }
    
    private func saveToCalendar() {
        isSaving = true
        Task {
            do {
                _ = try await CalendarService.shared.saveEvent(event)
                if event.hasReminder {
                    _ = try? await CalendarService.shared.saveReminder(event)
                }
                await MainActor.run {
                    isSaving = false
                    confirmationMessage = "Sự kiện \"\(event.title)\" đã được lên lịch thành công trong Apple Calendar!"
                    showConfirmation = true
                }
            } catch {
                await MainActor.run {
                    isSaving = false
                    errorMessage = error.localizedDescription
                    showErrorAlert = true
                }
            }
        }
    }
}

public struct CalendarConfirmationView: View {
    public let event: PartyEvent
    public let confirmationMessage: String
    public let onDone: () -> Void
    
    public var body: some View {
        ZStack {
            AppTheme.backgroundDark
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(AppTheme.emeraldMint.opacity(0.2))
                        .frame(width: 120, height: 120)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 72))
                        .foregroundColor(AppTheme.emeraldMint)
                }
                
                Text("Đã thêm vào Lịch!")
                    .font(AppTypography.heroTitle)
                    .foregroundColor(.white)
                
                Text(confirmationMessage)
                    .font(AppTypography.body)
                    .foregroundColor(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                GlassCard {
                    VStack(alignment: .leading, spacing: 10) {
                        Label(event.title, systemImage: "sparkles")
                            .font(AppTypography.title3)
                            .foregroundColor(.white)
                        Label(event.location, systemImage: "mappin.and.ellipse")
                            .font(AppTypography.body)
                            .foregroundColor(AppTheme.textSecondary)
                        Label(event.startDate.formatted(date: .abbreviated, time: .shortened), systemImage: "clock.fill")
                            .font(AppTypography.body)
                            .foregroundColor(AppTheme.brightViolet)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                NeonButton(
                    title: "Hoàn tất",
                    icon: "checkmark",
                    gradient: AppTheme.partyGradient
                ) {
                    onDone()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationBarHidden(true)
    }
}
