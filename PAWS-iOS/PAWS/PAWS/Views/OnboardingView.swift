//
//  OnboardingView.swift
//  
//
//  Created by Mac Shaughnessy on 11/2/21.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    @StateObject var spotify = Spotify()

    var body: some View {
        
        // #1
            VStack {
                Spacer(minLength: 150)
                TabView {
                    VStack {
                        Text("Connect to spotify")
//                        RootView().environmentObject(spotify)
                    }
                    VStack {
                        Text("Connect to the PAWS Speaker")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
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
                        }.foregroundColor(Color.orange)
                        .background(Color.gray)
//                        .listRowBackground(Color.orange)
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
                        Image(systemName: "wand.and.stars")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80, alignment: .center)
                        Text("Welcome To PAWS")
                            .font(Font.title2.bold().lowercaseSmallCaps())
                            .multilineTextAlignment(.center)
                        Spacer(minLength: 60)
                        Text("Go into bluetooth settings or use airplay to connect")
                        Spacer(minLength: 30)
                        Text("This app will control your visuals")
                        Spacer(minLength: 30)
                        Text("And finally 🥳...some...thing")
                        
                        // #2
                        OnboardingButton()
                    }
                }
                .tabViewStyle(.page)
            }
            .background(Color(.systemGray6))
            .foregroundColor(Color(.systemIndigo))
            .ignoresSafeArea(.all, edges: .all)
    }
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
