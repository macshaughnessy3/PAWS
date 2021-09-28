//
//  HomeView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color(.purple)
            NavigationView {
                Form {
                    List {
                        Text("Hello World")
                        Text("Hello World")
                    }
                }
                .navigationBarTitle(Text("PAWS"))
            }
            .ignoresSafeArea()
        }
    }
}
