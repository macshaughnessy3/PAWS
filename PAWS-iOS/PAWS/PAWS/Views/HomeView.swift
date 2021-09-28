//
//  HomeView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: SongListViewModel
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    List {
                        Text("Favorites")
                        Text("History")
                        Text("Suggested?")
                    }
                }
                .navigationBarTitle(Text("Home"))
                .navigationBarItems(leading:
                                HStack {
                                    Image("clemson-logo")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40, alignment: .center)
                                    .padding(UIScreen.main.bounds.size.width)
                                }
                        )
            }
        }
        .ignoresSafeArea()
    }
}
