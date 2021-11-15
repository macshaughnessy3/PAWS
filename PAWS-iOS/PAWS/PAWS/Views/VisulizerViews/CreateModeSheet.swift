//
//  CreateModeView.swift
//  PAWS
//
//  Created by macseansc3 on 11/10/21.
//

import Foundation
import SwiftUI

struct CreateModeSheet: View {
    @ObservedObject var viewModel = MainListViewModel()
    @State var number : Int = 0
    private var modeArray = ["Fast FFT", "Slow FFT", "Time", "Text", "Rainbow"]
    @State var rgbColour = RGB(r: 1, g: 1, b: 1)
    @State var brightness: CGFloat = 1
    @State var editingFlag = false

    var body: some View {
        List() {
            Section(header: Text("Name mode:")) {
                TextField("Mode Name", text: $viewModel.newTaskTitle,
                 onCommit: {print("New task title entered. \(viewModel.newTaskTitle)")})
            }
            
            Section(header: Text("Select visualizer display mode:")) {
                Picker(selection: $viewModel.selectedIndex, label: Text("Select visualizer display mode")) {
                    ForEach(0 ..< modeArray.count) {
                        Text(self.modeArray[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            if viewModel.selectedIndex != 4 {
                Section(header: Text("Pick a Color to display:")) {
                    ColourWheel(radius: 300, rgbColour: $rgbColour, brightness: $brightness).foregroundColor(Color(.displayP3, red: 0, green: 0, blue: 0)).listRowBackground(Color(.displayP3, red: rgbColour.r, green: rgbColour.g, blue: rgbColour.b))
                }
            }
            saveView(newTaskTitle: viewModel.newTaskTitle, newModeColorR: rgbColour.r, newModeColorG: rgbColour.g, newModeColorB: rgbColour.b, selectedIndex: viewModel.selectedIndex)
        }
    }
}

struct saveView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MainListViewModel()
    @FetchRequest(entity: Mode.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Mode.createdAt, ascending: false)]) var modeItems : FetchedResults<Mode>
    let newTaskTitle: String
//    let newModeColor: String
    let newModeColorR: CGFloat
    let newModeColorG: CGFloat
    let newModeColorB: CGFloat
    let selectedIndex: Int

    var body: some View {
        Button("Save Mode") {
            presentationMode.wrappedValue.dismiss()
            viewModel.newTaskTitle = newTaskTitle
            viewModel.newModeColorR = newModeColorR
            viewModel.newModeColorG = newModeColorG
            viewModel.newModeColorB = newModeColorB
            viewModel.newModeItem = modeItems.count+1
            viewModel.selectedIndex = selectedIndex
            viewModel.addItem()
        }
    }
}
