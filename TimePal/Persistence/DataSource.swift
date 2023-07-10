import Foundation
import CoreData


class DataSource: NSObject, ObservableObject {
    
    static let shared = DataSource(type: .normal)
    static let preview = DataSource(type: .preview)
    static let testing = DataSource(type: .testing)
    
    @Published var timeEvents: Dictionary<UUID, TimeEvent> = [:]
    
    var timeEventsArray: [TimeEvent] {
        
        Array(timeEvents.values).sorted(by: {a, b in
            (a.isStreak ? a.date.countup() : a.date.countdown()) > (b.isStreak ? b.date.countup() : b.date.countdown())
        })
        
    }
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let timeEventsFRC: NSFetchedResultsController<TimeEventMO>
    
    private init(type: DataSourceType) {
        switch type {
        case .normal:
            let persistentController = PersistenceController()
            self.managedObjectContext = persistentController.viewContext
        case .preview:
            let persistentController = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentController.viewContext
            for i in 0..<10 {
                let newTimeEvent = TimeEventMO(context: managedObjectContext)
                newTimeEvent.id = UUID()
                newTimeEvent.name = "TimeEvent \(i)"
                newTimeEvent.date = Date().addingTimeInterval(10000)
                newTimeEvent.isStreak = i % 2 == 0
                newTimeEvent.color = "#FFFFFF"
            }
            try? self.managedObjectContext.save()
        case .testing:
            let persistentController = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentController.viewContext
        }
        
        let timeEventFR: NSFetchRequest<TimeEventMO> = TimeEventMO.fetchRequest()
        timeEventFR.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        timeEventsFRC = NSFetchedResultsController(fetchRequest: timeEventFR,
                                                   managedObjectContext: managedObjectContext,
                                                   sectionNameKeyPath: nil,
                                                   cacheName: nil)
        
        super.init()
        
        // Initial fetch to populate todos array
        timeEventsFRC.delegate = self
        try? timeEventsFRC.performFetch()
        if let newTimeEvents = timeEventsFRC.fetchedObjects {
            self.timeEvents = Dictionary(uniqueKeysWithValues: newTimeEvents.map({ ($0.id!, TimeEvent(timeEventMO: $0)) }))
        }
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataSource: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newTimeEvents = controller.fetchedObjects as? [TimeEventMO] {
            self.timeEvents = Dictionary(uniqueKeysWithValues: newTimeEvents.map({ ($0.id!, TimeEvent(timeEventMO: $0)) }))
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTimeEvents(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            timeEventsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            timeEventsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? timeEventsFRC.performFetch()
        if let newTimeEvents = timeEventsFRC.fetchedObjects {
            self.timeEvents = Dictionary(uniqueKeysWithValues: newTimeEvents.map({ ($0.id!, TimeEvent(timeEventMO: $0)) }))
        }
    }
    
    func resetFetch() {
        timeEventsFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        timeEventsFRC.fetchRequest.predicate = nil
        try? timeEventsFRC.performFetch()
        if let newTimeEvents = timeEventsFRC.fetchedObjects {
            self.timeEvents = Dictionary(uniqueKeysWithValues: newTimeEvents.map({ ($0.id!, TimeEvent(timeEventMO: $0)) }))
        }
    }
    
}

//MARK: - Todo Methods
extension TimeEvent {
    
    fileprivate init(timeEventMO: TimeEventMO) {
        self.id = timeEventMO.id ?? UUID()
        self.name = timeEventMO.name!
        self.date = timeEventMO.date ?? Date()
        self.isStreak = timeEventMO.isStreak
        self.color = timeEventMO.color ?? "#FFFFFF"
        self.isPinned = timeEventMO.isPinned
    }
}

extension DataSource {
    
    func updateAndSave(timeEvent: TimeEvent) {
        let predicate = NSPredicate(format: "id = %@", timeEvent.id as CVarArg)
        let result = fetchFirst(TimeEventMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let timeEventMO = managedObject {
                update(timeEventMO: timeEventMO, from: timeEvent)
            } else {
                createTimeEventMO(from: timeEvent)
            }
        case .failure(_):
            print("Couldn't fetch TimeEventMO to save")
        }
        saveData()
    }
    
    func delete(timeEvent: TimeEvent) {
        let predicate = NSPredicate(format: "id = %@", timeEvent.id as CVarArg)
        let result = fetchFirst(TimeEventMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let timeEventMO = managedObject {
                managedObjectContext.delete(timeEventMO)
            }
        case .failure(_):
            print("Couldn't fetch TimeEventMO to save")
        }
        saveData()
    }
    
    func getTimeEvent(with id: UUID) -> TimeEvent? {
        return timeEvents[id]
    }
    
    private func createTimeEventMO(from timeEvent: TimeEvent) {
        let timeEventMO = TimeEventMO(context: managedObjectContext)
        timeEventMO.id = timeEvent.id
        update(timeEventMO: timeEventMO, from: timeEvent)
    }
    
    private func update(timeEventMO: TimeEventMO, from timeEvent: TimeEvent) {
        timeEventMO.name = timeEvent.name
        timeEventMO.date = timeEvent.date
        timeEventMO.isStreak = timeEvent.isStreak
        timeEventMO.color = timeEvent.color
        timeEventMO.isPinned = timeEvent.isPinned
    }
    
    private func getTimeEventMO(from timeEvent: TimeEvent?) -> TimeEventMO? {
        guard let timeEvent = timeEvent else { return nil }
        let predicate = NSPredicate(format: "id = %@", timeEvent.id as CVarArg)
        let result = fetchFirst(TimeEventMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let timeEventMO = managedObject {
                return timeEventMO
            } else {
                return nil
            }
        case .failure(_):
            return nil
        }
        
    }
}
