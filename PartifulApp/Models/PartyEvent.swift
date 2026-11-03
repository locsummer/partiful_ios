import Foundation

public struct PartyEvent: Identifiable, Codable, Equatable {
    public var id: UUID
    public var title: String
    public var eventDescription: String
    public var startDate: Date
    public var endDate: Date
    public var location: String
    public var notes: String
    public var hasReminder: Bool
    public var reminderMinutesBefore: Int
    public var isSavedToCalendar: Bool
    public var isSavedToReminders: Bool
    
    public init(
        id: UUID = UUID(),
        title: String = "Summer Rooftop Party",
        eventDescription: String = "Join us for drinks, music, and great vibes under the city lights!",
        startDate: Date = Date().addingTimeInterval(86400 * 2),
        endDate: Date = Date().addingTimeInterval(86400 * 2 + 14400),
        location: String = "123 Skyline Avenue, Rooftop Bar",
        notes: String = "Dress code: Casual chic. BYOB welcome!",
        hasReminder: Bool = true,
        reminderMinutesBefore: Int = 120,
        isSavedToCalendar: Bool = false,
        isSavedToReminders: Bool = false
    ) {
        self.id = id
        self.title = title
        self.eventDescription = eventDescription
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.notes = notes
        self.hasReminder = hasReminder
        self.reminderMinutesBefore = reminderMinutesBefore
        self.isSavedToCalendar = isSavedToCalendar
        self.isSavedToReminders = isSavedToReminders
    }
}
