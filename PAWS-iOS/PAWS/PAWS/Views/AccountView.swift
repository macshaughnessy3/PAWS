//
//  AccountView.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import SwiftUI
import SpotifyWebAPI
import Combine

struct AccountView: View {
    @EnvironmentObject var spotify: Spotify
    
    @State private var alert: AlertItem? = nil

    @State private var cancellables: Set<AnyCancellable> = []

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    if !spotify.isAuthorized{
                        spotifyLoginButton()
                            .disabled(spotify.isAuthorized)
                            .onAppear(perform: onAppearLogin)
                        
                    } else{
                        spotifyLogoutButton()
                            .disabled(!spotify.isAuthorized)
                            .onAppear(perform: onAppearLogout)
                    }
                    List {
                        HStack{
                            Text("Support")
                            Spacer()
                            Image(systemName: "info.circle")
                        }
                        NavigationLink("Device", destination: BluetoothDeviceView())
                    }
                }
                .navigationBarTitle(Text("My Account"))
                .navigationBarItems(leading:ClemsonLogoView())
            }
            .ignoresSafeArea()
            .navigationViewStyle(StackNavigationViewStyle())
            .onOpenURL(perform: handleURL(_:))
        }
    }
    struct spotifyLoginButton: View {
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
    
    struct spotifyLogoutButton: View {
        @EnvironmentObject var spotify: Spotify
        @Environment(\.colorScheme) var colorScheme
        var spotifyLogo: ImageName {
            colorScheme == .dark ? .spotifyLogoWhite
                    : .spotifyLogoBlack
        }
        
        var body: some View {
            Button(action: spotify.api.authorizationManager.deauthorize) {
                HStack {
                    Text("Logout of Spotify")
                    Spacer()
                    Image(spotifyLogo)
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 20)
                }
            }
            .accessibility(identifier: "Log out of Spotify Identifier")
//            .buttonStyle(PlainButtonStyle())
//            // Prevent the user from trying to login again
//            // if a request to retrieve the access and refresh
//            // tokens is currently in progress.
            .allowsHitTesting(!spotify.isRetrievingTokens)
//            .padding(.bottom, 5)
        }
    }
    
    func onAppearLogin() {
        spotify.isAuthorized = false
        spotify.isRetrievingTokens = true
    }
    
    func onAppearLogout() {
        spotify.isAuthorized = true
        spotify.isRetrievingTokens = false
    }
    
    func handleURL(_ url: URL) {
        
        // **Always** validate URLs; they offer a potential attack vector into
        // your app.
        guard url.scheme == self.spotify.loginCallbackURL.scheme else {
            print("not handling URL: unexpected scheme: '\(url)'")
            self.alert = AlertItem(
                title: "Cannot Handle Redirect",
                message: "Unexpected URL"
            )
            return
        }
        
        print("received redirect from Spotify: '\(url)'")
        
        // This property is used to display an activity indicator in `LoginView`
        // indicating that the access and refresh tokens are being retrieved.
        spotify.isRetrievingTokens = true
        
        // Complete the authorization process by requesting the access and
        // refresh tokens.
        spotify.api.authorizationManager.requestAccessAndRefreshTokens(
            redirectURIWithQuery: url,
            // This value must be the same as the one used to create the
            // authorization URL. Otherwise, an error will be thrown.
            state: spotify.authorizationState
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            // Whether the request succeeded or not, we need to remove the
            // activity indicator.
            self.spotify.isRetrievingTokens = false
            
            /*
             After the access and refresh tokens are retrieved,
             `SpotifyAPI.authorizationManagerDidChange` will emit a signal,
             causing `Spotify.authorizationManagerDidChange()` to be called,
             which will dismiss the loginView if the app was successfully
             authorized by setting the @Published `Spotify.isAuthorized`
             property to `true`.

             The only thing we need to do here is handle the error and show it
             to the user if one was received.
             */
            if case .failure(let error) = completion {
                print("couldn't retrieve access and refresh tokens:\n\(error)")
                let alertTitle: String
                let alertMessage: String
                if let authError = error as? SpotifyAuthorizationError,
                   authError.accessWasDenied {
                    alertTitle = "You Denied The Authorization Request :("
                    alertMessage = ""
                }
                else {
                    alertTitle =
                        "Couldn't Authorization With Your Account"
                    alertMessage = error.localizedDescription
                }
                self.alert = AlertItem(
                    title: alertTitle, message: alertMessage
                )
            }
        })
        .store(in: &cancellables)
        
        // MARK: IMPORTANT: generate a new value for the state parameter after
        // MARK: each authorization request. This ensures an incoming redirect
        // MARK: from Spotify was the result of a request made by this app, and
        // MARK: and not an attacker.
        self.spotify.authorizationState = String.randomURLSafe(length: 128)
        
    }
}
