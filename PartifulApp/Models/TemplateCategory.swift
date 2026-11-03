import Foundation

public enum TemplateCategory: String, Codable, CaseIterable, Identifiable {
    case all = "Tất cả"
    case birthday = "Sinh nhật"
    case wedding = "Tiệc cưới"
    case graduation = "Tốt nghiệp"
    case halloween = "Halloween"
    case christmas = "Giáng sinh"
    case newYear = "Năm mới"
    case music = "Âm nhạc"
    case outdoor = "Ngoài trời"
    case friends = "Họp mặt bạn bè"
    case grandOpening = "Khai trương"
    case privateParty = "Tiệc riêng tư"
    
    public var id: String { self.rawValue }
    
    public var iconName: String {
        switch self {
        case .all: return "sparkles"
        case .birthday: return "birthday.cake.fill"
        case .wedding: return "heart.circle.fill"
        case .graduation: return "graduationcap.fill"
        case .halloween: return "moon.stars.fill"
        case .christmas: return "snowflake"
        case .newYear: return "fireworks"
        case .music: return "music.note.house.fill"
        case .outdoor: return "sun.max.fill"
        case .friends: return "person.3.fill"
        case .grandOpening: return "megaphone.fill"
        case .privateParty: return "lock.shield.fill"
        }
    }
}
