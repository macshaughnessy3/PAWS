import Foundation
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @Environment(\.colorScheme) var colorScheme
    init(){
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemOrange
        UIPageControl.appearance().pageIndicatorTintColor = .systemIndigo
    }
    var body: some View {
        
        // #1
            VStack {
                Spacer(minLength: 150)
                TabView {
                    VStack {
                        Image("clemson-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .center)
                        Text("Welcome To PAWS")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Spacer(minLength: 10)
                        Group{
                            Text("Setup PAWS by following the next pages.")
                            Spacer()
                            Text("Connect to Spotify to contol music.")
                            Spacer()
                            Text("Connect to PAWS using Bluetooth LE")
                            Text("for initial pairing.")
                            Spacer()
                            Text("Connect to PAWS using Airplay or Bluetooth.")
                            Spacer()
                        }
                        Spacer(minLength: 200)
                    }
                    VStack {
                        Text("Connect to the Spotify")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Text("For easy music control connect to spotify")
                        Spacer(minLength: 20)
                        spotifyButton().foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        Spacer()
                    }
                    VStack {
                        Text("Connect to the PAWS Speaker")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Text("Setup and initialization for visulization")
                        List {
                            ForEach(0..<bleManager.foundPeripherals.count, id: \.self) { num in
                                if(bleManager.foundPeripherals[num].name != "NoName"){
                                    Button(action: {
                                        bleManager.connectPeripheral(bleManager.foundPeripherals[num])
                                    }) {
                                        HStack {
                                            Text("\(bleManager.foundPeripherals[num].name)")
                                            Spacer()
                                            Text("\(bleManager.foundPeripherals[num].rssi) dBm")
                                        }
                                    }
                                }
                            }
                        }
//                        .foregroundColor(Color.orange)
                        VStack {
                            Spacer()
                            Button(action: {
                                bleManager.isSearching ? bleManager.stopScan() : bleManager.startScan()
                            }) {
                                Text(bleManager.isSearching ? "Stop scanning" : "Start scanning")
                                    .padding()
                            }
                        }
                    }
                    VStack {
                        Image("clemson-logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .center)
                        Text("Welcome To PAWS")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Spacer(minLength: 60)
                        Group{
                            Text("The app will control visuals and spotify.")
                            Spacer(minLength: 30)
                            Text("Music can be played using other apps aswell")
                            Spacer(minLength: 30)
                            Text("Enjoy!")
                        }
                        OnboardingButton()
                    }
                }
                .tabViewStyle(.page)
            }
            .background(Color(.systemGray6))
            .foregroundColor(Color(.systemIndigo))
            .ignoresSafeArea(.all, edges: .all)
    }


    struct OnboardingButton: View {
        
        // #1
        @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true

        var body: some View {
            GeometryReader { proxy in
                LazyHStack {
                    Button(action: {
                        
                        // #2
                        needsAppOnboarding = false
                    }) {
                        Text("Finish Setup")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .font(Font.title2.bold().lowercaseSmallCaps())
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height/1.5)
            }
        }
    }

    struct spotifyButton: View {
        @EnvironmentObject var spotify: Spotify
        @Environment(\.colorScheme) var colorScheme
        let backgroundGradient = LinearGradient(
            gradient: Gradient(
                colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1903857588, green: 0.8321116255, blue: 0.4365008013, alpha: 1))]
            ),
            startPoint: .leading, endPoint: .trailing
        )
        var spotifyLogo: ImageName {
            colorScheme == .dark ? .spotifyLogoWhite
                    : .spotifyLogoBlack
        }
        
        var body: some View {
            Button(action: spotify.authorize) {
                HStack {
                    Image(spotifyLogo)
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    Text("Login with Spotify")
                        .font(.title)
                }
                .padding()
                .background(backgroundGradient)
                .clipShape(Capsule())
                .shadow(radius: 5)
                
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
