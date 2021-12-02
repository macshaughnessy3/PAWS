//
//  Service.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 11/15/21.
//
import CoreBluetooth

class Service: Identifiable {
    var id: UUID
    var uuid: CBUUID
    var service: CBService

    init(_uuid: CBUUID,
         _service: CBService) {
        
        id = UUID()
        uuid = _uuid
        service = _service
    }
}
