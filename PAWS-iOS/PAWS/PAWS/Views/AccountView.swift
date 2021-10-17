//
//  AccountView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @StateObject var spotify = Spotify()
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    List {
                        RootView().environmentObject(spotify)
                    }
                }
                .navigationBarTitle(Text("My Account"))
                .navigationBarItems(leading:ClemsonLogoView())
            }.ignoresSafeArea()
        }
    }
}
