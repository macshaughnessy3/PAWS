//
//  AccountView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @StateObject var spotify = Spotify()
    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    spotifyButton()
                    List {
                        Text("Support")
                        NavigationLink("Device", destination: BluetoothDeviceView())
                    }
                }
                .navigationBarTitle(Text("My Account"))
                .navigationBarItems(leading:ClemsonLogoView())
            }
            .ignoresSafeArea()
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
    struct spotifyButton: View {
        @EnvironmentObject var spotify: Spotify
        @Environment(\.colorScheme) var colorScheme
        var spotifyLogo: ImageName {
            colorScheme == .dark ? .spotifyLogoWhite
                    : .spotifyLogoBlack
        }
        
        var body: some View {
            Button(action: spotify.authorize) {
                HStack {
                    Text("Login with Spotify")
                    Spacer()
                    Image(spotifyLogo)
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }
            .accessibility(identifier: "Log in with Spotify Identifier")
            .buttonStyle(PlainButtonStyle())
            // Prevent the user from trying to login again
            // if a request to retrieve the access and refresh
            // tokens is currently in progress.
            .allowsHitTesting(!spotify.isRetrievingTokens)
            .padding(.bottom, 5)
        }
    }

    struct retrievingTokensView: View {
        @EnvironmentObject var spotify: Spotify

        var body: some View {
            VStack {
                if spotify.isRetrievingTokens {
                    HStack {
                        ProgressView()
                            .padding()
                        Text("Authenticating")
                    }
                }
            }
        }
    }
}
