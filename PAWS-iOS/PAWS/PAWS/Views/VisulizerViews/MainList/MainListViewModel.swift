//
//  MainListViewModel.swift
//  SimpleTodo
//
//  Created by David B. on 28.11.20.
//
import Foundation
import SwiftUI

class MainListViewModel : ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var newTaskTitle : String = ""
    @Published var newModeColor : String = ""
    @Published var newModeColorR : CGFloat = 0
    @Published var newModeColorG : CGFloat = 0
    @Published var newModeColorB : CGFloat = 0
    @Published var newModeItem : Int = 0
    @Published var selectedIndex : Int = 0


    func addItem() {
        withAnimation {
            let newItem = Mode(context: self.viewContext)
            
            newItem.createdAt = Date()
            newItem.title = newTaskTitle
            newItem.newModeColorR = Double(newModeColorR)
            newItem.newModeColorG = Double(newModeColorG)
            newItem.newModeColorB = Double(newModeColorB)
            newItem.color = "\(newModeColorR*255)_\(newModeColorG*255)_\(newModeColorB*255)"
            newItem.mode = Int16(newModeItem+1)
            newItem.displayMode = Int16(selectedIndex)
            newItem.isSelected = false

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
