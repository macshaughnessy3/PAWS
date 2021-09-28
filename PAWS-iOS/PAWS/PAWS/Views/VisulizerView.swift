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
                        Text("Hello World")
                        Text("Hello World")
                    }
                }
                .navigationBarTitle(Text("PAWS"))
            }.ignoresSafeArea()
        }
    }
}
