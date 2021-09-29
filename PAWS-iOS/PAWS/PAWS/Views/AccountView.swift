//
//  AccountView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct AccountView: View {
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    List {
                        Text("My Services")
                        Text("Support")
                        Text("System")
                        Text("Device")
                    }
                }
                .navigationBarTitle(Text("My Account"))
                .navigationBarItems(leading:ClemsonLogoView())
            }.ignoresSafeArea()
        }
    }
}
