//
//  ContentView.swift
//  PAWS
//
//  Created by macseansc3 on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SongListViewModel
    
    var body: some View {
        TabView {
            SongView()
                .tabItem {
                Image(systemName: "music.note.list")
                Text("Music")
            }.tag(0)
            VisulizerView()
                .tabItem {
                Image(systemName: "waveform")
                Text("Visulizer")
            }.tag(1)
            HomeView(viewModel: viewModel)
                .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(2)
            SearchView(viewModel: viewModel)
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
    static var previews: some View {
        ContentView(viewModel: SongListViewModel())
    }
}

