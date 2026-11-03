import Foundation
import EventKit

public enum CalendarError: LocalizedError {
    case permissionDenied
    case permissionRestricted
    case calendarNotFound
    case failedToSave(String)
    
    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Quyền truy cập Lịch hoặc Lời nhắc đã bị từ chối. Vui lòng cấp quyền trong Cài đặt."
        case .permissionRestricted:
            return "Quyền truy cập Lịch bị giới hạn trên thiết bị này."
        case .calendarNotFound:
            return "Không tìm thấy ứng dụng Lịch mặc định."
        case .failedToSave(let reason):
            return "Không thể lưu sự kiện: \(reason)"
        }
    }
}

public protocol CalendarServiceProtocol {
    func checkCalendarPermission() -> EKAuthorizationStatus
    func requestCalendarAccess() async throws -> Bool
    func saveEvent(_ event: PartyEvent) async throws -> String
    func saveReminder(_ event: PartyEvent) async throws -> String
}

public final class CalendarService: CalendarServiceProtocol {
    public static let shared = CalendarService()
    private let eventStore = EKEventStore()
    
    public init() {}
    
    public func checkCalendarPermission() -> EKAuthorizationStatus {
        if #available(iOS 17.0, *) {
            return EKEventStore.authorizationStatus(for: .event)
        } else {
            return EKEventStore.authorizationStatus(for: .event)
        }
    }
    
    public func requestCalendarAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                eventStore.requestAccess(to: .event) { granted, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
    
    public func requestReminderAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToReminders()
        } else {
            return try await withCheckedThrowingContinuation { continuation in
                eventStore.requestAccess(to: .reminder) { granted, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            }
        }
    }
    
    public func saveEvent(_ partyEvent: PartyEvent) async throws -> String {
        let granted = try await requestCalendarAccess()
        guard granted else {
            throw CalendarError.permissionDenied
        }
        
        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = partyEvent.title
        ekEvent.notes = "\(partyEvent.eventDescription)\n\n\(partyEvent.notes)"
        ekEvent.startDate = partyEvent.startDate
        ekEvent.endDate = partyEvent.endDate
        ekEvent.location = partyEvent.location
        ekEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        if partyEvent.hasReminder {
            let alarm = EKAlarm(relativeOffset: -TimeInterval(partyEvent.reminderMinutesBefore * 60))
            ekEvent.addAlarm(alarm)
        }
        
        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            return ekEvent.eventIdentifier ?? UUID().uuidString
        } catch {
            throw CalendarError.failedToSave(error.localizedDescription)
        }
    }
    
    public func saveReminder(_ partyEvent: PartyEvent) async throws -> String {
        let granted = try await requestReminderAccess()
        guard granted else {
            throw CalendarError.permissionDenied
        }
        
        let ekReminder = EKReminder(eventStore: eventStore)
        ekReminder.title = "🎉 " + partyEvent.title
        ekReminder.notes = "Địa điểm: \(partyEvent.location)\n\(partyEvent.eventDescription)"
        ekReminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: partyEvent.startDate)
        ekReminder.dueDateComponents = components
        
        let alarm = EKAlarm(relativeOffset: -TimeInterval(partyEvent.reminderMinutesBefore * 60))
        ekReminder.addAlarm(alarm)
        
        do {
            try eventStore.save(ekReminder, commit: true)
            return ekReminder.calendarItemIdentifier
        } catch {
            throw CalendarError.failedToSave(error.localizedDescription)
        }
    }
}
