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

struct VisualizerView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel = MainListViewModel()
    
    
    @FetchRequest(entity: Mode.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Mode.createdAt, ascending: false)]) var modeItems : FetchedResults<Mode>

    @State var newTaskTitle : String = ""
    @State var selectedItem: Mode?
    @State var showCreateModeSheet = false

    var body: some View {
        NavigationView {
            Form {
                ForEach(modeItems) { item in
                    NavigationLink(destination: TaskDetailView(task: item)) {
                        HStack {
                            Text(item.title)
                            Spacer()
                        }
                        .modifier(CheckmarkModifier(checked: item.id == self.selectedItem?.id && bleManager.isConnected))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedItem = item
                            for mode in modeItems {
                                mode.isSelected = false
                            }
                            item.isSelected = true
                            print("\(self.selectedItem?.mode ?? 0)")
                            if self.bleManager.isConnected {
                                self.bleManager.connectedPeripheral.peripheral.writeValue(("\(item.color)_\(item.displayMode)_\(item.message)" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                                    return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                                })!.characteristic, type: CBCharacteristicWriteType.withResponse)
                            }
                        }
                    }
                }.onDelete(perform: deleteTask)
            }
            .navigationBarTitle(Text("My Visuals"))
            .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                ClemsonLogoView()
                            }
                        }
                    }
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
            }
        }.ignoresSafeArea()
    }

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
