//
//  SongView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct SongView: View {
    @StateObject var spotify = Spotify()
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    List {
                        NavigationLink(
                            "Playlists", destination: PlaylistsListView().environmentObject(spotify)
                        )
                        NavigationLink(
                            "Saved Albums", destination: SavedAlbumsGridView().environmentObject(spotify)
                        )
                        NavigationLink(
                            "Recently Played Tracks", destination: RecentlyPlayedView().environmentObject(spotify)
                        )
                    }
                }
                .navigationBarTitle(Text("My Music"))
                .navigationBarItems(leading:ClemsonLogoView())
            }.ignoresSafeArea()
        }
    }
}

struct SongView_Previews: PreviewProvider {
    
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        NavigationView {
            SongView()
                .environmentObject(spotify)
        }
    }
}
