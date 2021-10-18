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
                        Text("My Services")
                        Text("Support")
                        Text("System")
//                        NavigationLink("Device", destination: BluetoothDeviceView())
                        Text("Device")
                    }
                }
                .navigationBarTitle(Text("My Account"))
                .navigationBarItems(leading:ClemsonLogoView())
            }.ignoresSafeArea()
        }
    }
}
