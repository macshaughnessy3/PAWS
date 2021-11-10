//
//  DetailView.swift

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
        @State private var message: String = ""
        @State var editingFlag = false

        var body: some View {
            ForEach(0..<bleManager.foundCharacteristics.count, id: \.self) { j in
                VStack {
                    if bleManager.foundCharacteristics[j].uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")) {
//                            HStack {
//                                Text("uuid: \(bleManager.foundCharacteristics[j].uuid.uuidString)")
//                                    .font(.system(size: 14))
//                                    .padding(.bottom, 2)
//                                Spacer()
//                            }
//
//                            HStack {
//                                Text("description: \(bleManager.foundCharacteristics[j].description)")
//                                    .font(.system(size: 14))
//                                    .padding(.bottom, 2)
//                                Spacer()
//                            }
                            HStack {
                                Text("Recieved Value: \(bleManager.foundCharacteristics[j].readValue)")
                                    .font(.system(size: 14))
                                    .padding(.top, 5)
                            }
//                        }
                    }
                    if bleManager.foundCharacteristics[j].uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")) {
                        if editingFlag { // <1>
                            Text("Sent: \(message)") // <2>
                        }
                        TextField("Send a message to your Speaker", text: $message)
                        Spacer()
                        Button(action: {
                            bleManager.connectedPeripheral.peripheral.writeValue((message as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics[0].characteristic, type: CBCharacteristicWriteType.withResponse)
                            self.editingFlag = true
                        }) {
                            Text("Send")
                        }
                    }
                }.onAppear(perform: {
                    print("readValue", bleManager.foundCharacteristics[j].readValue)
                }).onReceive(pub) { obj in
                    print("readValue", obj.object!)
                    print(bleManager.foundCharacteristics[j].readValue)
                }
            }
        }
        
        func writeOutgoingValue(data: String){
          }
    }
}
