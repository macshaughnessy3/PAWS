//
//  PAWSApp.swift
//  PAWS
//
//  Created by macseansc3 on 9/27/21.
//

import SwiftUI

@main
struct PAWSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SongListViewModel()).environmentObject(CoreBluetoothViewModel())
        }
    }
}
