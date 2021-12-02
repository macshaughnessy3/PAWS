//
//  Mock.swift
//  factory-tourguide-iOS
//
//  Created by Mac Shaughnessy on 11/08/21.
//

import Foundation

protocol Mock {}

extension Mock {
    var className: String {
        return String(describing: type(of: self))
    }
    
    func log(_ message: String? = nil) {
        print("Mocked -", className, message ?? "")
    }
}
