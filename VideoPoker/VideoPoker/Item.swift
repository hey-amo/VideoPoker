//
//  Item.swift
//  VideoPoker
//
//  Created by Amarjit on 08/04/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
