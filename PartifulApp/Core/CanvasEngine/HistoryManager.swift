import Foundation

public final class HistoryManager {
    private var undoStack: [CardDesign] = []
    private var redoStack: [CardDesign] = []
    private let maxHistory: Int
    
    public init(maxHistory: Int = 30) {
        self.maxHistory = maxHistory
    }
    
    public var canUndo: Bool {
        return !undoStack.isEmpty
    }
    
    public var canRedo: Bool {
        return !redoStack.isEmpty
    }
    
    public func saveCheckpoint(_ state: CardDesign) {
        undoStack.append(state)
        if undoStack.count > maxHistory {
            undoStack.removeFirst()
        }
        // Clearing redo stack on new action
        redoStack.removeAll()
    }
    
    public func undo(currentState: CardDesign) -> CardDesign? {
        guard let previousState = undoStack.popLast() else { return nil }
        redoStack.append(currentState)
        return previousState
    }
    
    public func redo(currentState: CardDesign) -> CardDesign? {
        guard let nextState = redoStack.popLast() else { return nil }
        undoStack.append(currentState)
        return nextState
    }
    
    public func clear() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
}
