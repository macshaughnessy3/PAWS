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

    init() {
        SpotifyAPILogHandler.bootstrap()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: SongListViewModel()).environmentObject(spotify)
            //RootView()
                //.environmentObject(spotify)
        }
    }
}
