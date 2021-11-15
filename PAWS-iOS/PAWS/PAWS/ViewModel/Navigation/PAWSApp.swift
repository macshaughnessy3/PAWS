//
//  PAWSApp.swift
//  PAWS
//
//  Created by macseansc3 on 9/27/21.
//

import SwiftUI
import SpotifyWebAPI

@main
struct PAWSApp: App {
    @StateObject var spotify = Spotify()
    @StateObject var coreBluetoothViewModel = CoreBluetoothViewModel()
    let persistenceController = PersistenceController.shared

    init() {
        SpotifyAPILogHandler.bootstrap()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(coreBluetoothViewModel)
                .environmentObject(spotify)
        }
    }
}
