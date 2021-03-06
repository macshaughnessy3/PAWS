//
//  ContentView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/27/21.
//

import SwiftUI

struct ContentView: View {
    @State private var appSetupState = "App NOT setup âšī¸"
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    var body: some View {
        mainView.onAppear {   
            if !needsAppOnboarding {
                // Scenario #3: User has completed app onboarding
                appSetupState = "App setup đ"
            }
        }
    }
}

extension ContentView {

    private var mainView: some View {
            VStack {
                Button(action: {needsAppOnboarding = true}){}
                    .sheet(isPresented:$needsAppOnboarding) {
                        // Scenario #1: User has NOT completed app onboarding
                        OnboardingView().environmentObject(CoreBluetoothViewModel())
                    }
                    .onChange(of: needsAppOnboarding) { needsAppOnboarding in

                if !needsAppOnboarding {

                // Scenario #2: User has completed app onboarding during current app launch
                    appSetupState = "App setup đ"
                }
            }
            TabView {
                SongView()
                    .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Music")
                }.tag(0)
                VisualizerView()
                    .tabItem {
                    Image(systemName: "waveform")
                    Text("Visulizer")
                }.tag(1)
                SearchForTracksView()
                    .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.tag(2)
                AccountView()
                    .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }.tag(3)
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
}

struct ContentView_Previews: PreviewProvider {
    // static var previews: some View {
    //    ContentView(viewModel: SongListViewModel())
    // }
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        NavigationView {
            ContentView().environmentObject(spotify)
        }
    }
}

