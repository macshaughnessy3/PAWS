//
//  ClemsonLogoView.swift
//  PAWS
//
//  Created by macseansc3 on 9/28/21.
//

import Foundation
import SwiftUI
import CoreBluetooth
import CoreData


struct ClemsonLogoView: View {
    @EnvironmentObject var bleManager: CoreBluetoothViewModel

    var body: some View {
        HStack {
            Image("clemson-logo")
                .resizable()
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
                .onTapGesture {
                    if self.bleManager.isConnected {
                        self.bleManager.connectedPeripheral.peripheral.writeValue(("255_255_255_5_GoTigers" as NSString).data(using: String.Encoding.utf8.rawValue)!, for:  bleManager.foundCharacteristics.first(where: { Characteristic in
                            return Characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e"))
                        })!.characteristic, type: CBCharacteristicWriteType.withResponse)
                }
            }
        }
    }
}
