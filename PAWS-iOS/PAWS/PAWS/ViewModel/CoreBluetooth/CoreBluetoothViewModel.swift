//
//  CoreBluetoothViewModel.swift
//  SwiftUI-BLE-Project
//
//  Created by kazuya ito on 2021/02/02.
//

import SwiftUI
import CoreBluetooth

class CoreBluetoothViewModel: NSObject, ObservableObject, CBPeripheralProtocolDelegate, CBCentralManagerProtocolDelegate {
    
    @Published var isBlePower: Bool = false
    @Published var isSearching: Bool = false
    @Published var isConnected: Bool = false
    
    @Published var foundPeripherals: [Peripheral] = []
    @Published var foundServices: [Service] = []
    @Published var foundCharacteristics: [Characteristic] = []
    
    private var centralManager: CBCentralManagerProtocol!
    @Published var connectedPeripheral: Peripheral!
    
    private let serviceUUID: CBUUID = CBUUID()
    
    override init() {
        super.init()
        #if targetEnvironment(simulator)
        centralManager = CBCentralManagerMock(delegate: self, queue: nil)
        #else
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
        #endif
    }
    
    private func resetConfigure() {
        withAnimation {
            isSearching = false
            isConnected = false
            
            foundPeripherals = []
            foundServices = []
            foundCharacteristics = []
        }
    }
    
    //Control Func
    func startScan() {
        let scanOption = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        centralManager?.scanForPeripherals(withServices: [CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")], options: scanOption)
        print("# Start Scan")
        isSearching = true
    }
    
    func stopScan(){
        disconnectPeripheral()
        centralManager?.stopScan()
        print("# Stop Scan")
        isSearching = false
    }
    
    func connectPeripheral(_ selectPeripheral: Peripheral?) {
        guard let connectPeripheral = selectPeripheral else { return }
        connectedPeripheral = selectPeripheral
        centralManager.connect(connectPeripheral.peripheral, options: nil)
    }
    
    func disconnectPeripheral() {
        guard let connectedPeripheral = connectedPeripheral else { return }
        centralManager.cancelPeripheralConnection(connectedPeripheral.peripheral)
    }
    
    //MARK: CoreBluetooth CentralManager Delegete Func
    func didUpdateState(_ central: CBCentralManagerProtocol) {
        if central.state == .poweredOn {
            isBlePower = true
        } else {
            isBlePower = false
        }
    }
    
    func didDiscover(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, advertisementData: [String : Any], rssi: NSNumber) {
        if rssi.intValue >= 0 { return }
        
        let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? nil
        var _name = "NoName"
        
        if peripheralName != nil {
            _name = String(peripheralName!)
        } else if peripheral.name != nil {
            _name = String(peripheral.name!)
        }
      
        let foundPeripheral: Peripheral = Peripheral(_peripheral: peripheral,
                                                     _name: _name,
                                                     _advData: advertisementData,
                                                     _rssi: rssi,
                                                     _discoverCount: 0)
        
        if let index = foundPeripherals.firstIndex(where: { $0.peripheral.identifier.uuidString == peripheral.identifier.uuidString }) {
            if foundPeripherals[index].discoverCount % 50 == 0 {
                foundPeripherals[index].name = _name
                foundPeripherals[index].rssi = rssi.intValue
                foundPeripherals[index].discoverCount += 1
            } else {
                foundPeripherals[index].discoverCount += 1
            }
        } else {
            foundPeripherals.append(foundPeripheral)
            DispatchQueue.main.async { self.isSearching = false }
        }
    }
    
    func didConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        guard let connectedPeripheral = connectedPeripheral else { return }
        isConnected = true
        connectedPeripheral.peripheral.delegate = self
        connectedPeripheral.peripheral.discoverServices(nil)
    }
    
    func didFailToConnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        disconnectPeripheral()
    }
    
    func didDisconnect(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol, error: Error?) {
        print("disconnect")
        resetConfigure()
    }
    
    func connectionEventDidOccur(_ central: CBCentralManagerProtocol, event: CBConnectionEvent, peripheral: CBPeripheralProtocol) {
        
    }
    
    func didUpdateANCSAuthorization(_ central: CBCentralManagerProtocol, peripheral: CBPeripheralProtocol) {
        
    }
    
    //MARK: CoreBluetooth Peripheral Delegate Func
    func didDiscoverServices(_ peripheral: CBPeripheralProtocol, error: Error?) {
        peripheral.services?.forEach { service in
            let setService = Service(_uuid: service.uuid, _service: service)
            
            foundServices.append(setService)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func didDiscoverCharacteristics(_ peripheral: CBPeripheralProtocol, service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")) || characteristic.uuid.isEqual(CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")) {
//            if characteristic.uuid.isEqual(CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")) {
                var characteristicASCIIValue = NSString()

                if characteristic.uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")){

                    let characteristicValue = characteristic.value ?? Data(base64Encoded: "NoData")
                    let ASCIIstring = NSString(data: characteristicValue!, encoding: String.Encoding.utf8.rawValue)
                    characteristicASCIIValue = ASCIIstring!
                }

                let setCharacteristic: Characteristic = Characteristic(_characteristic: characteristic,
                                                                       _description: "",
                                                                       _uuid: characteristic.uuid,
                                                                       _readValue: characteristic.uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")) ? characteristicASCIIValue as String : "",
                                                                       _service: characteristic.service!)
                foundCharacteristics.append(setCharacteristic)
                peripheral.readValue(for: characteristic)
            }
        }
    }

    func didUpdateValue(_ peripheral: CBPeripheralProtocol, characteristic: CBCharacteristic, error: Error?) {
        var characteristicASCIIValue = NSString()

        guard characteristic.uuid.isEqual(CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")),

              let characteristicValue = characteristic.value,
              let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

          characteristicASCIIValue = ASCIIstring

        print("Value Recieved: \((characteristicASCIIValue as String))")

        NotificationCenter.default.post(name:NSNotification.Name("Notify"), object: "\((characteristicASCIIValue as String))")
        if let index = foundCharacteristics.firstIndex(where: { $0.uuid == characteristic.uuid }) {
            foundCharacteristics[index].readValue = characteristicASCIIValue as String
        }
    }
    
    func didWriteValue(_ peripheral: CBPeripheralProtocol, descriptor: CBDescriptor, error: Error?) {
        guard error == nil else {
                print("Error discovering services: error")
                return
            }
        print("Function: \(#function),Line: \(#line)")
        print("Message sent")
    }
}
