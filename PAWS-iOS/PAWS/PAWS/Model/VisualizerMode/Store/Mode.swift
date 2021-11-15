//
//  Mode.swift
//  PAWS
//
//  Created by macseansc3 on 11/9/21.
//
import Foundation
import CoreData

@objc(Mode)

public class Mode : NSManagedObject
{
    public let id = UUID().uuidString
    @NSManaged public var title             : String
    @NSManaged public var mode              : Int16
    @NSManaged public var newModeColorR     : Double
    @NSManaged public var newModeColorG     : Double
    @NSManaged public var newModeColorB     : Double
    @NSManaged public var modeDescription   : String
    @NSManaged public var displayMode       : Int16
    @NSManaged public var message           : String
    @NSManaged public var color             : String
    @NSManaged public var createdAt         : Date
}

extension Mode: Identifiable {

}
//
//extension Mode?: Identifiable {
//    public var id: ObjectIdentifier {
//        return UUID().uuidString
//    }
//}

extension Mode {
    var displayModeAsInt: Int {
        get {
//            guard let displayMode = self.displayMode else { return 0 }
            return Int(truncating: NSNumber(value: displayMode))
        }
        set {
            self.displayMode = Int16(truncating: NSNumber(value: newValue))
        }
    }
}
