//
//  ContentView.swift
//  PAWS
//
//  Created by macseansc3 on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SongView()
                .tabItem {
                Image(systemName: "music.note.list")
                Text("Music")
            }.tag(0)
            SongView()
                .tabItem {
                Image(systemName: "waveform")
                Text("Visulizer")
            }.tag(0)
            HomeView()
                .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }.tag(0)
            HomeView()
                .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(0)
            AccountView()
                .tabItem {
                Image(systemName: "person")
                Text("Account")
            }.tag(1)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear() {
            UITabBar.appearance().backgroundColor = .systemIndigo
            UITabBar.appearance().unselectedItemTintColor = .systemGray3
        }
        .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SongView: View {
    var body: some View {
        ZStack {
            Color(.purple)
            NavigationView {
                Form {
                    List {
                        Text("Hello World")
                        Text("Hello World")
                    }
                }
                .navigationBarTitle(Text("PAWS"))
            }.ignoresSafeArea()
        }
    }
}


struct HomeView: View {
    var body: some View {
        ZStack {
            Color(.purple)
            NavigationView {
                Form {
                    List {
                        Text("Hello World")
                        Text("Hello World")
                    }
                }
                .navigationBarTitle(Text("PAWS"))
            }
            .ignoresSafeArea()
        }
    }
}

struct AccountView: View {
    var body: some View {
        ZStack {
            Color(.purple)
            NavigationView {
                Form {
                    List {
                        Text("Hello World")
                        Text("Hello World")
                    }
                }
                .navigationBarTitle(Text("PAWS"))
            }.ignoresSafeArea()
        }
    }
}
