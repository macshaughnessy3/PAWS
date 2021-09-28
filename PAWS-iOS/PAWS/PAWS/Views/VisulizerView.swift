//
//  VisulizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct VisulizerView: View {
    let mode = ["OFF", "Mode 1", "Mode 2", "Mode 3", "Mode 4", "Mode 5"]
    @State var selectedMode: String? = nil
    
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    ForEach(mode, id: \.self) { item in
                                    SelectionCell(mode: item, selectedMode: self.$selectedMode)
                                }
                }
                .navigationBarTitle(Text("My Visuals"))
                .navigationBarItems(leading:
                                HStack {
                                    Image("clemson-logo")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40, alignment: .center)
                                    .padding(UIScreen.main.bounds.size.width)
                                }
                        )
            }.ignoresSafeArea()
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
        }   .onTapGesture {
                self.selectedMode = self.mode
            }
    }
}
