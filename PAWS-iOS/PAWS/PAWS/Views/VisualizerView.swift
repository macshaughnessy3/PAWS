//
//  VisualizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI
import CocoaMQTT
let mqttClient = CocoaMQTT(clientID: "App", host: "100.64.12.87", port: 1883)
var connected:Bool=false;

struct SelectableItem {
    var name: String
    var mode: Int
}
extension SelectableItem: Identifiable {
    var id: Int { return mode }
}

struct VisualizerView: View {
    var modes = [SelectableItem(name: "OFF", mode: -1)] + Array(0...5).map{SelectableItem(name: "Mode \($0)", mode: $0)}
    @State var selectedItem: SelectableItem?

    init() {
        mqttClient.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
//        mqttClient.keepAlive = 15
        connected = mqttClient.connect()
        if connected {
            print("MQTT Connected")
        } else { 
            print("MQTT was not connected")
        }
    }

    var body: some View {
        NavigationView {
            Form {
                SingleSelectionList(items: modes, selectedItem: $selectedItem) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("My Visuals"))
            .navigationBarItems(leading:ClemsonLogoView())
        }.ignoresSafeArea()
    }
}

struct SingleSelectionList<Item: Identifiable, Content: View>: View {
    var items: [Item]
    @Binding var selectedItem: Item?
    var rowContent: (Item) -> Content
    var body: some View {
        List(items) { item in
            rowContent(item)
                .modifier(CheckmarkModifier(checked: item.id == self.selectedItem?.id))
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selectedItem = item
                    mqttClient.publish("raspberrypi/mode", withString: "\(item.id)")
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
