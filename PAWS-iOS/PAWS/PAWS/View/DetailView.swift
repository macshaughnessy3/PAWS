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
//    let observer = NotificationCenter.default.addObserver(self, selector: #selector(self.appendRxDataToTextView(notification:)), name: NSNotification.Name(rawValue: "Notify"), object: nil)
    
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
                
//                List {
                    CharacteriticCells()
//                }
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
                    if bleManager.foundCharacteristics[j].uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")) {
                        if !username.isEmpty { // <1>
                            Text("Welcome \(username)!") // <2>
                        }
                        TextField("Username", text: $username)
                        Spacer()
                        Button(action: {
                            bleManager.foundPeripherals[0].peripheral.writeValue((username as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics[0].characteristic, type: CBCharacteristicWriteType.withResponse)
                        }) {
                            Text("Send")
                        }
                    } else {

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
                        }
                    }
                }.onReceive(pub){ obj in
                    print(obj.object!)
                    print(bleManager.foundCharacteristics[j].readValue)                             }
            }
        }
        
        func writeOutgoingValue(data: String){
          }
    }
}
