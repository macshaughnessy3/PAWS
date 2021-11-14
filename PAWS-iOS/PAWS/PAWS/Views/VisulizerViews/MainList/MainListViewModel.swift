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
    @Published var newModeColor : String = ""
    @Published var newModeItem : Int = 0
    @Published var selectedIndex : Int = 0


    func addItem() {
        withAnimation {
            let newItem = Mode(context: self.viewContext)
            
            newItem.createdAt = Date()
            newItem.title = newTaskTitle
            newItem.color = newModeColor
            newItem.mode = Int16(newModeItem+1)
            newItem.displayMode = Int16(selectedIndex)

            do {
                try self.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        //Reset TextField String
//        self.newTaskTitle = ""
    }
}
