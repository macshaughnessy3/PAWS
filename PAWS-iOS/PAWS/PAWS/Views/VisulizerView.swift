//
//  VisulizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI
import CocoaMQTT
let mqttClient = CocoaMQTT(clientID: "App", host: "172.22.37.4", port: 1883)

struct SelectableItem: Identifiable {
    let id = UUID().uuidString
    let name: String
    let mode: Int
}

struct VisulizerView: View {
    var modes = [SelectableItem(name: "OFF", mode: -1)] + Array(0...5).map{SelectableItem(name: "Mode \($0)", mode: $0)}
    @State var selectedItem: SelectableItem?
    
    init() {
        _ = mqttClient.connect()
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
                    mqttClient.publish("raspberrypi/mode", withString: "\(item)")
                    print(item)
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
