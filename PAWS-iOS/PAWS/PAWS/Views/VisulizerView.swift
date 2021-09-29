//
//  VisulizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct VisulizerView: View {
    struct SelectableItem: Identifiable {
        let id = UUID().uuidString
        var name: String
    }

    var modes = [SelectableItem(name: "OFF")] + Array(0...5).map{SelectableItem(name: "Mode \($0)")}
    @State var selectedItem: SelectableItem?
    
    var body: some View {
        NavigationView {
            Form {
                SingleSelectionList(items: modes, selectedItem: $selectedItem) { (item) in
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

struct SelectionCell: View {

    let mode: String
    @Binding var selectedMode: String?

    var body: some View {
        HStack {
            Text(mode)
            Spacer()
            if mode == selectedMode {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
        .onTapGesture {
            self.selectedMode = self.mode
        }
    }
}
