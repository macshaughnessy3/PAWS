//
//  MainListViewModel.swift
//  SimpleTodo
//
//  Created by David B. on 28.11.20.
//

import SwiftUI

class MainListViewModel : ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var newTaskTitle : String = ""
    
    func addItem() {
        withAnimation {
            let newItem = Mode(context: self.viewContext)
            
            newItem.createdAt = Date()
            newItem.color = ""
            newItem.message = ""
            newItem.modeDescription = ""
            newItem.displayMode = 0

            do {
                try self.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        //Reset TextField String
        self.newTaskTitle = ""
    }
}
