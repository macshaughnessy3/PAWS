//
//  SongView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct SongView: View {
    var body: some View {
        ZStack {
        
            NavigationView {
                Form {
                    List {
                        Text("Placeholder")
                        
                    }
                }
                .navigationBarTitle(Text("My Music"))
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
            }.ignoresSafeArea()
        }
    }
}
