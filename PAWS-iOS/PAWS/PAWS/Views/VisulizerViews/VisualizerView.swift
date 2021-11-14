//
//  VisualizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI
import CoreBluetooth
import CoreData

//class SelectableItem: Identifiable {
//    var id = UUID()
//    var name: String
//    var mode: Int
//}

struct VisualizerView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = MainListViewModel()
    
    
    @FetchRequest(entity: Mode.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Mode.createdAt, ascending: false)]) var modeItems : FetchedResults<Mode>

    @State var newTaskTitle : String = ""
//    var modes = [SelectableItem(name: "OFF", mode: -1)] + Array(0...5).map{SelectableItem(name: "Mode \($0)", mode: $0)}
    @State var selectedItem: Mode?
    @State var showCreateModeSheet = false

    var body: some View {
        NavigationView {
            Form {
                ForEach(modeItems) { item in
                        HStack {
                            Text(item.id)
                            Spacer()
                        }
                        .modifier(CheckmarkModifier(checked: item.id == self.selectedItem?.id))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.selectedItem = item
                                print("\(self.selectedItem?.mode ?? 0)")
                                if self.bleManager.isConnected {
                                    self.bleManager.connectedPeripheral.peripheral.writeValue(("\(item.mode)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                                        return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                                    })!.characteristic, type: CBCharacteristicWriteType.withResponse)
             //                    bleManager.connectedPeripheral.peripheral.writeValue(("\(self.selectedItem?.mode ?? 0)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  self.bleManager.foundCharacteristics[0].characteristic, type: CBCharacteristicWriteType.withResponse)
                                }
                            }
                     }.onDelete(perform: deleteTask)

//                Section {
//                    HStack {
//                        TextField("Add task...", text: $viewModel.newTaskTitle,
//                         onCommit: {print("New task title entered.")})
//
//                        Button(action: {
//                            viewModel.addItem()
//                        })
//                        {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
//                 }
//                SingleSelectionList(items: [modeItems], selectedItem: $selectedItem) { (item : Mode) in
//                    HStack {
//                        Text(item.title)
//                        Spacer()
//                    }
//                }
            }
            .navigationBarTitle(Text("My Visuals"))
            .navigationBarItems(leading:ClemsonLogoView())
            .listStyle(PlainListStyle())
            .navigationTitle("My Orders")
            .navigationBarItems(trailing: Button(action: {
                showCreateModeSheet = true
            }, label: {
                Image(systemName: "plus.circle")
                    .imageScale(.large)
            }))
            .sheet(isPresented: $showCreateModeSheet) {
                CreateModeSheet()
//                TaskDetailView(task: self.selectedItem!).environment(\.managedObjectContext, self.viewContext)
            }
        }.ignoresSafeArea()
    }
    
//    var body: some View {
//        List() {
//            if (!taskItems.isEmpty)
//            {
//                Section {
//                    ForEach(taskItems, id:\.self) { task in
//                        NavigationLink(destination: TaskDetailView(task: task))
//                        {
//                            HStack {
//                                Text(task.title)
//                                Spacer()
//                                Button(action: {
//                                    //action
//                                })
//                                {
//                                    Image(systemName: "circle")
//                                        .imageScale(.large)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                    .onDelete(perform: deleteTask)
//                    .frame(height: Layout.cellRowHeight)
//                }
//            }
//        }
//
//            // Section {
//            //     HStack {
//            //         TextField("Add task...", text: $viewModel.newTaskTitle,
//            //          onCommit: {print("New task title entered.")})
//
//            //         Button(action: {
//            //             viewModel.addItem()
//            //         })
//            //         {
//            //             Image(systemName: "plus")
//            //         }
//            //     }.frame(height: Layout.cellRowHeight)
//            // }
//        // }.listStyle(GroupedListStyle())
//        // .toolbar {
//        //     EditButton()
////         }
//    }

//    struct SingleSelectionList<Item: Identifiable, Content: View>: View {
//       @EnvironmentObject var bleManager: CoreBluetoothViewModel
//
//       var items: [Item]
//       @Binding var selectedItem: SelectableItem?
//       var rowContent: (Item) -> Content
//       var body: some View {
//           List(items) { item in
//               rowContent(item)
//                   .modifier(CheckmarkModifier(checked: item.id as? UUID == self.selectedItem?.id))
//                   .contentShape(Rectangle())
//                   .onTapGesture {
//                       self.selectedItem = item as? SelectableItem
//                       print("\(self.selectedItem?.mode ?? 0)")
//                       self.bleManager.connectedPeripheral.peripheral.writeValue(("\(self.selectedItem?.mode ?? 0)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
//                           return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
//                       })!.characteristic, type: CBCharacteristicWriteType.withResponse)
////                    bleManager.connectedPeripheral.peripheral.writeValue(("\(self.selectedItem?.mode ?? 0)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  self.bleManager.foundCharacteristics[0].characteristic, type: CBCharacteristicWriteType.withResponse)
//               }
//            }
//        }
//    }

    private func deleteTask(at offsets: IndexSet) {
        withAnimation {
            offsets.map { modeItems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CheckmarkModifier: ViewModifier {
    var checked: Bool = false
    func body(content: Content) -> some View {
        Group {
            if checked {
                ZStack(alignment: .trailing) {
                    content
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                        .shadow(radius: 1)
                }
            } else {
                content
            }
        }
    }
}
































////
////  VisualizerView.swift
////  PAWS
////
////  Created by Mac Shaughnessy on 9/28/21.
////
//
//import Foundation
//import SwiftUI
//import CocoaMQTT
//let mqttClient = CocoaMQTT(clientID: "App", host: "10.191.106.215", port: 1883)
//var connected:Bool=false;
//
//struct SelectableItem {
//    var name: String
//    var mode: Int
//}
//extension SelectableItem: Identifiable {
//    var id: Int { return mode }
//}
//
//struct VisualizerView: View {
//    var modes = [SelectableItem(name: "OFF", mode: -1)] + Array(0...5).map{SelectableItem(name: "Mode \($0)", mode: $0)}
//    @State var selectedItem: SelectableItem?
//
//    init() {
//        mqttClient.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
////        mqttClient.keepAlive = 15
//        connected = mqttClient.connect()
//        if connected {
//            print("MQTT Connected")
//        } else {
//            print("MQTT was not connected")
//        }
//    }
//
//    var body: some View {
//        NavigationView {
//            Form {
//                SingleSelectionList(items: modes, selectedItem: $selectedItem) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                    }
//                }
//            }
//            .navigationBarTitle(Text("My Visuals"))
//            .navigationBarItems(leading:ClemsonLogoView())
//        }.ignoresSafeArea()
//    }
//}
//
//struct SingleSelectionList<Item: Identifiable, Content: View>: View {
//    var items: [Item]
//    @Binding var selectedItem: Item?
//    var rowContent: (Item) -> Content
//    var body: some View {
//        List(items) { item in
//            rowContent(item)
//                .modifier(CheckmarkModifier(checked: item.id == self.selectedItem?.id))
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    self.selectedItem = item
//                    mqttClient.publish("raspberrypi/mode", withString: "\(item.id)")
//                }
//        }
//    }
//}
//
//struct CheckmarkModifier: ViewModifier {
//    var checked: Bool = false
//    func body(content: Content) -> some View {
//        Group {
//            if checked {
//                ZStack(alignment: .trailing) {
//                    content
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.accentColor)
//                        .shadow(radius: 1)
//                }
//            } else {
//                content
//            }
//        }
//    }
//}
