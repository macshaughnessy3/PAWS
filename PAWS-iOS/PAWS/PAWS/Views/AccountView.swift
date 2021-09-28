//
//  AccountView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct AccountView: View {
    var body: some View {
        ZStack {
            Color(.purple)
            NavigationView {
                Form {
                    List {
                        Text("My Services")
                        Text("Support")
                        Text("System")
                        Text("Device")
                    }
                }
                .navigationBarTitle(Text("My Account"))
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
