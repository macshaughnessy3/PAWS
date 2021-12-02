//
//  MainList.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/10/21.
//

import SwiftUI

struct MainList: View {
    @Environment(\.managedObjectContext) var
     managedObjectContext
    
    @ObservedObject var viewModel = MainListViewModel()
    
    struct Layout {
        static let cellRowHeight: CGFloat = 50
    }
    
    @FetchRequest(entity: Mode.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Mode.createdAt, ascending: false)]) var taskItems : FetchedResults<Mode>

    @State var newTaskTitle : String = ""

    var sampleTasks = ["Task One" , "Task Two", "Task Three"]
    
    var body: some View {
        List() {
            if (!taskItems.isEmpty)
            {
                Section {
                    ForEach(taskItems, id:\.self) { task in
                        NavigationLink(destination: TaskDetailView(task: task))
                        {
                            HStack {
                                Text(task.title)
                                Spacer()
                                Button(action: {
                                    //action
                                })
                                {
                                    Image(systemName: "circle")
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTask)
                    .frame(height: Layout.cellRowHeight)
                }
            }

            Section {
                HStack {
                    TextField("Add task...", text: $viewModel.newTaskTitle,
                     onCommit: {print("New task title entered.")})
                    
                    Button(action: {
                        viewModel.addItem()
                    })
                    {
                        Image(systemName: "plus")
                    }
                }.frame(height: Layout.cellRowHeight)
            }
        }.listStyle(GroupedListStyle())
        .toolbar {
            EditButton()
        }
    }
    private func deleteTask(at offsets: IndexSet) {
        withAnimation {
            offsets.map { taskItems[$0] }.forEach(managedObjectContext.delete)

            do {
                try managedObjectContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct MainList_Previews: PreviewProvider {
    static var previews: some View {
        MainList()
    }
}
