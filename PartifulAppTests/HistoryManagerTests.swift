import XCTest
@testable import PartifulApp

final class HistoryManagerTests: XCTestCase {
    
    func testUndoRedoFlow() {
        let history = HistoryManager(maxHistory: 5)
        
        var state1 = CardDesign(title: "Version 1")
        var state2 = CardDesign(title: "Version 2")
        var state3 = CardDesign(title: "Version 3")
        
        XCTAssertFalse(history.canUndo)
        XCTAssertFalse(history.canRedo)
        
        // Save state 1, then mutate to state 2
        history.saveCheckpoint(state1)
        XCTAssertTrue(history.canUndo)
        XCTAssertFalse(history.canRedo)
        
        // Save state 2, mutate to state 3
        history.saveCheckpoint(state2)
        
        // Undo from state 3 -> should restore state 2
        let undone = history.undo(currentState: state3)
        XCTAssertEqual(undone?.title, "Version 2")
        XCTAssertTrue(history.canRedo)
        
        // Redo -> should restore state 3
        let redone = history.redo(currentState: undone!)
        XCTAssertEqual(redone?.title, "Version 3")
    }
    
    func testHistoryCapacityLimit() {
        let history = HistoryManager(maxHistory: 3)
        for i in 1...10 {
            history.saveCheckpoint(CardDesign(title: "Ver \(i)"))
        }
        
        // Should only be able to undo 3 times
        var count = 0
        var current = CardDesign(title: "Ver 11")
        while let prev = history.undo(currentState: current) {
            count += 1
            current = prev
        }
        XCTAssertEqual(count, 3)
    }
}
