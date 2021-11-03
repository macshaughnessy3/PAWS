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
            NavigationView {
                Form {
                    List {
                        Text("Favorites")
                        Text("History")
                        Text("Suggested?")
                    }
                }
                .navigationBarTitle(Text("Home"))
                .navigationBarItems(leading:ClemsonLogoView())
            }
        }
        .ignoresSafeArea()
    }
}
