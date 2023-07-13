import SwiftUI

struct TimeEvent: Identifiable, Hashable {
    var id: UUID
    var name: String
    var date: Date
    var isStreak: Bool
    var color: String
    var isPinned: Bool
    var created: Date
    
    init(name: String = "", date: Date = Date(), isStreak: Bool = false, color: String = Color("DarkOrange").toHex()!, isPinned: Bool = false, created: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.isStreak = isStreak
        self.color = color
        self.isPinned = isPinned
        self.created = created
    }
}

extension Task {
    func timeDiff() -> Int {
        return 10
    }
}
