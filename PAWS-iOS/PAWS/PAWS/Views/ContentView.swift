//
//  ContentView.swift
//  PAWS
//
//  Created by macseansc3 on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SongListViewModel
    @EnvironmentObject var spotify: Spotify
    
    var body: some View {
        TabView {
            SongView()
                .environmentObject(spotify)
                .tabItem {
                Image(systemName: "music.note.list")
                Text("Music")
            }.tag(0)
            VisualizerView()
                .tabItem {
                Image(systemName: "waveform")
                Text("Visualizer")
            }.tag(1)
            HomeView(viewModel: viewModel)
                .environmentObject(spotify)
                .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(2)
            SearchForTracksView()
                .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(3)
            AccountView()
                .tabItem {
                Image(systemName: "person")
                Text("Account")
            }.tag(4)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear() {
            UITabBar.appearance().backgroundColor = .systemIndigo
            UITabBar.appearance().unselectedItemTintColor = .systemGray3
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.systemIndigo]
        }
        .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    //static var previews: some View {
       // ContentView(viewModel: SongListViewModel())
    //}
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        NavigationView {
            ContentView(viewModel: SongListViewModel())
                .environmentObject(spotify)
        }
    }
}

