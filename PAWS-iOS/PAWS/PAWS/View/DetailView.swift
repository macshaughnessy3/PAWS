//
//  DetailView.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI
import CoreBluetooth

struct DetailView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Button(action: {
                    bleManager.disconnectPeripheral()
                    bleManager.stopScan()
                }) {
                    bleManager.UIButtonView(proxy: proxy, text: "Disconnect")
                }
                
                Text(bleManager.isBlePower ? "" : "Bluetooth setting is OFF")
                    .padding(10)
                
                List {
                    CharacteriticCells()
                }
                .navigationBarTitle("Connect result")
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    struct CharacteriticCells: View {
        @EnvironmentObject var bleManager: CoreBluetoothViewModel
        let pub = NotificationCenter.default.publisher(for: NSNotification.Name("Notify"))
        @State private var username: String = ""

        var body: some View {
            ForEach(0..<bleManager.foundCharacteristics.count, id: \.self) { j in
                VStack {
                    if bleManager.foundCharacteristics[j].uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")) {
//                        Button(action: {
//                            bleManager.connectedPeripheral.peripheral.readValue(for: bleManager.foundCharacteristics[1].characteristic)
//                        }){
                            HStack {
                                Text("uuid: \(bleManager.foundCharacteristics[j].uuid.uuidString)")
                                    .font(.system(size: 14))
                                    .padding(.bottom, 2)
                                Spacer()
                            }
                            
                            HStack {
                                Text("description: \(bleManager.foundCharacteristics[j].description)")
                                    .font(.system(size: 14))
                                    .padding(.bottom, 2)
                                Spacer()
                            }
                            HStack {
                                Text("value: \(bleManager.foundCharacteristics[j].readValue)")
                                    .font(.system(size: 14))
                                    .padding(.bottom, 2)
                                Spacer()
//                            }
                        }
                    }
                    if bleManager.foundCharacteristics[j].uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")) {
                        if !username.isEmpty { // <1>
                            Text("Welcome \(username)!") // <2>
                        }
                        TextField("Username", text: $username)
                        Spacer()
                        Button(action: {
                            bleManager.connectedPeripheral.peripheral.writeValue((username as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics[0].characteristic, type: CBCharacteristicWriteType.withResponse)
                        }) {
                            Text("Send")
                        }
                    }
                }.onAppear(perform: {
//                    print(bleManager.foundCharacteristics[j].readValue)
                }).onReceive(pub) { obj in
                    print(obj.object!)
                    print(bleManager.foundCharacteristics[j].readValue)
                }
            }
        }
        
        func writeOutgoingValue(data: String){
          }
    }
}
