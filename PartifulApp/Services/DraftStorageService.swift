import Foundation

public final class DraftStorageService {
    public static let shared = DraftStorageService()
    private let fileManager = FileManager.default
    private let draftKey = "com.partiful.currentDraft"
    
    private var projectsFolder: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folder = docs.appendingPathComponent("Projects", isDirectory: true)
        if !fileManager.fileExists(atPath: folder.path) {
            try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true)
        }
        return folder
    }
    
    public init() {}
    
    public func saveDraft(_ design: CardDesign) {
        if let data = try? JSONEncoder().encode(design) {
            UserDefaults.standard.set(data, forKey: draftKey)
        }
    }
    
    public func loadDraft() -> CardDesign? {
        guard let data = UserDefaults.standard.data(forKey: draftKey) else { return nil }
        return try? JSONDecoder().decode(CardDesign.self, from: data)
    }
    
    public func clearDraft() {
        UserDefaults.standard.removeObject(forKey: draftKey)
    }
    
    public func saveProject(_ design: CardDesign) throws {
        var updatedDesign = design
        updatedDesign.updatedAt = Date()
        let fileURL = projectsFolder.appendingPathComponent("\(design.id.uuidString).json")
        let data = try JSONEncoder().encode(updatedDesign)
        try data.write(to: fileURL)
    }
    
    public func getAllProjects() -> [CardDesign] {
        guard let files = try? fileManager.contentsOfDirectory(at: projectsFolder, includingPropertiesForKeys: [.contentModificationDateKey]) else {
            return []
        }
        
        var designs: [CardDesign] = []
        for file in files where file.pathExtension == "json" {
            if let data = try? Data(contentsOf: file),
               let design = try? JSONDecoder().decode(CardDesign.self, from: data) {
                designs.append(design)
            }
        }
        return designs.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    public func deleteProject(id: UUID) {
        let fileURL = projectsFolder.appendingPathComponent("\(id.uuidString).json")
        try? fileManager.removeItem(at: fileURL)
    }
}
