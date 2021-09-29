//
//  ClemsonLogoView.swift
//  PAWS
//
//  Created by macseansc3 on 9/28/21.
//

import Foundation
import SwiftUI

struct ClemsonLogoView: View {
    var body: some View {
        HStack {
            Image("clemson-logo")
                .resizable()
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
            .padding(UIScreen.main.bounds.size.width)
        }
    }
}
