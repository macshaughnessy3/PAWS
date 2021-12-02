//
//  SongListItemView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct SongItemView: View {
  @ObservedObject var song: SongViewModel
  
  var body: some View {
    HStack {
      ArtworkView(image: song.artwork)
        .padding(.trailing)
      VStack(alignment: .leading) {
        Text(song.trackName)
        Text(song.artistName)
          .font(.footnote)
          .foregroundColor(.gray)
      }
    }
    .padding()
  }
}

struct ArtworkView: View {
  let image: Image?
  
  var body: some View {
    ZStack {
      if image != nil {
        image
      } else {
        Color(.systemIndigo)
        Image(systemName: "music.note")
          .font(.largeTitle)
          .foregroundColor(.white)
      }
    }
    .frame(width: 50, height: 50)
    .shadow(radius: 5)
    .padding(.trailing, 5)
  }
}
