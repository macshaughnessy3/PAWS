//
//  BluetoothDeviceView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 10/7/21.
//

import Foundation
import SwiftUI
 
struct BluetoothDeviceView: View {
     
    var body: some View {
        NavigationView {
                ListView()
        }
        .navigationBarTitle(Text("Bluetooth Settings"))
        .ignoresSafeArea()
    }
}
