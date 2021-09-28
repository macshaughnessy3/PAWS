//
//  VisulizerView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct VisulizerView: View {
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    List {
                        Text("Mode 1")
                        Text("Mode 2")
                        Text("Mode 3")
                        Text("Mode 4")
                        Text("Mode 5")
                        Text("Mode 6")
                        Text("Mode 7")
                        Text("Mode 8")
                        Text("Mode 9")
                        Text("Mode 10")
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
