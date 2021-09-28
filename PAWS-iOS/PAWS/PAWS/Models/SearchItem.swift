//
//  SearchItem.swift
//  PAWS
//
//  Created by Mac Shaughnessy on 9/28/21.
//

import Foundation
import CoreData

enum Priority: Int {
    case low = 0
    case normal = 1
    case high = 2
}

struct SearchItem: Identifiable {
    var id = UUID()
    var name: String = ""
    var priorityNum: Priority = .normal
    var isComplete: Bool = false
}
