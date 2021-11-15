//
//  ListView.swift

import SwiftUI

struct ListView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel

    var body: some View {
        ZStack {
            bleManager.navigationToDetailView(isDetailViewLinkActive: $bleManager.isConnected)
            
            GeometryReader { proxy in
                VStack {
                    if !bleManager.isSearching {
                        Button(action: {
                            if bleManager.isSearching {
                                bleManager.stopScan()
                            } else {
                                bleManager.startScan()
                            }
                        }) {
                            bleManager.UIButtonView(proxy: proxy,
                                                    text: bleManager.isSearching ? "Stop scanning" : "Start scanning")
                        }
                        
                        Text(bleManager.isBlePower ? "" : "Bluetooth setting is OFF")
                            .padding(10)
                        
                        List {
                            PeripheralCells()
                        }
                        
                        
                    } else {
                        //first stack
                        Color.gray.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                        ZStack {
                            VStack {
                                ProgressView()
                            }
                            VStack {
                                Spacer()
                                Button(action: {
                                    bleManager.stopScan()
                                }) {
                                    Text("Stop scanning")
                                        .padding()
                                }
                            }
                        }
                        .frame(width: proxy.size.width / 2,
                               height: proxy.size.width / 2,
                               alignment: .center)
                        .background(Color.gray.opacity(0.5))
                    }
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
    
    struct PeripheralCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        @State private var loading = false

        var body: some View {
            ForEach(0..<bleManager.foundPeripherals.count, id: \.self) { num in
                if(bleManager.foundPeripherals[num].name != "NoName"){
                    Button(action: {
                        bleManager.connectPeripheral(bleManager.foundPeripherals[num])
                        loading = true
                    }) {
                        HStack {
                            Text("\(bleManager.foundPeripherals[num].name)")
                            Spacer()
                            if !loading { Text("\(bleManager.foundPeripherals[num].rssi) dBm") }
                            else {
                                ProgressView()
                            }
                        }
                    }
                }
            }.onChange(of: bleManager.isConnected) { _ in
                withAnimation {
                    self.loading = false
                }
            }
        }
    }
}
