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
        @State private var IncomingMessage: String = ""
        @State var AllIncomingMessages = [""]
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
                        if AllIncomingMessages.count > 0 {
                            ForEach(0..<AllIncomingMessages.count, id: \.self) { j in
                                if j % 2 == 1 {
                                    Text("Recieved Value: \(AllIncomingMessages.reversed()[j])")
                                }
                            }
                        }
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
                }).onReceive(pub) { obj in
                    IncomingMessage = obj.object as! String
                    print("test \(IncomingMessage.removeLast())")
                    AllIncomingMessages += [IncomingMessage]
                }
            }
        }
        
        func writeOutgoingValue(data: String){
          }
    }
}
