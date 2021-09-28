//
//  SearchView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SongListViewModel
    
    var body: some View {
        VStack {
          SearchBar(searchTerm: $viewModel.searchTerm)
          if viewModel.songs.isEmpty {
            EmptyStateView()
          } else {
            List(viewModel.songs) { song in
              SongItemView(song: song)
            }
            .listStyle(PlainListStyle())
          }
    }
}

    struct EmptyStateView: View {
      var body: some View {
        VStack {
          Spacer()
          Image(systemName: "music.note")
            .font(.system(size: 85))
            .padding(.bottom)
          Text("Start searching for music...")
            .font(.title)
          Spacer()
        }
        .padding()
        .foregroundColor(Color(.systemIndigo))
      }
    }

    struct SearchBar: UIViewRepresentable {
      typealias UIViewType = UISearchBar
      
      @Binding var searchTerm: String

      func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Type a song, artist, or album name..."
        return searchBar
      }
      
      func updateUIView(_ uiView: UISearchBar, context: Context) {
      }
      
      func makeCoordinator() -> SearchBarCoordinator {
        return SearchBarCoordinator(searchTerm: $searchTerm)
      }
      
      class SearchBarCoordinator: NSObject, UISearchBarDelegate {
        @Binding var searchTerm: String
        
        init(searchTerm: Binding<String>) {
          self._searchTerm = searchTerm
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchTerm = searchBar.text ?? ""
          UIApplication.shared.windows.first { $0.isKeyWindow }?.endEditing(true)
        }
      }
    }
}
