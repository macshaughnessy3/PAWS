//
//  Persistence.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/10/21.
//

import Foundation

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Mode(context: viewContext)
            newItem.createdAt = Date()
            newItem.title = "Mode \(i)"
            newItem.color = "255_255_255"
            newItem.message = "Test"
            newItem.mode = 1
            newItem.displayMode = Int16(i)
            newItem.modeDescription = "This is Mode \(i), displaying \(newItem.mode) (name) with color \(newItem.color)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "VisualizerMode")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
