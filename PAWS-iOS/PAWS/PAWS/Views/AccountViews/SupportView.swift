//
//  SupportView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/15/21.
//

import Foundation
import SwiftUI


struct SupportView: View {
    @Environment(\.colorScheme) var colorScheme
    var githubLogo: ImageName {
        colorScheme == .dark ? .githubLogoWhite
                : .githubLogoBlack
    }
    var body: some View {
        VStack {
            Image("clemson-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
            Text("Welcome To PAWS Support")
                .font(Font.title2.bold().lowercaseSmallCaps())
                .multilineTextAlignment(.center)
            Spacer(minLength: 60)
            Group{
                Text("Having trouble sending commands?")
                Text("Make sure bluetooth is connected in the app.")
                Spacer(minLength: 30)
                Text("Music not playing?")
                Text("Ensure bluetooth is connected in the iOS")
                Text("settings or over airplay.")
                Spacer(minLength: 30)
                Link(destination: URL(string: "https://github.com/macshaughnessy3/PAWS")!, label: {
                    Image(githubLogo)
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                })
                Spacer(minLength: 30)
            }
        }
    }
}
