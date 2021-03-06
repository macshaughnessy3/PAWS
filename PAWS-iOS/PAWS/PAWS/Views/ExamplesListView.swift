//
//  ExamplesListView.swift
//  PAWS
//
//  Created by Molly Pabst on 10/5/21.
//

import SwiftUI

struct ExamplesListView: View {
    
    var body: some View {
        List {
            
            NavigationLink(
                "Search For Tracks", destination: SearchForTracksView()
            )
            
            // This is the location where you can add your own views to test out
            // your application. Each view receives an instance of `Spotify`
            // from the environment.
            
        }
        .listStyle(PlainListStyle())
        
    }
}

struct ExamplesListView_Previews: PreviewProvider {
    
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        NavigationView {
            ExamplesListView()
                .environmentObject(spotify)
        }
    }
}
