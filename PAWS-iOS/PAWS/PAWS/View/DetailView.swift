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
                    bleManager.UIButtonView(proxy: proxy, text: "Disconnect \(bleManager.connectedPeripheral.peripheral.name ?? "")")
                }
                
                Text(bleManager.isBlePower ? "" : "Bluetooth setting is OFF")
                    .padding(10)
                
                List {
//                    CharacteriticCells()
                }
            }
//            .navigationBarTitle(bleManager.connectedPeripheral.peripheral.name ?? "Connected")
            .navigationBarBackButtonHidden(true)
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
            VStack {
                if (bleManager.foundCharacteristics.first(where: { Characteristic in
                    return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                }) != nil) {
                    VStack {
                        if editingFlag { // <1>
                            Text("Sent: \(message)") // <2>
                        }
                        TextField("Send a message to your Speaker", text: $message)
                        Spacer()
                        Button(action: {
                            bleManager.connectedPeripheral.peripheral.writeValue((message as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                                return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                            })!.characteristic, type: CBCharacteristicWriteType.withResponse)
                            self.editingFlag = true
                        }) {
                            Text("Send")
                        }
                    }
                }
                if (bleManager.foundCharacteristics.first(where: { Characteristic in
                    return Characteristic.uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e"))
                }) != nil) {
                    VStack {
                        if AllIncomingMessages.count > 0 {
                            ForEach(0..<AllIncomingMessages.count, id: \.self) { j in
                                Text("Recieved Value: \(AllIncomingMessages.reversed()[j])")
                            }
                        }
                    }
                }
            }.onReceive(pub) { obj in
                IncomingMessage = obj.object as! String
                IncomingMessage.removeLast()
                AllIncomingMessages += [IncomingMessage]
            }
        }
        
        func writeOutgoingValue(data: String){
        }
    }
}
