import Foundation
import SwiftUI
import SpotifyWebAPI
import Combine

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var spotify: Spotify
    
    @State private var alert: AlertItem? = nil

    @State private var cancellables: Set<AnyCancellable> = []
    @State private var tabSelection = 1
    
    init(){
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemOrange
        UIPageControl.appearance().pageIndicatorTintColor = .systemIndigo
    }
    
    
    var body: some View {
        // #1
            VStack {
                Spacer(minLength: 150)
                TabView(selection: $tabSelection) {
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
                    .tag(1)
                    VStack {
                        Text("Connect to the Spotify")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Text("For easy music control connect to spotify")
                        Spacer(minLength: 20)
                        spotifyButton(tabSelection: $tabSelection).foregroundColor(Color(colorScheme == .dark ? .white : .black))
                        Spacer()
                    }
                    .onOpenURL(perform: handleURL(_:))
                    .tag(2)
                    BluetoothOnboardingView(tabSelection: $tabSelection)
                        .tabItem{
                            //Text("Tab 1")
                        }
                        .tag(3)
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
                    .tag(4)
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
    
    struct BluetoothOnboardingView: View{
        @Binding var tabSelection: Int
        @EnvironmentObject var bleManager: CoreBluetoothViewModel

        var body: some View{
            VStack {
                Text("Connect to the PAWS Speaker")
                    .font(Font.title2.bold().lowercaseSmallCaps())
                    .multilineTextAlignment(.center)
                Text("Setup and initialization for visualization")
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
                VStack {
                    Spacer()
                    Button(action: {
                        bleManager.isSearching ? bleManager.stopScan() : bleManager.startScan()
                    }) {
                        Text(bleManager.isSearching ? "Stop scanning" : "Start scanning")
                            .padding()
                    }
                }
            }.onChange(of: bleManager.isConnected) { _ in
                withAnimation {
                    self.tabSelection = 4
                }
            }
        }
    }

    struct spotifyButton: View {
        @Binding var tabSelection: Int
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
            Button(action: {spotify.authorize(); self.tabSelection = 3}) {
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

struct OnboardingView_Previews: PreviewProvider {
    
    static let spotify = Spotify()
    
    static var previews: some View {
        OnboardingView()
            .environmentObject(spotify)
            .onAppear(perform: onAppear)
    }
    
    static func onAppear() {
        spotify.isAuthorized = false
        spotify.isRetrievingTokens = true
    }
    
}
